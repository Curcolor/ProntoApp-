part of 'prontoapp.dart';

class ObtenerDashboardNegocioVariablesBuilder {
  String negocioId;
  Timestamp pedidosDesde;
  DateTime metricasDesde;
  DateTime metricasHasta;

  final FirebaseDataConnect _dataConnect;
  ObtenerDashboardNegocioVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.pedidosDesde,required  this.metricasDesde,required  this.metricasHasta,});
  Deserializer<ObtenerDashboardNegocioData> dataDeserializer = (dynamic json)  => ObtenerDashboardNegocioData.fromJson(jsonDecode(json));
  Serializer<ObtenerDashboardNegocioVariables> varsSerializer = (ObtenerDashboardNegocioVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerDashboardNegocioData, ObtenerDashboardNegocioVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerDashboardNegocioData, ObtenerDashboardNegocioVariables> ref() {
    ObtenerDashboardNegocioVariables vars= ObtenerDashboardNegocioVariables(negocioId: negocioId,pedidosDesde: pedidosDesde,metricasDesde: metricasDesde,metricasHasta: metricasHasta,);
    return _dataConnect.query("ObtenerDashboardNegocio", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerDashboardNegocioNegocio {
  final String id;
  final String nombre;
  final EnumValue<FormatoEntrega> formatoEntrega;
  final int minutosGraciaSla;
  ObtenerDashboardNegocioNegocio.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  formatoEntrega = formatoEntregaDeserializer(json['formatoEntrega']),
  minutosGraciaSla = nativeFromJson<int>(json['minutosGraciaSla']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioNegocio otherTyped = other as ObtenerDashboardNegocioNegocio;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    formatoEntrega == otherTyped.formatoEntrega && 
    minutosGraciaSla == otherTyped.minutosGraciaSla;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, formatoEntrega.hashCode, minutosGraciaSla.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['formatoEntrega'] = 
    formatoEntregaSerializer(formatoEntrega)
    ;
    json['minutosGraciaSla'] = nativeToJson<int>(minutosGraciaSla);
    return json;
  }

  ObtenerDashboardNegocioNegocio({
    required this.id,
    required this.nombre,
    required this.formatoEntrega,
    required this.minutosGraciaSla,
  });
}

@immutable
class ObtenerDashboardNegocioPedidos {
  final String id;
  final String codigoPedido;
  final EnumValue<EstadoPedido> estado;
  final double total;
  final EnumValue<CanalPedido> canal;
  final String? clienteNombreSnapshot;
  final Timestamp fechaHora;
  final Timestamp fechaActualizacion;
  final ObtenerDashboardNegocioPedidosUsuarioAsignado? usuarioAsignado;
  ObtenerDashboardNegocioPedidos.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigoPedido = nativeFromJson<String>(json['codigoPedido']),
  estado = estadoPedidoDeserializer(json['estado']),
  total = nativeFromJson<double>(json['total']),
  canal = canalPedidoDeserializer(json['canal']),
  clienteNombreSnapshot = json['clienteNombreSnapshot'] == null ? null : nativeFromJson<String>(json['clienteNombreSnapshot']),
  fechaHora = Timestamp.fromJson(json['fechaHora']),
  fechaActualizacion = Timestamp.fromJson(json['fechaActualizacion']),
  usuarioAsignado = json['usuarioAsignado'] == null ? null : ObtenerDashboardNegocioPedidosUsuarioAsignado.fromJson(json['usuarioAsignado']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioPedidos otherTyped = other as ObtenerDashboardNegocioPedidos;
    return id == otherTyped.id && 
    codigoPedido == otherTyped.codigoPedido && 
    estado == otherTyped.estado && 
    total == otherTyped.total && 
    canal == otherTyped.canal && 
    clienteNombreSnapshot == otherTyped.clienteNombreSnapshot && 
    fechaHora == otherTyped.fechaHora && 
    fechaActualizacion == otherTyped.fechaActualizacion && 
    usuarioAsignado == otherTyped.usuarioAsignado;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigoPedido.hashCode, estado.hashCode, total.hashCode, canal.hashCode, clienteNombreSnapshot.hashCode, fechaHora.hashCode, fechaActualizacion.hashCode, usuarioAsignado.hashCode]);
  

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
    json['fechaHora'] = fechaHora.toJson();
    json['fechaActualizacion'] = fechaActualizacion.toJson();
    if (usuarioAsignado != null) {
      json['usuarioAsignado'] = usuarioAsignado!.toJson();
    }
    return json;
  }

  ObtenerDashboardNegocioPedidos({
    required this.id,
    required this.codigoPedido,
    required this.estado,
    required this.total,
    required this.canal,
    this.clienteNombreSnapshot,
    required this.fechaHora,
    required this.fechaActualizacion,
    this.usuarioAsignado,
  });
}

@immutable
class ObtenerDashboardNegocioPedidosUsuarioAsignado {
  final String id;
  final String nombre;
  final EnumValue<RolAdmin> cargo;
  ObtenerDashboardNegocioPedidosUsuarioAsignado.fromJson(dynamic json):
  
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

    final ObtenerDashboardNegocioPedidosUsuarioAsignado otherTyped = other as ObtenerDashboardNegocioPedidosUsuarioAsignado;
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

  ObtenerDashboardNegocioPedidosUsuarioAsignado({
    required this.id,
    required this.nombre,
    required this.cargo,
  });
}

@immutable
class ObtenerDashboardNegocioMetricasDiariasNegocio {
  final DateTime fecha;
  final int cantidadPedidos;
  final int cantidadEntregados;
  final int cantidadCancelados;
  final double totalIngresos;
  final double? minutosPromedioPreparacion;
  final double? tasaConversionIa;
  ObtenerDashboardNegocioMetricasDiariasNegocio.fromJson(dynamic json):
  
  fecha = nativeFromJson<DateTime>(json['fecha']),
  cantidadPedidos = nativeFromJson<int>(json['cantidadPedidos']),
  cantidadEntregados = nativeFromJson<int>(json['cantidadEntregados']),
  cantidadCancelados = nativeFromJson<int>(json['cantidadCancelados']),
  totalIngresos = nativeFromJson<double>(json['totalIngresos']),
  minutosPromedioPreparacion = json['minutosPromedioPreparacion'] == null ? null : nativeFromJson<double>(json['minutosPromedioPreparacion']),
  tasaConversionIa = json['tasaConversionIa'] == null ? null : nativeFromJson<double>(json['tasaConversionIa']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioMetricasDiariasNegocio otherTyped = other as ObtenerDashboardNegocioMetricasDiariasNegocio;
    return fecha == otherTyped.fecha && 
    cantidadPedidos == otherTyped.cantidadPedidos && 
    cantidadEntregados == otherTyped.cantidadEntregados && 
    cantidadCancelados == otherTyped.cantidadCancelados && 
    totalIngresos == otherTyped.totalIngresos && 
    minutosPromedioPreparacion == otherTyped.minutosPromedioPreparacion && 
    tasaConversionIa == otherTyped.tasaConversionIa;
    
  }
  @override
  int get hashCode => Object.hashAll([fecha.hashCode, cantidadPedidos.hashCode, cantidadEntregados.hashCode, cantidadCancelados.hashCode, totalIngresos.hashCode, minutosPromedioPreparacion.hashCode, tasaConversionIa.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['fecha'] = nativeToJson<DateTime>(fecha);
    json['cantidadPedidos'] = nativeToJson<int>(cantidadPedidos);
    json['cantidadEntregados'] = nativeToJson<int>(cantidadEntregados);
    json['cantidadCancelados'] = nativeToJson<int>(cantidadCancelados);
    json['totalIngresos'] = nativeToJson<double>(totalIngresos);
    if (minutosPromedioPreparacion != null) {
      json['minutosPromedioPreparacion'] = nativeToJson<double?>(minutosPromedioPreparacion);
    }
    if (tasaConversionIa != null) {
      json['tasaConversionIa'] = nativeToJson<double?>(tasaConversionIa);
    }
    return json;
  }

  ObtenerDashboardNegocioMetricasDiariasNegocio({
    required this.fecha,
    required this.cantidadPedidos,
    required this.cantidadEntregados,
    required this.cantidadCancelados,
    required this.totalIngresos,
    this.minutosPromedioPreparacion,
    this.tasaConversionIa,
  });
}

@immutable
class ObtenerDashboardNegocioData {
  final ObtenerDashboardNegocioNegocio? negocio;
  final List<ObtenerDashboardNegocioPedidos> pedidos;
  final List<ObtenerDashboardNegocioMetricasDiariasNegocio> metricasDiariasNegocio;
  ObtenerDashboardNegocioData.fromJson(dynamic json):
  
  negocio = json['negocio'] == null ? null : ObtenerDashboardNegocioNegocio.fromJson(json['negocio']),
  pedidos = (json['pedidos'] as List<dynamic>)
        .map((e) => ObtenerDashboardNegocioPedidos.fromJson(e))
        .toList(),
  metricasDiariasNegocio = (json['metricasDiariasNegocio'] as List<dynamic>)
        .map((e) => ObtenerDashboardNegocioMetricasDiariasNegocio.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioData otherTyped = other as ObtenerDashboardNegocioData;
    return negocio == otherTyped.negocio && 
    pedidos == otherTyped.pedidos && 
    metricasDiariasNegocio == otherTyped.metricasDiariasNegocio;
    
  }
  @override
  int get hashCode => Object.hashAll([negocio.hashCode, pedidos.hashCode, metricasDiariasNegocio.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (negocio != null) {
      json['negocio'] = negocio!.toJson();
    }
    json['pedidos'] = pedidos.map((e) => e.toJson()).toList();
    json['metricasDiariasNegocio'] = metricasDiariasNegocio.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerDashboardNegocioData({
    this.negocio,
    required this.pedidos,
    required this.metricasDiariasNegocio,
  });
}

@immutable
class ObtenerDashboardNegocioVariables {
  final String negocioId;
  final Timestamp pedidosDesde;
  final DateTime metricasDesde;
  final DateTime metricasHasta;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerDashboardNegocioVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  pedidosDesde = Timestamp.fromJson(json['pedidosDesde']),
  metricasDesde = nativeFromJson<DateTime>(json['metricasDesde']),
  metricasHasta = nativeFromJson<DateTime>(json['metricasHasta']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerDashboardNegocioVariables otherTyped = other as ObtenerDashboardNegocioVariables;
    return negocioId == otherTyped.negocioId && 
    pedidosDesde == otherTyped.pedidosDesde && 
    metricasDesde == otherTyped.metricasDesde && 
    metricasHasta == otherTyped.metricasHasta;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, pedidosDesde.hashCode, metricasDesde.hashCode, metricasHasta.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['pedidosDesde'] = pedidosDesde.toJson();
    json['metricasDesde'] = nativeToJson<DateTime>(metricasDesde);
    json['metricasHasta'] = nativeToJson<DateTime>(metricasHasta);
    return json;
  }

  ObtenerDashboardNegocioVariables({
    required this.negocioId,
    required this.pedidosDesde,
    required this.metricasDesde,
    required this.metricasHasta,
  });
}

