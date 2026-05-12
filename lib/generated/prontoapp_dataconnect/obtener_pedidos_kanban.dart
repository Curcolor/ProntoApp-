part of 'prontoapp.dart';

class ObtenerPedidosKanbanVariablesBuilder {
  String negocioId;
  EstadoPedido estado;

  final FirebaseDataConnect _dataConnect;
  ObtenerPedidosKanbanVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.estado,});
  Deserializer<ObtenerPedidosKanbanData> dataDeserializer = (dynamic json)  => ObtenerPedidosKanbanData.fromJson(jsonDecode(json));
  Serializer<ObtenerPedidosKanbanVariables> varsSerializer = (ObtenerPedidosKanbanVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerPedidosKanbanData, ObtenerPedidosKanbanVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerPedidosKanbanData, ObtenerPedidosKanbanVariables> ref() {
    ObtenerPedidosKanbanVariables vars= ObtenerPedidosKanbanVariables(negocioId: negocioId,estado: estado,);
    return _dataConnect.query("ObtenerPedidosKanban", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerPedidosKanbanPasosFlujoPedido {
  final String id;
  final EnumValue<EstadoPedido> estado;
  final String etiqueta;
  final int orden;
  final int? minutosSla;
  ObtenerPedidosKanbanPasosFlujoPedido.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  estado = estadoPedidoDeserializer(json['estado']),
  etiqueta = nativeFromJson<String>(json['etiqueta']),
  orden = nativeFromJson<int>(json['orden']),
  minutosSla = json['minutosSla'] == null ? null : nativeFromJson<int>(json['minutosSla']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanPasosFlujoPedido otherTyped = other as ObtenerPedidosKanbanPasosFlujoPedido;
    return id == otherTyped.id && 
    estado == otherTyped.estado && 
    etiqueta == otherTyped.etiqueta && 
    orden == otherTyped.orden && 
    minutosSla == otherTyped.minutosSla;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, estado.hashCode, etiqueta.hashCode, orden.hashCode, minutosSla.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['estado'] = 
    estadoPedidoSerializer(estado)
    ;
    json['etiqueta'] = nativeToJson<String>(etiqueta);
    json['orden'] = nativeToJson<int>(orden);
    if (minutosSla != null) {
      json['minutosSla'] = nativeToJson<int?>(minutosSla);
    }
    return json;
  }

  ObtenerPedidosKanbanPasosFlujoPedido({
    required this.id,
    required this.estado,
    required this.etiqueta,
    required this.orden,
    this.minutosSla,
  });
}

@immutable
class ObtenerPedidosKanbanPedidos {
  final String id;
  final String codigoPedido;
  final EnumValue<EstadoPedido> estado;
  final double total;
  final EnumValue<CanalPedido> canal;
  final String? clienteNombreSnapshot;
  final String? clienteWhatsappSnapshot;
  final Timestamp? venceEn;
  final Timestamp fechaHora;
  final ObtenerPedidosKanbanPedidosUsuarioAsignado? usuarioAsignado;
  final List<ObtenerPedidosKanbanPedidosDetallePedidosOnPedido> detallePedidos_on_pedido;
  ObtenerPedidosKanbanPedidos.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigoPedido = nativeFromJson<String>(json['codigoPedido']),
  estado = estadoPedidoDeserializer(json['estado']),
  total = nativeFromJson<double>(json['total']),
  canal = canalPedidoDeserializer(json['canal']),
  clienteNombreSnapshot = json['clienteNombreSnapshot'] == null ? null : nativeFromJson<String>(json['clienteNombreSnapshot']),
  clienteWhatsappSnapshot = json['clienteWhatsappSnapshot'] == null ? null : nativeFromJson<String>(json['clienteWhatsappSnapshot']),
  venceEn = json['venceEn'] == null ? null : Timestamp.fromJson(json['venceEn']),
  fechaHora = Timestamp.fromJson(json['fechaHora']),
  usuarioAsignado = json['usuarioAsignado'] == null ? null : ObtenerPedidosKanbanPedidosUsuarioAsignado.fromJson(json['usuarioAsignado']),
  detallePedidos_on_pedido = (json['detallePedidos_on_pedido'] as List<dynamic>)
        .map((e) => ObtenerPedidosKanbanPedidosDetallePedidosOnPedido.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanPedidos otherTyped = other as ObtenerPedidosKanbanPedidos;
    return id == otherTyped.id && 
    codigoPedido == otherTyped.codigoPedido && 
    estado == otherTyped.estado && 
    total == otherTyped.total && 
    canal == otherTyped.canal && 
    clienteNombreSnapshot == otherTyped.clienteNombreSnapshot && 
    clienteWhatsappSnapshot == otherTyped.clienteWhatsappSnapshot && 
    venceEn == otherTyped.venceEn && 
    fechaHora == otherTyped.fechaHora && 
    usuarioAsignado == otherTyped.usuarioAsignado && 
    detallePedidos_on_pedido == otherTyped.detallePedidos_on_pedido;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigoPedido.hashCode, estado.hashCode, total.hashCode, canal.hashCode, clienteNombreSnapshot.hashCode, clienteWhatsappSnapshot.hashCode, venceEn.hashCode, fechaHora.hashCode, usuarioAsignado.hashCode, detallePedidos_on_pedido.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['codigoPedido'] = nativeToJson<String>(codigoPedido);
    json['estado'] = 
    estadoPedidoSerializer(estado)
    ;
    json['total'] = nativeToJson<double>(total);
    json['canal'] = 
    canalPedidoSerializer(canal)
    ;
    if (clienteNombreSnapshot != null) {
      json['clienteNombreSnapshot'] = nativeToJson<String?>(clienteNombreSnapshot);
    }
    if (clienteWhatsappSnapshot != null) {
      json['clienteWhatsappSnapshot'] = nativeToJson<String?>(clienteWhatsappSnapshot);
    }
    if (venceEn != null) {
      json['venceEn'] = venceEn!.toJson();
    }
    json['fechaHora'] = fechaHora.toJson();
    if (usuarioAsignado != null) {
      json['usuarioAsignado'] = usuarioAsignado!.toJson();
    }
    json['detallePedidos_on_pedido'] = detallePedidos_on_pedido.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerPedidosKanbanPedidos({
    required this.id,
    required this.codigoPedido,
    required this.estado,
    required this.total,
    required this.canal,
    this.clienteNombreSnapshot,
    this.clienteWhatsappSnapshot,
    this.venceEn,
    required this.fechaHora,
    this.usuarioAsignado,
    required this.detallePedidos_on_pedido,
  });
}

@immutable
class ObtenerPedidosKanbanPedidosUsuarioAsignado {
  final String id;
  final String nombre;
  ObtenerPedidosKanbanPedidosUsuarioAsignado.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanPedidosUsuarioAsignado otherTyped = other as ObtenerPedidosKanbanPedidosUsuarioAsignado;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    return json;
  }

  ObtenerPedidosKanbanPedidosUsuarioAsignado({
    required this.id,
    required this.nombre,
  });
}

@immutable
class ObtenerPedidosKanbanPedidosDetallePedidosOnPedido {
  final String id;
  final String productoNombreSnapshot;
  final int cantidad;
  final double precioUnitario;
  final double subtotal;
  ObtenerPedidosKanbanPedidosDetallePedidosOnPedido.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  productoNombreSnapshot = nativeFromJson<String>(json['productoNombreSnapshot']),
  cantidad = nativeFromJson<int>(json['cantidad']),
  precioUnitario = nativeFromJson<double>(json['precioUnitario']),
  subtotal = nativeFromJson<double>(json['subtotal']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanPedidosDetallePedidosOnPedido otherTyped = other as ObtenerPedidosKanbanPedidosDetallePedidosOnPedido;
    return id == otherTyped.id && 
    productoNombreSnapshot == otherTyped.productoNombreSnapshot && 
    cantidad == otherTyped.cantidad && 
    precioUnitario == otherTyped.precioUnitario && 
    subtotal == otherTyped.subtotal;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, productoNombreSnapshot.hashCode, cantidad.hashCode, precioUnitario.hashCode, subtotal.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['productoNombreSnapshot'] = nativeToJson<String>(productoNombreSnapshot);
    json['cantidad'] = nativeToJson<int>(cantidad);
    json['precioUnitario'] = nativeToJson<double>(precioUnitario);
    json['subtotal'] = nativeToJson<double>(subtotal);
    return json;
  }

  ObtenerPedidosKanbanPedidosDetallePedidosOnPedido({
    required this.id,
    required this.productoNombreSnapshot,
    required this.cantidad,
    required this.precioUnitario,
    required this.subtotal,
  });
}

@immutable
class ObtenerPedidosKanbanData {
  final List<ObtenerPedidosKanbanPasosFlujoPedido> pasosFlujoPedido;
  final List<ObtenerPedidosKanbanPedidos> pedidos;
  ObtenerPedidosKanbanData.fromJson(dynamic json):
  
  pasosFlujoPedido = (json['pasosFlujoPedido'] as List<dynamic>)
        .map((e) => ObtenerPedidosKanbanPasosFlujoPedido.fromJson(e))
        .toList(),
  pedidos = (json['pedidos'] as List<dynamic>)
        .map((e) => ObtenerPedidosKanbanPedidos.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanData otherTyped = other as ObtenerPedidosKanbanData;
    return pasosFlujoPedido == otherTyped.pasosFlujoPedido && 
    pedidos == otherTyped.pedidos;
    
  }
  @override
  int get hashCode => Object.hashAll([pasosFlujoPedido.hashCode, pedidos.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pasosFlujoPedido'] = pasosFlujoPedido.map((e) => e.toJson()).toList();
    json['pedidos'] = pedidos.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerPedidosKanbanData({
    required this.pasosFlujoPedido,
    required this.pedidos,
  });
}

@immutable
class ObtenerPedidosKanbanVariables {
  final String negocioId;
  final EstadoPedido estado;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerPedidosKanbanVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  estado = EstadoPedido.values.byName(json['estado']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPedidosKanbanVariables otherTyped = other as ObtenerPedidosKanbanVariables;
    return negocioId == otherTyped.negocioId && 
    estado == otherTyped.estado;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, estado.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['estado'] = 
    estado.name
    ;
    return json;
  }

  ObtenerPedidosKanbanVariables({
    required this.negocioId,
    required this.estado,
  });
}

