const peceraService = require('../repositories/peceraRepository')

const getAllPecera = async (req, res, next) => {
    try {
        const pecera = await peceraService.getAllPecera()
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const getPeceraById = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await peceraService.getPeceraById(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const createPecera = async (req, res, next) => {
    const {
        nombrePecera,
        cantidadPeces,
        cantidadOxigenoDisuelto,
        nivelAgua,
        fechaSiembra,
        estado,
        esDestacada,
        cantidadPh,
    } = req.body

    const data = {
        nombrePecera,
        cantidadPeces,
        cantidadOxigenoDisuelto,
        nivelAgua,
        fechaSiembra,
        estado,
        esDestacada,
        cantidadPh,
    }

    try {
        const pecera = await peceraService.createPecera(data)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const updatePecera = async (req, res, next) => {
    const id = req.params.id

    const {
        nombrePecera,
        cantidadPeces,
        cantidadOxigenoDisuelto,
        nivelAgua,
        fechaSiembra,
        estado,
        esDestacada,
        cantidadPh,
    } = req.body

    const data = {
        nombrePecera,
        cantidadPeces,
        cantidadOxigenoDisuelto,
        nivelAgua,
        fechaSiembra,
        estado,
        esDestacada,
        cantidadPh,
    }

    try {
        const pecera = await peceraService.updatePecera(data, id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const deletePecera = async (req, res, next) => {
    const id = req.params.id
    try {
        const pecera = await peceraService.deletePecera(id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
    }
}

const updateFeatured = async (req, res, next) => {
    const id = req.params.id

    const {
        esDestacada,
    } = req.body

    const data = {
        esDestacada,
    }

    try {
        const pecera = await peceraService.updateFeatured(data, id)
        return res.status(200).json(pecera)
    } catch (error) {
        next(error)
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