const ComidaPecera = require("../models/comidaPecera")
const Comida = require("../models/comida")
const sequelize = require("../config/database")
const createError = require('http-errors');

const getAllComidaPecera = async () => {
    try {
        const comidaPecera = await ComidaPecera.findAll()
        return comidaPecera
    } catch (error) {
        throw error
    }
}

const getComidaPeceraById = async (id) => {
    try {
        const comidaPecera = await ComidaPecera.findOne({
            where: {
                id: id
            }
        })
        return comidaPecera
    } catch (error) {
        throw error
    }
}

const createComidaPecera = async (data) => {
    const t = await sequelize.transaction()
    try {
        const {peceraId, comidaId, cantidad, estado} = data

        console.log('=== DEBUG createComidaPecera ===');
        console.log('Datos recibidos:', {peceraId, comidaId, cantidad, estado});
        console.log('Tipos:', {
            peceraId: typeof peceraId,
            comidaId: typeof comidaId,
            cantidad: typeof cantidad,
            estado: typeof estado
        });

        console.log('Intentando crear ComidaPecera...');
        const comidaPecera = await ComidaPecera.create({
            peceraId: peceraId,
            comidaId: comidaId,
            cantidad: cantidad,
            estado: estado
        }, {transaction: t})

        console.log('ComidaPecera creada exitosamente:', comidaPecera.toJSON());

        console.log('Buscando comida con ID:', comidaId);
        const comida = await Comida.findOne({
            where: {
                id: comidaId
            },
            transaction: t
        });

        console.log('Comida encontrada:', comida ? comida.toJSON() : 'No encontrada');

        if (!comida) {
            throw createError(409, 'Comida no encontrada')
        }

        if (comida.cantidad < cantidad) {
            throw createError(409, "Cantidad insuficiente de comida");
        }

        const nuevaCantidad = comida.cantidad - cantidad;
        console.log('Actualizando cantidad de comida:', {anterior: comida.cantidad, nueva: nuevaCantidad});

        await Comida.update(
            {cantidad: nuevaCantidad},
            {where: {id: comidaId}, transaction: t}
        );

        await t.commit();
        console.log('Transacción confirmada exitosamente');

        return {
            comidaPecera,
            message: 'Comida creada exitosamente'
        }
    } catch (error) {
        console.error('=== ERROR en createComidaPecera ===');
        console.error('Mensaje:', error.message);
        console.error('Nombre:', error.name);
        console.error('Stack completo:', error.stack);

        // Si es un error de Sequelize, mostrar más detalles
        if (error.name === 'SequelizeValidationError') {
            console.error('Errores de validación:', error.errors);
        }
        if (error.name === 'SequelizeUniqueConstraintError') {
            console.error('Constraint violado:', error.fields);
        }

        await t.rollback();
        throw error;
    }
}

const updateComidaPecera = async (data, id) => {
    try {
        const comidaPecera = await ComidaPecera.update(data, {
            where: {
                id: id
            }
        })

        return {
            comidaPecera,
            message: 'Comida actualizada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const deleteComidaPecera = async (id) => {
    try {
        const comidaPecera = await ComidaPecera.destroy({
            where: {
                id: id
            }
        })

        return {
            comidaPecera,
            message: 'Comida eliminada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

module.exports = {
    getAllComidaPecera,
    getComidaPeceraById,
    createComidaPecera,
    updateComidaPecera,
    deleteComidaPecera
}