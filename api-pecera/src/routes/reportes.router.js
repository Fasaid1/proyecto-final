const express = require('express');
const router = express.Router();
const reportesController = require('../controllers/reportesController');


router.get('/inventario-comida', reportesController.getReporteInventarioComida);
router.get('/control-parametros', reportesController.getReporteControlParametros);
router.get('/estadisticas-generales', reportesController.getEstadisticasGenerales);

module.exports = router;