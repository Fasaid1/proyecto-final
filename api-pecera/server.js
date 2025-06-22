const express = require("express");
const app = express();
const cors = require("cors");
require("dotenv").config();

//cors abiertas a todo publico
app.use(cors({
    origin: true,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

//loguear todas las peticiones
app.use((req, res, next) => {
    console.log(`📡 Request: [${req.method}] ${req.originalUrl}`);
    next();
});

//middlewares base
app.use(express.json());
app.use(express.urlencoded({extended: true}));

//conectar a la base de datos
const sequelize = require("./src/config/database");

const Comida = require('./src/models/comida');
const Pecera = require('./src/models/pecera');
const ComidaPecera = require('./src/models/comidaPecera');
const ControlParametro = require('./src/models/controlParametros');

ControlParametro.belongsTo(Pecera, {
    foreignKey: 'peceraId',
    as: 'Pecera'
});

Pecera.hasMany(ControlParametro, {
    foreignKey: 'peceraId',
    as: 'controles'
});

ComidaPecera.belongsTo(Pecera, {
    foreignKey: 'peceraId',
    as: 'Pecera'
});

ComidaPecera.belongsTo(Comida, {
    foreignKey: 'comidaId',
    as: 'Comida'
});

Comida.belongsToMany(Pecera, {
    through: {
        model: ComidaPecera,
        unique: false
    },
    foreignKey: 'comidaId',
    otherKey: 'peceraId',
    as: 'peceras'
});

Pecera.belongsToMany(Comida, {
    through: {
        model: ComidaPecera,
        unique: false
    },
    foreignKey: 'peceraId',
    otherKey: 'comidaId',
    as: 'comidas'
});

sequelize.sync().then(() => {
    console.log("Base de datos sincronizada correctamente.");
}).catch((err) => {
    console.error("Error al sincronizar base de datos:", err.message);
});

//ruta de prueba
app.get("/", (req, res) => {
    res.send("Hola");
});

//rutas y middlewares
const indexRouter = require("./src/routes/index");
app.use('/', indexRouter);

//ruta 404 por defecto
app.use((req, res) => {
    res.status(404).json({message: "Ruta no encontrada"});
});

//manejo de errores en peticiones
app.use((err, req, res, next) => {
    const statusCode = err.status || 500;
    res.status(statusCode).json({
        status: 'error',
        message: err.message || 'Error interno del servidor'
    });
});

//iniciar servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Servidor escuchando en http://localhost:${PORT}`);
});