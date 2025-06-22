const {DataTypes} = require("sequelize");
const sequelize = require("../config/database");

const Comida = sequelize.define("Comida", {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    nombreComida: {
        type: DataTypes.STRING,
        allowNull: true
    },
    marcaComida: {
        type: DataTypes.STRING,
        allowNull: true
    },
    cantidad: {
        type: DataTypes.DOUBLE,
        allowNull: true
    },
    estado: {
        type: DataTypes.BOOLEAN,
        allowNull: true
    }
});

module.exports = Comida;