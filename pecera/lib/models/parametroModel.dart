class ControlParametros {
  final int? id;
  final int? peceraId;
  final double? temperatura;
  final double? oxigenoDisuelto;
  final double? nitratos;
  final double? nitritos;
  final double? amoniaco;
  final double? densidadPeces;
  final double? nivelAgua;
  final bool? estado;
  final DateTime? createdAt;

  ControlParametros({
    this.id,
    this.peceraId,
    this.temperatura,
    this.oxigenoDisuelto,
    this.nitratos,
    this.nitritos,
    this.amoniaco,
    this.densidadPeces,
    this.nivelAgua,
    this.estado,
    this.createdAt
});

  factory ControlParametros.fromJson(Map<String, dynamic> json) => ControlParametros(
    id: json["id"],
    peceraId: json["peceraId"] ?? 0,
    temperatura: json["temperatura"].toDouble() ?? 0,
    oxigenoDisuelto: json["oxigenoDisuelto"].toDouble() ?? 0,
    nitratos: json["nitratos"].toDouble() ?? 0,
    nitritos: json["nitritos"].toDouble() ?? 0,
    amoniaco: json["amoniaco"].toDouble() ?? 0,
    densidadPeces: json["densidadPeces"].toDouble() ?? 0,
    nivelAgua: json["nivelAgua"].toDouble() ?? 0,
    estado: json["estado"] ?? false,
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "peceraId": peceraId,
    "temperatura": temperatura,
    "oxigenoDisuelto": oxigenoDisuelto,
    "nitratos": nitratos,
    "nitritos": nitritos,
    "amoniaco": amoniaco,
    "densidadPeces": densidadPeces,
    "nivelAgua": nivelAgua,
    "estado": estado
  };
}
