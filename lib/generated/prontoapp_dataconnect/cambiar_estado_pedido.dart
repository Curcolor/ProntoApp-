part of 'prontoapp.dart';

class CambiarEstadoPedidoVariablesBuilder {
  String negocioId;
  String pedidoId;
  Optional<EstadoPedido> _estadoAnterior = Optional.optional((data) => EstadoPedido.values.byName(data), enumSerializer);
  EstadoPedido estadoNuevo;
  Optional<String> _usuarioCambioId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _motivo = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CambiarEstadoPedidoVariablesBuilder estadoAnterior(EstadoPedido? t) {
   _estadoAnterior.value = t;
   return this;
  }
  CambiarEstadoPedidoVariablesBuilder usuarioCambioId(String? t) {
   _usuarioCambioId.value = t;
   return this;
  }
  CambiarEstadoPedidoVariablesBuilder motivo(String? t) {
   _motivo.value = t;
   return this;
  }

  CambiarEstadoPedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.pedidoId,required  this.estadoNuevo,});
  Deserializer<CambiarEstadoPedidoData> dataDeserializer = (dynamic json)  => CambiarEstadoPedidoData.fromJson(jsonDecode(json));
  Serializer<CambiarEstadoPedidoVariables> varsSerializer = (CambiarEstadoPedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CambiarEstadoPedidoData, CambiarEstadoPedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CambiarEstadoPedidoData, CambiarEstadoPedidoVariables> ref() {
    CambiarEstadoPedidoVariables vars= CambiarEstadoPedidoVariables(negocioId: negocioId,pedidoId: pedidoId,estadoAnterior: _estadoAnterior,estadoNuevo: estadoNuevo,usuarioCambioId: _usuarioCambioId,motivo: _motivo,);
    return _dataConnect.mutation("CambiarEstadoPedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CambiarEstadoPedidoPedidoUpdate {
  final String id;
  CambiarEstadoPedidoPedidoUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CambiarEstadoPedidoPedidoUpdate otherTyped = other as CambiarEstadoPedidoPedidoUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CambiarEstadoPedidoPedidoUpdate({
    required this.id,
  });
}

@immutable
class CambiarEstadoPedidoHistorialEstadoPedidoInsert {
  final String id;
  CambiarEstadoPedidoHistorialEstadoPedidoInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CambiarEstadoPedidoHistorialEstadoPedidoInsert otherTyped = other as CambiarEstadoPedidoHistorialEstadoPedidoInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CambiarEstadoPedidoHistorialEstadoPedidoInsert({
    required this.id,
  });
}

@immutable
class CambiarEstadoPedidoData {
  final CambiarEstadoPedidoPedidoUpdate? pedido_update;
  final CambiarEstadoPedidoHistorialEstadoPedidoInsert historialEstadoPedido_insert;
  CambiarEstadoPedidoData.fromJson(dynamic json):
  
  pedido_update = json['pedido_update'] == null ? null : CambiarEstadoPedidoPedidoUpdate.fromJson(json['pedido_update']),
  historialEstadoPedido_insert = CambiarEstadoPedidoHistorialEstadoPedidoInsert.fromJson(json['historialEstadoPedido_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CambiarEstadoPedidoData otherTyped = other as CambiarEstadoPedidoData;
    return pedido_update == otherTyped.pedido_update && 
    historialEstadoPedido_insert == otherTyped.historialEstadoPedido_insert;
    
  }
  @override
  int get hashCode => Object.hashAll([pedido_update.hashCode, historialEstadoPedido_insert.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pedido_update != null) {
      json['pedido_update'] = pedido_update!.toJson();
    }
    json['historialEstadoPedido_insert'] = historialEstadoPedido_insert.toJson();
    return json;
  }

  CambiarEstadoPedidoData({
    this.pedido_update,
    required this.historialEstadoPedido_insert,
  });
}

@immutable
class CambiarEstadoPedidoVariables {
  final String negocioId;
  final String pedidoId;
  late final Optional<EstadoPedido>estadoAnterior;
  final EstadoPedido estadoNuevo;
  late final Optional<String>usuarioCambioId;
  late final Optional<String>motivo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CambiarEstadoPedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  pedidoId = nativeFromJson<String>(json['pedidoId']),
  estadoNuevo = EstadoPedido.values.byName(json['estadoNuevo']) {
  
  
  
  
    estadoAnterior = Optional.optional((data) => EstadoPedido.values.byName(data), enumSerializer);
    estadoAnterior.value = json['estadoAnterior'] == null ? null : EstadoPedido.values.byName(json['estadoAnterior']);
  
  
  
    usuarioCambioId = Optional.optional(nativeFromJson, nativeToJson);
    usuarioCambioId.value = json['usuarioCambioId'] == null ? null : nativeFromJson<String>(json['usuarioCambioId']);
  
  
    motivo = Optional.optional(nativeFromJson, nativeToJson);
    motivo.value = json['motivo'] == null ? null : nativeFromJson<String>(json['motivo']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CambiarEstadoPedidoVariables otherTyped = other as CambiarEstadoPedidoVariables;
    return negocioId == otherTyped.negocioId && 
    pedidoId == otherTyped.pedidoId && 
    estadoAnterior == otherTyped.estadoAnterior && 
    estadoNuevo == otherTyped.estadoNuevo && 
    usuarioCambioId == otherTyped.usuarioCambioId && 
    motivo == otherTyped.motivo;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, pedidoId.hashCode, estadoAnterior.hashCode, estadoNuevo.hashCode, usuarioCambioId.hashCode, motivo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['pedidoId'] = nativeToJson<String>(pedidoId);
    if(estadoAnterior.state == OptionalState.set) {
      json['estadoAnterior'] = estadoAnterior.toJson();
    }
    json['estadoNuevo'] = 
    estadoNuevo.name
    ;
    if(usuarioCambioId.state == OptionalState.set) {
      json['usuarioCambioId'] = usuarioCambioId.toJson();
    }
    if(motivo.state == OptionalState.set) {
      json['motivo'] = motivo.toJson();
    }
    return json;
  }

  CambiarEstadoPedidoVariables({
    required this.negocioId,
    required this.pedidoId,
    required this.estadoAnterior,
    required this.estadoNuevo,
    required this.usuarioCambioId,
    required this.motivo,
  });
}

