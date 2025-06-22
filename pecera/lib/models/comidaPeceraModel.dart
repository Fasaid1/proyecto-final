class ComidaPecera {
  final int? id;
  final int? peceraId;
  final int? comidaId;
  final double? cantidad;
  final bool? estado;

  ComidaPecera({
    this.id,
    this.peceraId,
    this.comidaId,
    this.cantidad,
    this.estado,
  });

  factory ComidaPecera.fromJson(Map<String, dynamic> json) => ComidaPecera(
    id: json["id"],
    peceraId: json["peceraId"] ?? 0,
    comidaId: json["comidaId"] ?? 0,
    cantidad: json["cantidad"].toDouble() ?? 0,
    estado: json["estado"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "peceraId": peceraId,
    "comidaId": comidaId,
    "cantidad": cantidad,
    "estado": true,
  };
}
