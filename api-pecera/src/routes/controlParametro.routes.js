const express = require('express')
const router = express.Router()
const controlParametroController = require('../controllers/controlParametroController')

router.get('/', controlParametroController.getAllControlParametros)
router.get('/getAll/:id', controlParametroController.getAllControlParametrosById)
router.get('/:id', controlParametroController.getControlParametrosById)
router.post('/', controlParametroController.createControlParametros)
router.put('/:id', controlParametroController.updateControlParametros)
router.delete('/:id', controlParametroController.deleteControlParametros)

module.exports = router