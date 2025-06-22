import 'peceraModel.dart';

class Comida {
  final int? id;
  final String? nombreComida;
  final String? marcaComida;
  final double? cantidad;
  final bool? estado;
  final List<Pecera>? peceras;

  Comida({
    this.id,
    this.nombreComida,
    this.marcaComida,
    this.cantidad,
    this.estado,
    this.peceras,
  });

  factory Comida.fromJson(Map<String, dynamic> json) => Comida(
        id: json["id"],
        nombreComida: json["nombreComida"] ?? "",
        marcaComida: json["marcaComida"] ?? "",
        cantidad: json["cantidad"].toDouble() ?? 0,
        estado: json["estado"] ?? false,
        peceras: json["peceras"] == null
            ? []
            : List<Pecera>.from(json["peceras"].map((x) => Pecera.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombreComida": nombreComida,
        "marcaComida": marcaComida,
        "cantidad": cantidad,
        "estado": estado,
        "peceras": peceras?.map((x) => x.toJson()).toList(),
      };
}
