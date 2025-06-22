class ReporteInventarioComida {
  final EstadisticasInventario? estadisticas;
  final List<ComidaInventario>? inventario;

  ReporteInventarioComida({
    this.estadisticas,
    this.inventario,
  });

  factory ReporteInventarioComida.fromJson(Map<String, dynamic> json) =>
      ReporteInventarioComida(
        estadisticas: json["estadisticas"] != null
            ? EstadisticasInventario.fromJson(json["estadisticas"])
            : null,
        inventario: json["inventario"] != null
            ? List<ComidaInventario>.from(
                json["inventario"].map((x) => ComidaInventario.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "estadisticas": estadisticas?.toJson(),
        "inventario": inventario != null
            ? List<dynamic>.from(inventario!.map((x) => x.toJson()))
            : [],
      };
}

class EstadisticasInventario {
  final int? totalComidas;
  final int? comidasActivas;
  final int? comidasInactivas;
  final double? cantidadTotalStock;
  final DateTime? fechaGeneracion;

  EstadisticasInventario({
    this.totalComidas,
    this.comidasActivas,
    this.comidasInactivas,
    this.cantidadTotalStock,
    this.fechaGeneracion,
  });

  factory EstadisticasInventario.fromJson(Map<String, dynamic> json) =>
      EstadisticasInventario(
        totalComidas: json["totalComidas"] ?? 0,
        comidasActivas: json["comidasActivas"] ?? 0,
        comidasInactivas: json["comidasInactivas"] ?? 0,
        cantidadTotalStock: json["cantidadTotalStock"]?.toDouble() ?? 0.0,
        fechaGeneracion: json["fechaGeneracion"] != null
            ? DateTime.parse(json["fechaGeneracion"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "totalComidas": totalComidas,
        "comidasActivas": comidasActivas,
        "comidasInactivas": comidasInactivas,
        "cantidadTotalStock": cantidadTotalStock,
        "fechaGeneracion": fechaGeneracion?.toIso8601String(),
      };
}

class ComidaInventario {
  final int? id;
  final String? nombreComida;
  final String? marcaComida;
  final double? cantidadActual;
  final bool? estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<PeceraAsignacion>? peceras;

  ComidaInventario({
    this.id,
    this.nombreComida,
    this.marcaComida,
    this.cantidadActual,
    this.estado,
    this.createdAt,
    this.updatedAt,
    this.peceras,
  });

  factory ComidaInventario.fromJson(Map<String, dynamic> json) =>
      ComidaInventario(
        id: json["id"],
        nombreComida: json["nombreComida"] ?? "",
        marcaComida: json["marcaComida"] ?? "",
        cantidadActual: json["cantidadActual"]?.toDouble() ?? 0.0,
        estado: json["estado"] ?? false,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        peceras: json["peceras"] != null
            ? List<PeceraAsignacion>.from(
                json["peceras"].map((x) => PeceraAsignacion.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreComida": nombreComida,
        "marcaComida": marcaComida,
        "cantidadActual": cantidadActual,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "peceras": peceras != null
            ? List<dynamic>.from(peceras!.map((x) => x.toJson()))
            : [],
      };
}

class PeceraAsignacion {
  final int? id;
  final String? nombrePecera;
  final int? cantidadPeces;
  final bool? estadoPecera;
  final double? cantidadIngresada;
  final bool? estadoAsignacion;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PeceraAsignacion({
    this.id,
    this.nombrePecera,
    this.cantidadPeces,
    this.estadoPecera,
    this.cantidadIngresada,
    this.estadoAsignacion,
    this.createdAt,
    this.updatedAt,
  });

  factory PeceraAsignacion.fromJson(Map<String, dynamic> json) =>
      PeceraAsignacion(
        id: json["id"],
        nombrePecera: json["nombrePecera"] ?? "",
        cantidadPeces: json["cantidadPeces"] ?? 0,
        estadoPecera: json["estadoPecera"] ?? false,
        cantidadIngresada: json["cantidadIngresada"]?.toDouble() ?? 0.0,
        estadoAsignacion: json["estadoAsignacion"] ?? false,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombrePecera": nombrePecera,
        "cantidadPeces": cantidadPeces,
        "estadoPecera": estadoPecera,
        "cantidadIngresada": cantidadIngresada,
        "estadoAsignacion": estadoAsignacion,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class ReporteControlParametros {
  final EstadisticasParametros? estadisticas;
  final List<PeceraParametros>? peceras;

  ReporteControlParametros({
    this.estadisticas,
    this.peceras,
  });

  factory ReporteControlParametros.fromJson(Map<String, dynamic> json) =>
      ReporteControlParametros(
        estadisticas: json["estadisticas"] != null
            ? EstadisticasParametros.fromJson(json["estadisticas"])
            : null,
        peceras: json["peceras"] != null
            ? List<PeceraParametros>.from(
                json["peceras"].map((x) => PeceraParametros.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "estadisticas": estadisticas?.toJson(),
        "peceras": peceras != null
            ? List<dynamic>.from(peceras!.map((x) => x.toJson()))
            : [],
      };
}

class EstadisticasParametros {
  final int? totalPeceras;
  final int? pecerasDestacadas;
  final int? totalPeces;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final DateTime? fechaGeneracion;

  EstadisticasParametros({
    this.totalPeceras,
    this.pecerasDestacadas,
    this.totalPeces,
    this.fechaInicio,
    this.fechaFin,
    this.fechaGeneracion,
  });

  factory EstadisticasParametros.fromJson(Map<String, dynamic> json) =>
      EstadisticasParametros(
        totalPeceras: json["totalPeceras"] ?? 0,
        pecerasDestacadas: json["pecerasDestacadas"] ?? 0,
        totalPeces: json["totalPeces"] ?? 0,
        fechaInicio: json["fechaInicio"] != null
            ? DateTime.parse(json["fechaInicio"])
            : null,
        fechaFin:
            json["fechaFin"] != null ? DateTime.parse(json["fechaFin"]) : null,
        fechaGeneracion: json["fechaGeneracion"] != null
            ? DateTime.parse(json["fechaGeneracion"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "totalPeceras": totalPeceras,
        "pecerasDestacadas": pecerasDestacadas,
        "totalPeces": totalPeces,
        "fechaInicio": fechaInicio?.toIso8601String(),
        "fechaFin": fechaFin?.toIso8601String(),
        "fechaGeneracion": fechaGeneracion?.toIso8601String(),
      };
}

class PeceraParametros {
  final int? id;
  final String? nombrePecera;
  final int? cantidadPeces;
  final ParametrosActuales? parametrosActuales;
  final DateTime? fechaSiembra;
  final bool? estado;
  final bool? esDestacada;
  final EstadisticasPecera? estadisticas;
  final List<ControlParametro>? historialControles;

  PeceraParametros({
    this.id,
    this.nombrePecera,
    this.cantidadPeces,
    this.parametrosActuales,
    this.fechaSiembra,
    this.estado,
    this.esDestacada,
    this.estadisticas,
    this.historialControles,
  });

  factory PeceraParametros.fromJson(Map<String, dynamic> json) =>
      PeceraParametros(
        id: json["id"],
        nombrePecera: json["nombrePecera"] ?? "",
        cantidadPeces: json["cantidadPeces"] ?? 0,
        parametrosActuales: json["parametrosActuales"] != null
            ? ParametrosActuales.fromJson(json["parametrosActuales"])
            : null,
        fechaSiembra: json["fechaSiembra"] != null
            ? DateTime.parse(json["fechaSiembra"])
            : null,
        estado: json["estado"] ?? false,
        esDestacada: json["esDestacada"] ?? false,
        estadisticas: json["estadisticas"] != null
            ? EstadisticasPecera.fromJson(json["estadisticas"])
            : null,
        historialControles: json["historialControles"] != null
            ? List<ControlParametro>.from(json["historialControles"]
                .map((x) => ControlParametro.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombrePecera": nombrePecera,
        "cantidadPeces": cantidadPeces,
        "parametrosActuales": parametrosActuales?.toJson(),
        "fechaSiembra": fechaSiembra?.toIso8601String(),
        "estado": estado,
        "esDestacada": esDestacada,
        "estadisticas": estadisticas?.toJson(),
        "historialControles": historialControles != null
            ? List<dynamic>.from(historialControles!.map((x) => x.toJson()))
            : [],
      };
}

class ParametrosActuales {
  final double? cantidadPh;
  final double? cantidadOxigenoDisuelto;
  final double? nivelAgua;

  ParametrosActuales({
    this.cantidadPh,
    this.cantidadOxigenoDisuelto,
    this.nivelAgua,
  });

  factory ParametrosActuales.fromJson(Map<String, dynamic> json) =>
      ParametrosActuales(
        cantidadPh: json["cantidadPh"]?.toDouble() ?? 0.0,
        cantidadOxigenoDisuelto:
            json["cantidadOxigenoDisuelto"]?.toDouble() ?? 0.0,
        nivelAgua: json["nivelAgua"]?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "cantidadPh": cantidadPh,
        "cantidadOxigenoDisuelto": cantidadOxigenoDisuelto,
        "nivelAgua": nivelAgua,
      };
}

class EstadisticasPecera {
  final int? totalMediciones;
  final DateTime? ultimaMedicion;
  final PromediosParametros? promedios;

  EstadisticasPecera({
    this.totalMediciones,
    this.ultimaMedicion,
    this.promedios,
  });

  factory EstadisticasPecera.fromJson(Map<String, dynamic> json) =>
      EstadisticasPecera(
        totalMediciones: json["totalMediciones"] ?? 0,
        ultimaMedicion: json["ultimaMedicion"] != null
            ? DateTime.parse(json["ultimaMedicion"])
            : null,
        promedios: json["promedios"] != null
            ? PromediosParametros.fromJson(json["promedios"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "totalMediciones": totalMediciones,
        "ultimaMedicion": ultimaMedicion?.toIso8601String(),
        "promedios": promedios?.toJson(),
      };
}

class PromediosParametros {
  final String? temperatura;
  final String? oxigenoDisuelto;
  final String? nitritos;
  final String? nitratos;
  final String? amoniaco;

  PromediosParametros({
    this.temperatura,
    this.oxigenoDisuelto,
    this.nitritos,
    this.nitratos,
    this.amoniaco,
  });

  factory PromediosParametros.fromJson(Map<String, dynamic> json) =>
      PromediosParametros(
        temperatura: json["temperatura"] ?? "0.00",
        oxigenoDisuelto: json["oxigenoDisuelto"] ?? "0.00",
        nitritos: json["nitritos"] ?? "0.00",
        nitratos: json["nitratos"] ?? "0.00",
        amoniaco: json["amoniaco"] ?? "0.00",
      );

  Map<String, dynamic> toJson() => {
        "temperatura": temperatura,
        "oxigenoDisuelto": oxigenoDisuelto,
        "nitritos": nitritos,
        "nitratos": nitratos,
        "amoniaco": amoniaco,
      };
}

class ControlParametro {
  final int? id;
  final double? temperatura;
  final double? oxigenoDisuelto;
  final double? nitritos;
  final double? nitratos;
  final double? amoniaco;
  final double? densidadPeces;
  final double? nivelAgua;
  final bool? estado;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ControlParametro({
    this.id,
    this.temperatura,
    this.oxigenoDisuelto,
    this.nitritos,
    this.nitratos,
    this.amoniaco,
    this.densidadPeces,
    this.nivelAgua,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  factory ControlParametro.fromJson(Map<String, dynamic> json) =>
      ControlParametro(
        id: json["id"],
        temperatura: json["temperatura"]?.toDouble() ?? 0.0,
        oxigenoDisuelto: json["oxigenoDisuelto"]?.toDouble() ?? 0.0,
        nitritos: json["nitritos"]?.toDouble() ?? 0.0,
        nitratos: json["nitratos"]?.toDouble() ?? 0.0,
        amoniaco: json["amoniaco"]?.toDouble() ?? 0.0,
        densidadPeces: json["densidadPeces"]?.toDouble() ?? 0.0,
        nivelAgua: json["nivelAgua"]?.toDouble() ?? 0.0,
        estado: json["estado"] ?? false,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "temperatura": temperatura,
        "oxigenoDisuelto": oxigenoDisuelto,
        "nitritos": nitritos,
        "nitratos": nitratos,
        "amoniaco": amoniaco,
        "densidadPeces": densidadPeces,
        "nivelAgua": nivelAgua,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
