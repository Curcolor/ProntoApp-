class Negocio {
  final String id;
  final String nombre;
  final String? tipoNegocio;
  final String? direccion;
  final String? horaApertura;
  final String? horaCierre;
  final String? formatoEntrega;
  final String? terminosEntrega;
  final String? numeroWhatsapp;

  Negocio({
    required this.id,
    required this.nombre,
    this.tipoNegocio,
    this.direccion,
    this.horaApertura,
    this.horaCierre,
    this.formatoEntrega,
    this.terminosEntrega,
    this.numeroWhatsapp,
  });

  factory Negocio.fromJson(Map<String, dynamic> json) => Negocio(
        id: json['id'] as String? ?? 'main',
        nombre: json['nombre'] as String? ?? '',
        tipoNegocio: json['tipoNegocio'] as String?,
        direccion: json['direccion'] as String?,
        horaApertura: json['horaApertura'] as String?,
        horaCierre: json['horaCierre'] as String?,
        formatoEntrega: json['formatoEntrega'] as String?,
        terminosEntrega: json['terminosEntrega'] as String?,
        numeroWhatsapp: json['numeroWhatsapp'] as String?,
      );

  static Negocio empty() => Negocio(id: 'main', nombre: '');
}
