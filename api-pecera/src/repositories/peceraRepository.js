const Pecera = require("../models/pecera")
const ControlParametro = require("../models/controlParametros")
const ComidaPecera = require("../models/comidaPecera")
const createError = require('http-errors');

const getAllPecera = async () => {
    try {
        const pecera = await Pecera.findAll({
            order: [['esDestacada', 'DESC']]
        });
        return pecera
    } catch (error) {
        throw error
    }
}

const getPeceraById = async (id) => {
    try {
        const pecera = await Pecera.findOne({
            where: {
                id: id
            }
        })
        return pecera
    } catch (error) {
        throw error
    }
}

const createPecera = async (data) => {
    try {
        const existePecera = await Pecera.findOne({
            where: {
                nombrePecera: data.nombrePecera
            }
        })

        if (existePecera) {
            throw createError(409, 'La pecera ya existe en el sistema')
        }

        const pecera = await Pecera.create(data)

        return {
            pecera,
            message: 'Pecera creada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const updatePecera = async (data, id) => {
    try {
        const pecera = await Pecera.update(data, {
            where: {
                id: id
            }
        })

        return {
            pecera,
            message: 'Pecera actualizada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const deletePecera = async (id) => {
    try {
        const parametrosCount = await ControlParametro.count({
            where: { peceraId: id }
        });

        const comidaCount = await ComidaPecera.count({
            where: { peceraId: id }
        });

        if (parametrosCount > 0 || comidaCount > 0) {
            const error = new Error('No se puede eliminar la pecera porque está siendo utilizada en otras partes del sistema');
            error.status = 400;
            throw error;
        }

        const pecera = await Pecera.destroy({
            where: {
                id: id
            }
        });

        if (pecera === 0) {
            const error = new Error('Pecera no encontrada');
            error.status = 404;
            throw error;
        }

        return {
            pecera,
            message: 'Pecera eliminada exitosamente'
        };

    } catch (error) {
        throw error;
    }
};

const updateFeatured = async (data, id) => {
    try {
        const pecera = await Pecera.update(data, {
            where: {
                id: id
            }
        })

        return {
            pecera,
            message: 'Pecera destacada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

module.exports = {
    getAllPecera,
    getPeceraById,
    createPecera,
    updatePecera,
    deletePecera,
    updateFeatured,
}