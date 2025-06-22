const {DataTypes} = require("sequelize");
const sequelize = require("../config/database");

const ComidaPecera = sequelize.define("ComidaPecera", {
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
        onDelete: 'RESTRICT'
    },
    comidaId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: 'comidas',
            key: 'id'
        },
        onDelete: 'RESTRICT'
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

module.exports = ComidaPecera;
