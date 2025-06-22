const Comida = require("../models/comida")
const Pecera = require("../models/pecera")
const createError = require('http-errors');
const ComidaPecera = require("../models/comidaPecera");

const getAllComida = async () => {
    try {
        const comida = await Comida.findAll({
            include: {
                model: Pecera,
                as: 'peceras',
                through: { attributes: [] } // Esto excluye los datos de la tabla intermedia
            }
        });
        return comida;
    } catch (error) {
        throw error;
    }
}

const getComidaById = async (id) => {
    try {
        const comida = await Comida.findOne({
            where: {
                id: id
            }
        })
        return comida
    } catch (error) {
        throw error
    }
}

const createComida = async (data) => {
    try {
        const existeComida = await Comida.findOne({
            where: {
                nombreComida: data.nombreComida,
                marcaComida: data.marcaComida
            }
        })

        if (existeComida) {
            throw createError(409, 'La comida ya existe en el sistema')
        }

        const comida = await Comida.create(data)

        return {
            comida,
            message: 'Comida creada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const updateComida = async (data, id) => {
    try {
        const comida = await Comida.update(data, {
            where: {
                id: id
            }
        })

        return {
            comida,
            message: 'Comida actualizada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const deleteComida = async (id) => {
    try {
        const comidaCount = await ComidaPecera.count({
            where: { comidaId: id }
        });

        if (comidaCount > 0) {
            const error = new Error('No se puede eliminar esta comida porque está siendo utilizada en otras partes del sistema');
            error.status = 400;
            throw error;
        }

        const comida = await Comida.destroy({
            where: {
                id: id
            }
        })

        if (comida === 0) {
            const error = new Error('Comida no encontrada');
            error.status = 404;
            throw error;
        }

        return {
            comida,
            message: 'Comida eliminada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

module.exports = {
    getAllComida,
    getComidaById,
    createComida,
    updateComida,
    deleteComida
}