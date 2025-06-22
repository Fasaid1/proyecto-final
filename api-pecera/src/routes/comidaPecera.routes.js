const express = require('express')
const router = express.Router()
const comidaPeceraController = require('../controllers/comidaPeceraController')

router.get('/', comidaPeceraController.getAllComidaPecera)
router.get('/:id', comidaPeceraController.getComidaPeceraById)
router.post('/', comidaPeceraController.createComidaPecera)
router.put('/:id', comidaPeceraController.updateComidaPecera)
router.delete('/:id', comidaPeceraController.deleteComidaPecera)

module.exports = router