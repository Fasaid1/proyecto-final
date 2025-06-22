class Pecera {
  final int? id;
  final String? nombrePecera;
  final int? cantidadPeces;
  final double? cantidadPh;
  final double? cantidadOxigenoDisuelto;
  final double? nivelAgua;
  final DateTime? fechaSiembra;
  final bool? estado;
  final bool? esDestacada;

  Pecera(
      {this.id,
       this.nombrePecera,
       this.cantidadPeces,
       this.cantidadPh,
       this.cantidadOxigenoDisuelto,
       this.nivelAgua,
       this.fechaSiembra,
       this.estado,
       this.esDestacada});

  factory Pecera.fromJson(Map<String, dynamic> json) => Pecera(
      id: json["id"],
      nombrePecera: json["nombrePecera"] ?? "",
      cantidadPeces: json["cantidadPeces"] ?? 0,
      cantidadPh: json["cantidadPh"].toDouble() ?? 0.0,
      cantidadOxigenoDisuelto: json["cantidadOxigenoDisuelto"].toDouble() ?? 0.0,
      nivelAgua: json["nivelAgua"].toDouble() ?? 0.0,
      fechaSiembra: DateTime.parse(json["fechaSiembra"]),
      estado: json["estado"] ?? false,
      esDestacada: json["esDestacada"] ?? false);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombrePecera": nombrePecera,
        "cantidadPeces": cantidadPeces,
        "cantidadPh": cantidadPh,
        "cantidadOxigenoDisuelto": cantidadOxigenoDisuelto,
        "nivelAgua": nivelAgua,
        "fechaSiembra": fechaSiembra!.toIso8601String(),
        "estado": estado,
        "esDestacada": esDestacada
      };
}
