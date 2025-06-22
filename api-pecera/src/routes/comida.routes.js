const express = require('express')
const router = express.Router()
const comidaController = require('../controllers/comidaController')

router.get('/', comidaController.getAllComida)
router.get('/:id', comidaController.getComidaById)
router.post('/', comidaController.createComida)
router.put('/:id', comidaController.updateComida)
router.delete('/:id', comidaController.deleteComida)

module.exports = router