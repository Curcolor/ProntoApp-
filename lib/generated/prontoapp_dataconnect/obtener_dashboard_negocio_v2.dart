part of 'prontoapp.dart';

class ObtenerDashboardNegocioV2VariablesBuilder {
  String negocioId;
  Timestamp pedidosDesde;

  final FirebaseDataConnect _dataConnect;
  ObtenerDashboardNegocioV2VariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.pedidosDesde,});
  Deserializer<ObtenerDashboardNegocioV2Data> dataDeserializer = (dynamic json)  => ObtenerDashboardNegocioV2Data.fromJson(jsonDecode(json));
  Serializer<ObtenerDashboardNegocioV2Variables> varsSerializer = (ObtenerDashboardNegocioV2Variables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerDashboardNegocioV2Data, ObtenerDashboardNegocioV2Variables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerDashboardNegocioV2Data, ObtenerDashboardNegocioV2Variables> ref() {
    ObtenerDashboardNegocioV2Variables vars= ObtenerDashboardNegocioV2Variables(negocioId: negocioId,pedidosDesde: pedidosDesde,);
    return _dataConnect.query("ObtenerDashboardNegocioV2", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerDashboardNegocioV2Negocio {
  final String id;
  final String nombre;
  final EnumValue<TipoNegocio> tipoNegocio;
  final EnumValue<FormatoEntrega> formatoEntrega;
  final String? numeroWhatsapp;
  final int minutosGraciaSla;
  final String zonaHoraria;
  final String monedaIso;
  ObtenerDashboardNegocioV2Negocio.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  tipoNegocio = tipoNegocioDeserializer(json['tipoNegocio']),
  formatoEntrega = formatoEntregaDeserializer(json['formatoEntrega']),
  numeroWhatsapp = json['numeroWhatsapp'] == null ? null : nativeFromJson<String>(json['numeroWhatsapp']),
  minutosGraciaSla = nativeFromJson<int>(json['minutosGraciaSla']),
  zonaHoraria = nativeFromJson<String>(json['zonaHoraria']),
  monedaIso = nativeFromJson<String>(json['monedaIso']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2Negocio otherTyped = other as ObtenerDashboardNegocioV2Negocio;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    tipoNegocio == otherTyped.tipoNegocio && 
    formatoEntrega == otherTyped.formatoEntrega && 
    numeroWhatsapp == otherTyped.numeroWhatsapp && 
    minutosGraciaSla == otherTyped.minutosGraciaSla && 
    zonaHoraria == otherTyped.zonaHoraria && 
    monedaIso == otherTyped.monedaIso;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, tipoNegocio.hashCode, formatoEntrega.hashCode, numeroWhatsapp.hashCode, minutosGraciaSla.hashCode, zonaHoraria.hashCode, monedaIso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['tipoNegocio'] = 
    tipoNegocioSerializer(tipoNegocio)
    ;
    json['formatoEntrega'] = 
    formatoEntregaSerializer(formatoEntrega)
    ;
    if (numeroWhatsapp != null) {
      json['numeroWhatsapp'] = nativeToJson<String?>(numeroWhatsapp);
    }
    json['minutosGraciaSla'] = nativeToJson<int>(minutosGraciaSla);
    json['zonaHoraria'] = nativeToJson<String>(zonaHoraria);
    json['monedaIso'] = nativeToJson<String>(monedaIso);
    return json;
  }

  ObtenerDashboardNegocioV2Negocio({
    required this.id,
    required this.nombre,
    required this.tipoNegocio,
    required this.formatoEntrega,
    this.numeroWhatsapp,
    required this.minutosGraciaSla,
    required this.zonaHoraria,
    required this.monedaIso,
  });
}

@immutable
class ObtenerDashboardNegocioV2Pedidos {
  final String id;
  final String codigoPedido;
  final EnumValue<EstadoPedido> estado;
  final EnumValue<EstadoPago> estadoPago;
  final double total;
  final EnumValue<CanalPedido> canal;
  final EnumValue<CanalOperacion> origenCanal;
  final EnumValue<ActorOperacion> origenActor;
  final String? clienteNombreSnapshot;
  final String? clienteWhatsappSnapshot;
  final Timestamp creadoEn;
  final Timestamp actualizadoEn;
  final ObtenerDashboardNegocioV2PedidosUsuarioAsignado? usuarioAsignado;
  ObtenerDashboardNegocioV2Pedidos.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigoPedido = nativeFromJson<String>(json['codigoPedido']),
  estado = estadoPedidoDeserializer(json['estado']),
  estadoPago = estadoPagoDeserializer(json['estadoPago']),
  total = nativeFromJson<double>(json['total']),
  canal = canalPedidoDeserializer(json['canal']),
  origenCanal = canalOperacionDeserializer(json['origenCanal']),
  origenActor = actorOperacionDeserializer(json['origenActor']),
  clienteNombreSnapshot = json['clienteNombreSnapshot'] == null ? null : nativeFromJson<String>(json['clienteNombreSnapshot']),
  clienteWhatsappSnapshot = json['clienteWhatsappSnapshot'] == null ? null : nativeFromJson<String>(json['clienteWhatsappSnapshot']),
  creadoEn = Timestamp.fromJson(json['creadoEn']),
  actualizadoEn = Timestamp.fromJson(json['actualizadoEn']),
  usuarioAsignado = json['usuarioAsignado'] == null ? null : ObtenerDashboardNegocioV2PedidosUsuarioAsignado.fromJson(json['usuarioAsignado']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2Pedidos otherTyped = other as ObtenerDashboardNegocioV2Pedidos;
    return id == otherTyped.id && 
    codigoPedido == otherTyped.codigoPedido && 
    estado == otherTyped.estado && 
    estadoPago == otherTyped.estadoPago && 
    total == otherTyped.total && 
    canal == otherTyped.canal && 
    origenCanal == otherTyped.origenCanal && 
    origenActor == otherTyped.origenActor && 
    clienteNombreSnapshot == otherTyped.clienteNombreSnapshot && 
    clienteWhatsappSnapshot == otherTyped.clienteWhatsappSnapshot && 
    creadoEn == otherTyped.creadoEn && 
    actualizadoEn == otherTyped.actualizadoEn && 
    usuarioAsignado == otherTyped.usuarioAsignado;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigoPedido.hashCode, estado.hashCode, estadoPago.hashCode, total.hashCode, canal.hashCode, origenCanal.hashCode, origenActor.hashCode, clienteNombreSnapshot.hashCode, clienteWhatsappSnapshot.hashCode, creadoEn.hashCode, actualizadoEn.hashCode, usuarioAsignado.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['codigoPedido'] = nativeToJson<String>(codigoPedido);
    json['estado'] = 
    estadoPedidoSerializer(estado)
    ;
    json['estadoPago'] = 
    estadoPagoSerializer(estadoPago)
    ;
    json['total'] = nativeToJson<double>(total);
    json['canal'] = 
    canalPedidoSerializer(canal)
    ;
    json['origenCanal'] = 
    canalOperacionSerializer(origenCanal)
    ;
    json['origenActor'] = 
    actorOperacionSerializer(origenActor)
    ;
    if (clienteNombreSnapshot != null) {
      json['clienteNombreSnapshot'] = nativeToJson<String?>(clienteNombreSnapshot);
    }
    if (clienteWhatsappSnapshot != null) {
      json['clienteWhatsappSnapshot'] = nativeToJson<String?>(clienteWhatsappSnapshot);
    }
    json['creadoEn'] = creadoEn.toJson();
    json['actualizadoEn'] = actualizadoEn.toJson();
    if (usuarioAsignado != null) {
      json['usuarioAsignado'] = usuarioAsignado!.toJson();
    }
    return json;
  }

  ObtenerDashboardNegocioV2Pedidos({
    required this.id,
    required this.codigoPedido,
    required this.estado,
    required this.estadoPago,
    required this.total,
    required this.canal,
    required this.origenCanal,
    required this.origenActor,
    this.clienteNombreSnapshot,
    this.clienteWhatsappSnapshot,
    required this.creadoEn,
    required this.actualizadoEn,
    this.usuarioAsignado,
  });
}

@immutable
class ObtenerDashboardNegocioV2PedidosUsuarioAsignado {
  final String id;
  final String nombre;
  final EnumValue<RolAdmin> cargo;
  ObtenerDashboardNegocioV2PedidosUsuarioAsignado.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  cargo = rolAdminDeserializer(json['cargo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2PedidosUsuarioAsignado otherTyped = other as ObtenerDashboardNegocioV2PedidosUsuarioAsignado;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    cargo == otherTyped.cargo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, cargo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['cargo'] = 
    rolAdminSerializer(cargo)
    ;
    return json;
  }

  ObtenerDashboardNegocioV2PedidosUsuarioAsignado({
    required this.id,
    required this.nombre,
    required this.cargo,
  });
}

@immutable
class ObtenerDashboardNegocioV2Productos {
  final String id;
  final String nombre;
  final String codigo;
  final double precio;
  final int stock;
  final double descuento;
  final int umbralStockBajo;
  ObtenerDashboardNegocioV2Productos.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  codigo = nativeFromJson<String>(json['codigo']),
  precio = nativeFromJson<double>(json['precio']),
  stock = nativeFromJson<int>(json['stock']),
  descuento = nativeFromJson<double>(json['descuento']),
  umbralStockBajo = nativeFromJson<int>(json['umbralStockBajo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2Productos otherTyped = other as ObtenerDashboardNegocioV2Productos;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    codigo == otherTyped.codigo && 
    precio == otherTyped.precio && 
    stock == otherTyped.stock && 
    descuento == otherTyped.descuento && 
    umbralStockBajo == otherTyped.umbralStockBajo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, codigo.hashCode, precio.hashCode, stock.hashCode, descuento.hashCode, umbralStockBajo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['codigo'] = nativeToJson<String>(codigo);
    json['precio'] = nativeToJson<double>(precio);
    json['stock'] = nativeToJson<int>(stock);
    json['descuento'] = nativeToJson<double>(descuento);
    json['umbralStockBajo'] = nativeToJson<int>(umbralStockBajo);
    return json;
  }

  ObtenerDashboardNegocioV2Productos({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.precio,
    required this.stock,
    required this.descuento,
    required this.umbralStockBajo,
  });
}

@immutable
class ObtenerDashboardNegocioV2Data {
  final ObtenerDashboardNegocioV2Negocio? negocio;
  final List<ObtenerDashboardNegocioV2Pedidos> pedidos;
  final List<ObtenerDashboardNegocioV2Productos> productos;
  ObtenerDashboardNegocioV2Data.fromJson(dynamic json):
  
  negocio = json['negocio'] == null ? null : ObtenerDashboardNegocioV2Negocio.fromJson(json['negocio']),
  pedidos = (json['pedidos'] as List<dynamic>)
        .map((e) => ObtenerDashboardNegocioV2Pedidos.fromJson(e))
        .toList(),
  productos = (json['productos'] as List<dynamic>)
        .map((e) => ObtenerDashboardNegocioV2Productos.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2Data otherTyped = other as ObtenerDashboardNegocioV2Data;
    return negocio == otherTyped.negocio && 
    pedidos == otherTyped.pedidos && 
    productos == otherTyped.productos;
    
  }
  @override
  int get hashCode => Object.hashAll([negocio.hashCode, pedidos.hashCode, productos.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (negocio != null) {
      json['negocio'] = negocio!.toJson();
    }
    json['pedidos'] = pedidos.map((e) => e.toJson()).toList();
    json['productos'] = productos.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerDashboardNegocioV2Data({
    this.negocio,
    required this.pedidos,
    required this.productos,
  });
}

@immutable
class ObtenerDashboardNegocioV2Variables {
  final String negocioId;
  final Timestamp pedidosDesde;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerDashboardNegocioV2Variables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  pedidosDesde = Timestamp.fromJson(json['pedidosDesde']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioV2Variables otherTyped = other as ObtenerDashboardNegocioV2Variables;
    return negocioId == otherTyped.negocioId && 
    pedidosDesde == otherTyped.pedidosDesde;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, pedidosDesde.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['pedidosDesde'] = pedidosDesde.toJson();
    return json;
  }

  ObtenerDashboardNegocioV2Variables({
    required this.negocioId,
    required this.pedidosDesde,
  });
}

