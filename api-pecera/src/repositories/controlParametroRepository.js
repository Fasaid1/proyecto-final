const ControlParametros = require("../models/controlParametros")

const getAllControlParametros = async () => {
    try {
        const controlParametros = await ControlParametros.findAll()
        return controlParametros
    } catch (error) {
        throw error
    }
}

const getAllControlParametrosById = async (id) => {
    try {
        const controlParametros = await ControlParametros.findAll({
            where: {
                peceraId: id
            },
            order: [['id', 'DESC']]
        })
        return controlParametros
    } catch (error) {
        throw error
    }
}

const getControlParametrosById = async (id) => {
    try {
        const controlParametros = await ControlParametros.findOne({
            where: {
                id: id
            }
        })
        return controlParametros
    } catch (error) {
        throw error
    }
}

const createControlParametros = async (data) => {
    try {
        const controlParametros = await ControlParametros.create(data)

        return {
            controlParametros,
            message: 'Párametro creada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const updateControlParametros = async (data, id) => {
    try {
        const controlParametros = await ControlParametros.update(data, {
            where: {
                id: id
            }
        })

        return {
            controlParametros,
            message: 'Párametro actualizada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

const deleteControlParametros = async (id) => {
    try {
        const controlParametros = await ControlParametros.destroy({
            where: {
                id: id
            }
        })

        return {
            controlParametros,
            message: 'Párametro eliminada exitosamente'
        }

    } catch (error) {
        throw error
    }
}

module.exports = {
    getAllControlParametros,
    getControlParametrosById,
    createControlParametros,
    updateControlParametros,
    deleteControlParametros,
    getAllControlParametrosById,
}