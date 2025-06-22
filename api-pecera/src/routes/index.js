const {Router} = require('express')

const router = Router();

//importar rutas
const peceraRoutes = require('./pecera.routes')
const comidaRoutes = require('./comida.routes')
const comidaPeceraRoutes = require('./comidaPecera.routes')
const controlParametroRoutes = require('./controlParametro.routes')
const reportesRoutes = require('./reportes.router')

//rutas web
router.use('/api/pecera', peceraRoutes)
router.use('/api/comida', comidaRoutes)
router.use('/api/comidaPece', comidaPeceraRoutes)
router.use('/api/controlParametro', controlParametroRoutes)
router.use('/api/reporte', reportesRoutes)

module.exports = router