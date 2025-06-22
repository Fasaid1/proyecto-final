const reportesRepository = require('../repositories/reportesRepository');

const getReporteInventarioComida = async (req, res, next) => {
    try {
        const reporte = await reportesRepository.getReporteInventarioComida();

        return res.status(200).json({
            success: true,
            message: 'Reporte de inventario de comida generado exitosamente',
            data: reporte
        });
    } catch (error) {
        next(error);
    }
};

const getReporteControlParametros = async (req, res, next) => {
    try {
        const { fechaInicio, fechaFin } = req.query;

        let fechaInicioDate = null;
        let fechaFinDate = null;

        if (fechaInicio) {
            fechaInicioDate = new Date(fechaInicio);
            if (isNaN(fechaInicioDate.getTime())) {
                return res.status(400).json({
                    success: false,
                    message: 'Formato de fecha de inicio inválido. Use YYYY-MM-DD'
                });
            }
        }

        if (fechaFin) {
            fechaFinDate = new Date(fechaFin);
            if (isNaN(fechaFinDate.getTime())) {
                return res.status(400).json({
                    success: false,
                    message: 'Formato de fecha de fin inválido. Use YYYY-MM-DD'
                });
            }
        }

        if (fechaInicioDate && fechaFinDate && fechaInicioDate > fechaFinDate) {
            return res.status(400).json({
                success: false,
                message: 'La fecha de inicio no puede ser mayor que la fecha de fin'
            });
        }

        const reporte = await reportesRepository.getReporteControlParametros(fechaInicioDate, fechaFinDate);

        return res.status(200).json({
            success: true,
            message: 'Reporte de control de parámetros generado exitosamente',
            data: reporte
        });
    } catch (error) {
        next(error);
    }
};

const getEstadisticasGenerales = async (req, res, next) => {
    try {
        const [inventario, parametros] = await Promise.all([
            reportesRepository.getReporteInventarioComida(),
            reportesRepository.getReporteControlParametros()
        ]);

        const estadisticasResumen = {
            inventario: {
                totalComidas: inventario.estadisticas.totalComidas,
                comidasActivas: inventario.estadisticas.comidasActivas,
                cantidadTotalStock: inventario.estadisticas.cantidadTotalStock
            },
            peceras: {
                totalPeceras: parametros.estadisticas.totalPeceras,
                pecerasDestacadas: parametros.estadisticas.pecerasDestacadas,
                totalPeces: parametros.estadisticas.totalPeces
            },
            fechaGeneracion: new Date().toISOString()
        };

        return res.status(200).json({
            success: true,
            message: 'Estadísticas generales obtenidas exitosamente',
            data: estadisticasResumen
        });
    } catch (error) {
        next(error);
    }
};

module.exports = {
    getReporteInventarioComida,
    getReporteControlParametros,
    getEstadisticasGenerales
};