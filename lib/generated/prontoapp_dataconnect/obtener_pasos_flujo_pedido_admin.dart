part of 'prontoapp.dart';

class ObtenerPasosFlujoPedidoAdminVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerPasosFlujoPedidoAdminVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerPasosFlujoPedidoAdminData> dataDeserializer = (dynamic json)  => ObtenerPasosFlujoPedidoAdminData.fromJson(jsonDecode(json));
  Serializer<ObtenerPasosFlujoPedidoAdminVariables> varsSerializer = (ObtenerPasosFlujoPedidoAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerPasosFlujoPedidoAdminData, ObtenerPasosFlujoPedidoAdminVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerPasosFlujoPedidoAdminData, ObtenerPasosFlujoPedidoAdminVariables> ref() {
    ObtenerPasosFlujoPedidoAdminVariables vars= ObtenerPasosFlujoPedidoAdminVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerPasosFlujoPedidoAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerPasosFlujoPedidoAdminPasosFlujoPedido {
  final String id;
  final EnumValue<EstadoPedido> estado;
  final String etiqueta;
  final int orden;
  final int? minutosSla;
  final EnumValue<DisparadorFlujo> disparador;
  final bool activo;
  ObtenerPasosFlujoPedidoAdminPasosFlujoPedido.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  estado = estadoPedidoDeserializer(json['estado']),
  etiqueta = nativeFromJson<String>(json['etiqueta']),
  orden = nativeFromJson<int>(json['orden']),
  minutosSla = json['minutosSla'] == null ? null : nativeFromJson<int>(json['minutosSla']),
  disparador = disparadorFlujoDeserializer(json['disparador']),
  activo = nativeFromJson<bool>(json['activo']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPasosFlujoPedidoAdminPasosFlujoPedido otherTyped = other as ObtenerPasosFlujoPedidoAdminPasosFlujoPedido;
    return id == otherTyped.id && 
    estado == otherTyped.estado && 
    etiqueta == otherTyped.etiqueta && 
    orden == otherTyped.orden && 
    minutosSla == otherTyped.minutosSla && 
    disparador == otherTyped.disparador && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, estado.hashCode, etiqueta.hashCode, orden.hashCode, minutosSla.hashCode, disparador.hashCode, activo.hashCode]);
  

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
    json['disparador'] = 
    disparadorFlujoSerializer(disparador)
    ;
    json['activo'] = nativeToJson<bool>(activo);
    return json;
  }

  ObtenerPasosFlujoPedidoAdminPasosFlujoPedido({
    required this.id,
    required this.estado,
    required this.etiqueta,
    required this.orden,
    this.minutosSla,
    required this.disparador,
    required this.activo,
  });
}

@immutable
class ObtenerPasosFlujoPedidoAdminData {
  final List<ObtenerPasosFlujoPedidoAdminPasosFlujoPedido> pasosFlujoPedido;
  ObtenerPasosFlujoPedidoAdminData.fromJson(dynamic json):
  
  pasosFlujoPedido = (json['pasosFlujoPedido'] as List<dynamic>)
        .map((e) => ObtenerPasosFlujoPedidoAdminPasosFlujoPedido.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPasosFlujoPedidoAdminData otherTyped = other as ObtenerPasosFlujoPedidoAdminData;
    return pasosFlujoPedido == otherTyped.pasosFlujoPedido;
    
  }
  @override
  int get hashCode => pasosFlujoPedido.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pasosFlujoPedido'] = pasosFlujoPedido.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerPasosFlujoPedidoAdminData({
    required this.pasosFlujoPedido,
  });
}

@immutable
class ObtenerPasosFlujoPedidoAdminVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerPasosFlujoPedidoAdminVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPasosFlujoPedidoAdminVariables otherTyped = other as ObtenerPasosFlujoPedidoAdminVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerPasosFlujoPedidoAdminVariables({
    required this.negocioId,
  });
}

