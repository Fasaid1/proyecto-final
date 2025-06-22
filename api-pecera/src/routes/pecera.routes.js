const express = require('express')
const router = express.Router()
const peceraController = require('../controllers/peceraController')

router.get('/', peceraController.getAllPecera)
router.get('/:id', peceraController.getPeceraById)
router.post('/', peceraController.createPecera)
router.put('/:id', peceraController.updatePecera)
router.delete('/:id', peceraController.deletePecera)
router.put('/destacada/:id', peceraController.updateFeatured)

module.exports = router