const comidaPeceraRepository = require('../repositories/comidaPeceraRepository')

const getAllComidaPecera = async (req, res, next) => {
    try {
        const pecera = await comidaPeceraRepository.getAllComidaPecera()
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const getComidaPeceraById = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await comidaPeceraRepository.getComidaPeceraById(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const createComidaPecera = async (req, res, next) => {
    const {
        peceraId,
        comidaId,
        cantidad,
        estado
    } = req.body

    const data = {
        peceraId,
        comidaId,
        cantidad,
        estado
    }

    try {
        const pecera = await comidaPeceraRepository.createComidaPecera(data)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const updateComidaPecera = async (req, res, next) => {
    const id = req.params.id

    const {
        peceraId,
        comidaId,
        cantidad,
        estado
    } = req.body

    const data = {
        peceraId,
        comidaId,
        cantidad,
        estado
    }

    try {
        const pecera = await comidaPeceraRepository.updateComidaPecera(data, id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const deleteComidaPecera = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await comidaPeceraRepository.deleteComidaPecera(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

module.exports = {
    getAllComidaPecera,
    getComidaPeceraById,
    createComidaPecera,
    updateComidaPecera,
    deleteComidaPecera
}