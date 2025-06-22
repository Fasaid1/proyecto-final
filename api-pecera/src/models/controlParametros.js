const { DataTypes } = require("sequelize");
const sequelize = require("../config/database");

const ControlParametro = sequelize.define("ControlParametro", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    peceraId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'peceras',
            key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'RESTRICT'
    },
    temperatura: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    oxigenoDisuelto: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    nitritos: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    nitratos: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    amoniaco: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    densidadPeces: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    nivelAgua: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    estado: {
        type: DataTypes.BOOLEAN,
        allowNull: true
    }
});

module.exports = ControlParametro;
