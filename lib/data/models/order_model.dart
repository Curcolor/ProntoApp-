/// Modelos de datos para el sistema de pedidos de ProntoApp.
/// Los pedidos provienen del bot de Telegram vía el servidor FastAPI.
library;

// ─── Enums ────────────────────────────────────────────────────────────────────

/// Estado del ciclo de vida de un pedido.
enum EstadoPedido {
  recibido,
  enPreparacion,
  listo,
  enCamino,
  entregado;

  /// Nombre legible en español para mostrar en la UI.
  String get etiqueta {
    switch (this) {
      case EstadoPedido.recibido:
        return 'Recibido';
      case EstadoPedido.enPreparacion:
        return 'Preparando';
      case EstadoPedido.listo:
        return 'Listo';
      case EstadoPedido.enCamino:
        return 'En camino';
      case EstadoPedido.entregado:
        return 'Entregado';
    }
  }

  /// Siguiente estado en el ciclo de vida, o null si ya está en el final.
  EstadoPedido? get siguiente {
    switch (this) {
      case EstadoPedido.recibido:
        return EstadoPedido.enPreparacion;
      case EstadoPedido.enPreparacion:
        return EstadoPedido.listo;
      case EstadoPedido.listo:
        return EstadoPedido.enCamino;
      case EstadoPedido.enCamino:
        return EstadoPedido.entregado;
      case EstadoPedido.entregado:
        return null;
    }
  }

  /// Clave string que se envía al FastAPI.
  String get claveApi {
    switch (this) {
      case EstadoPedido.recibido:
        return 'recibido';
      case EstadoPedido.enPreparacion:
        return 'en_preparacion';
      case EstadoPedido.listo:
        return 'listo';
      case EstadoPedido.enCamino:
        return 'en_camino';
      case EstadoPedido.entregado:
        return 'entregado';
    }
  }

  /// Construye un EstadoPedido desde la clave string del FastAPI.
  static EstadoPedido desdeApi(String clave) {
    switch (clave) {
      case 'en_preparacion':
        return EstadoPedido.enPreparacion;
      case 'listo':
        return EstadoPedido.listo;
      case 'en_camino':
        return EstadoPedido.enCamino;
      case 'entregado':
        return EstadoPedido.entregado;
      default:
        return EstadoPedido.recibido;
    }
  }
}

/// Tipo de entrega del pedido.
enum TipoPedido {
  domicilio,
  recoger;

  String get etiqueta =>
      this == TipoPedido.domicilio ? '📍 Domicilio' : '🏪 Para recoger';

  static TipoPedido desdeString(String valor) =>
      valor == 'domicilio' ? TipoPedido.domicilio : TipoPedido.recoger;
}

// ─── Modelos ──────────────────────────────────────────────────────────────────

/// Un ítem dentro de un pedido (producto + cantidad).
class ItemPedido {
  /// Nombre del producto.
  final String nombre;

  /// Cantidad solicitada.
  final int cantidad;

  /// Precio unitario en pesos.
  final double precio;

  const ItemPedido({
    required this.nombre,
    required this.cantidad,
    required this.precio,
  });

  /// Subtotal de este ítem.
  double get subtotal => cantidad * precio;

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      nombre: json['nombre'] as String? ?? '',
      cantidad: (json['cantidad'] as num?)?.toInt() ?? 1,
      precio: (json['precio'] as num?)?.toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'cantidad': cantidad,
        'precio': precio,
      };
}

/// Pedido completo recibido desde el bot de Telegram.
class OrderModel {
  /// Identificador único del pedido (ej: "P-A1B2C3D4").
  final String id;

  /// Nombre del cliente.
  final String cliente;

  /// Identificador de Telegram del cliente (ej: "tg:12345678").
  final String telefono;

  /// Lista de productos pedidos.
  final List<ItemPedido> items;

  /// Total en pesos del pedido.
  final double total;

  /// Estado actual en el ciclo de vida.
  final EstadoPedido estado;

  /// Tipo de entrega.
  final TipoPedido tipo;

  /// Dirección de entrega (solo para domicilio).
  final String? direccion;

  /// Fecha y hora en que se creó el pedido.
  final DateTime creadoEn;

  const OrderModel({
    required this.id,
    required this.cliente,
    required this.telefono,
    required this.items,
    required this.total,
    required this.estado,
    required this.tipo,
    this.direccion,
    required this.creadoEn,
  });

  /// Letra inicial del cliente para el avatar de la UI.
  String get inicialCliente =>
      cliente.isNotEmpty ? cliente[0].toUpperCase() : '?';

  /// Cuántos minutos han pasado desde que se creó el pedido.
  int get minutosTranscurridos =>
      DateTime.now().difference(creadoEn).inMinutes;

  /// Texto legible de los ítems para mostrar en tarjetas.
  String get resumenItems =>
      items.map((i) => '${i.cantidad}× ${i.nombre}').join(' · ');

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: json['id'] as String? ?? '',
      cliente: json['cliente'] as String? ?? 'Cliente',
      telefono: json['telefono'] as String? ?? '',
      items: itemsJson
          .map((e) => ItemPedido.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num?)?.toDouble() ?? 0,
      estado: EstadoPedido.desdeApi(json['estado'] as String? ?? 'recibido'),
      tipo: TipoPedido.desdeString(json['tipo'] as String? ?? 'recoger'),
      direccion: json['direccion'] as String?,
      creadoEn: DateTime.tryParse(json['creado_en'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cliente': cliente,
        'telefono': telefono,
        'items': items.map((i) => i.toJson()).toList(),
        'total': total,
        'estado': estado.claveApi,
        'tipo': tipo == TipoPedido.domicilio ? 'domicilio' : 'recoger',
        'direccion': direccion,
        'creado_en': creadoEn.toIso8601String(),
      };

  /// Devuelve una copia del pedido con campos actualizados.
  OrderModel copyWith({EstadoPedido? estado}) {
    return OrderModel(
      id: id,
      cliente: cliente,
      telefono: telefono,
      items: items,
      total: total,
      estado: estado ?? this.estado,
      tipo: tipo,
      direccion: direccion,
      creadoEn: creadoEn,
    );
  }
}
