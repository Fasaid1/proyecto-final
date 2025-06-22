const Comida = require("../models/comida");
const Pecera = require("../models/pecera");
const ComidaPecera = require("../models/comidaPecera");
const ControlParametro = require("../models/controlParametros");
const { Op } = require('sequelize');

const getReporteInventarioComida = async () => {
    try {
        const comidas = await Comida.findAll({
            attributes: [
                'id',
                'nombreComida',
                'marcaComida',
                'cantidad',
                'estado',
                'createdAt',
                'updatedAt'
            ],
            order: [['nombreComida', 'ASC']]
        });

        const comidasConHistorial = await Promise.all(
            comidas.map(async (comida) => {
                const asignaciones = await ComidaPecera.findAll({
                    where: {
                        comidaId: comida.id
                    },
                    include: [
                        {
                            model: Pecera,
                            as: 'Pecera',
                            attributes: ['id', 'nombrePecera', 'cantidadPeces', 'estado']
                        }
                    ],
                    attributes: ['id', 'cantidad', 'estado', 'createdAt', 'updatedAt'],
                    order: [['createdAt', 'DESC']]
                });

                const pecerasHistorial = asignaciones.map(asignacion => ({
                    id: asignacion.Pecera.id,
                    nombrePecera: asignacion.Pecera.nombrePecera,
                    cantidadPeces: asignacion.Pecera.cantidadPeces,
                    estadoPecera: asignacion.Pecera.estado,
                    cantidadIngresada: asignacion.cantidad,
                    estadoAsignacion: asignacion.estado,
                    createdAt: asignacion.createdAt,
                    updatedAt: asignacion.updatedAt
                }));

                return {
                    id: comida.id,
                    nombreComida: comida.nombreComida,
                    marcaComida: comida.marcaComida,
                    cantidadActual: comida.cantidad,
                    estado: comida.estado,
                    createdAt: comida.createdAt,
                    updatedAt: comida.updatedAt,
                    peceras: pecerasHistorial
                };
            })
        );

        const estadisticas = {
            totalComidas: comidas.length,
            comidasActivas: comidas.filter(c => c.estado === true).length,
            comidasInactivas: comidas.filter(c => c.estado === false).length,
            cantidadTotalStock: comidas.reduce((sum, c) => sum + (c.cantidad || 0), 0),
            fechaGeneracion: new Date().toISOString()
        };

        return {
            estadisticas,
            inventario: comidasConHistorial
        };

    } catch (error) {
        throw error;
    }
};

const getReporteControlParametros = async (fechaInicio = null, fechaFin = null) => {
    try {
        const fechaFinDefault = fechaFin || new Date();
        const fechaInicioDefault = fechaInicio || new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);

        const peceras = await Pecera.findAll({
            attributes: [
                'id',
                'nombrePecera',
                'cantidadPeces',
                'cantidadPh',
                'cantidadOxigenoDisuelto',
                'nivelAgua',
                'fechaSiembra',
                'estado',
                'esDestacada'
            ],
            where: {
                estado: true
            },
            order: [['nombrePecera', 'ASC']]
        });

        const pecerasConHistorial = await Promise.all(
            peceras.map(async (pecera) => {
                const controles = await ControlParametro.findAll({
                    where: {
                        peceraId: pecera.id,
                        createdAt: {
                            [Op.between]: [fechaInicioDefault, fechaFinDefault]
                        }
                    },
                    attributes: [
                        'id',
                        'temperatura',
                        'oxigenoDisuelto',
                        'nitritos',
                        'nitratos',
                        'amoniaco',
                        'densidadPeces',
                        'nivelAgua',
                        'estado',
                        'createdAt',
                        'updatedAt'
                    ],
                    order: [['createdAt', 'DESC']]
                });

                // Calcular estadísticas de la pecera
                const estadisticasPecera = {
                    totalMediciones: controles.length,
                    ultimaMedicion: controles.length > 0 ? controles[0].createdAt :new Date().toISOString(),
                    promedios: {
                        temperatura: controles.length > 0 ?
                            (controles.reduce((sum, c) => sum + (c.temperatura || 0), 0) / controles.length).toFixed(2) : 0,
                        oxigenoDisuelto: controles.length > 0 ?
                            (controles.reduce((sum, c) => sum + (c.oxigenoDisuelto || 0), 0) / controles.length).toFixed(2) : 0,
                        nitritos: controles.length > 0 ?
                            (controles.reduce((sum, c) => sum + (c.nitritos || 0), 0) / controles.length).toFixed(2) : 0,
                        nitratos: controles.length > 0 ?
                            (controles.reduce((sum, c) => sum + (c.nitratos || 0), 0) / controles.length).toFixed(2) : 0,
                        amoniaco: controles.length > 0 ?
                            (controles.reduce((sum, c) => sum + (c.amoniaco || 0), 0) / controles.length).toFixed(2) : 0
                    }
                };

                return {
                    id: pecera.id,
                    nombrePecera: pecera.nombrePecera,
                    cantidadPeces: pecera.cantidadPeces,
                    parametrosActuales: {
                        cantidadPh: pecera.cantidadPh,
                        cantidadOxigenoDisuelto: pecera.cantidadOxigenoDisuelto,
                        nivelAgua: pecera.nivelAgua
                    },
                    fechaSiembra: pecera.fechaSiembra,
                    estado: pecera.estado,
                    esDestacada: pecera.esDestacada,
                    estadisticas: estadisticasPecera,
                    historialControles: controles
                };
            })
        );

        const estadisticasGenerales = {
            totalPeceras: peceras.length,
            pecerasDestacadas: peceras.filter(p => p.esDestacada === true).length,
            totalPeces: peceras.reduce((sum, p) => sum + (p.cantidadPeces || 0), 0),
            fechaInicio: fechaInicioDefault,
            fechaFin: fechaFinDefault,
            fechaGeneracion: new Date().toISOString()
        };

        return {
            estadisticas: estadisticasGenerales,
            peceras: pecerasConHistorial
        };

    } catch (error) {
        throw error;
    }
};

module.exports = {
    getReporteInventarioComida,
    getReporteControlParametros
};