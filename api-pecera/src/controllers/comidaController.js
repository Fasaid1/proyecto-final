const comidaRepository = require('../repositories/comidaRepository')

const getAllComida = async (req, res, next) => {
    try {
        const pecera = await comidaRepository.getAllComida()
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const getComidaById = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await comidaRepository.getComidaById(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const createComida = async (req, res, next) => {
    const {
        nombreComida,
        marcaComida,
        cantidad,
        estado
    } = req.body

    const data = {
        nombreComida,
        marcaComida,
        cantidad,
        estado
    }

    try {
        const pecera = await comidaRepository.createComida(data)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const updateComida = async (req, res, next) => {
    const id = req.params.id

    const {
        nombreComida,
        marcaComida,
        cantidad,
        estado
    } = req.body

    const data = {
        nombreComida,
        marcaComida,
        cantidad,
        estado
    }

    try {
        const pecera = await comidaRepository.updateComida(data, id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const deleteComida = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await comidaRepository.deleteComida(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

module.exports = {
    getAllComida,
    getComidaById,
    createComida,
    updateComida,
    deleteComida
}