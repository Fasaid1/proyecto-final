const {DataTypes} = require("sequelize");
const sequelize = require("../config/database");

const Pecera = sequelize.define("Pecera", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombrePecera: {
        type: DataTypes.STRING,
        allowNull: true
    },
    cantidadPeces: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    cantidadPh: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    cantidadOxigenoDisuelto: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    nivelAgua: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    fechaSiembra: {
        type: DataTypes.DATEONLY,
        allowNull: true
    },
    estado: {
        type: DataTypes.BOOLEAN,
        allowNull: true
    },
    esDestacada: {
        type: DataTypes.BOOLEAN,
        allowNull: true
    }
});

module.exports = Pecera;