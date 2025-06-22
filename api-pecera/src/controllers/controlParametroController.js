const controlParametroRepository = require('../repositories/controlParametroRepository')

const getAllControlParametros = async (req, res, next) => {
    try {
        const pecera = await controlParametroRepository.getAllControlParametros()
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const getControlParametrosById = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await controlParametroRepository.getControlParametrosById(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const createControlParametros = async (req, res, next) => {
    const {
        peceraId,
        temperatura,
        oxigenoDisuelto,
        nitratos,
        nitritos,
        amoniaco,
        densidadPeces,
        nivelAgua,
        estado,
    } = req.body

    const data = {
        peceraId,
        temperatura,
        oxigenoDisuelto,
        nitratos,
        nitritos,
        amoniaco,
        densidadPeces,
        nivelAgua,
        estado,
    }

    try {
        const pecera = await controlParametroRepository.createControlParametros(data)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const updateControlParametros = async (req, res, next) => {
    const id = req.params.id

    const {
        peceraId,
        temperatura,
        oxigenoDisuelto,
        nitratos,
        nitritos,
        amoniaco,
        densidadPeces,
        nivelAgua,
        estado,
    } = req.body

    const data = {
        peceraId,
        temperatura,
        oxigenoDisuelto,
        nitratos,
        nitritos,
        amoniaco,
        densidadPeces,
        nivelAgua,
        estado,
    }

    try {
        const pecera = await controlParametroRepository.updateControlParametros(data, id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const deleteControlParametros = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await controlParametroRepository.deleteControlParametros(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const getAllControlParametrosById = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await controlParametroRepository.getAllControlParametrosById(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

module.exports = {
    getAllControlParametros,
    getControlParametrosById,
    createControlParametros,
    updateControlParametros,
    deleteControlParametros,
    getAllControlParametrosById
}