part of 'prontoapp.dart';

class ActualizarPasoFlujoPedidoVariablesBuilder {
  String negocioId;
  String id;
  String etiqueta;
  int orden;
  Optional<int> _minutosSla = Optional.optional(nativeFromJson, nativeToJson);
  DisparadorFlujo disparador;
  bool activo;

  final FirebaseDataConnect _dataConnect;  ActualizarPasoFlujoPedidoVariablesBuilder minutosSla(int? t) {
   _minutosSla.value = t;
   return this;
  }

  ActualizarPasoFlujoPedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,required  this.etiqueta,required  this.orden,required  this.disparador,required  this.activo,});
  Deserializer<ActualizarPasoFlujoPedidoData> dataDeserializer = (dynamic json)  => ActualizarPasoFlujoPedidoData.fromJson(jsonDecode(json));
  Serializer<ActualizarPasoFlujoPedidoVariables> varsSerializer = (ActualizarPasoFlujoPedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActualizarPasoFlujoPedidoData, ActualizarPasoFlujoPedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActualizarPasoFlujoPedidoData, ActualizarPasoFlujoPedidoVariables> ref() {
    ActualizarPasoFlujoPedidoVariables vars= ActualizarPasoFlujoPedidoVariables(negocioId: negocioId,id: id,etiqueta: etiqueta,orden: orden,minutosSla: _minutosSla,disparador: disparador,activo: activo,);
    return _dataConnect.mutation("ActualizarPasoFlujoPedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate {
  final String id;
  ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate otherTyped = other as ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate({
    required this.id,
  });
}

@immutable
class ActualizarPasoFlujoPedidoData {
  final ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate? pasoFlujoPedido_update;
  ActualizarPasoFlujoPedidoData.fromJson(dynamic json):
  
  pasoFlujoPedido_update = json['pasoFlujoPedido_update'] == null ? null : ActualizarPasoFlujoPedidoPasoFlujoPedidoUpdate.fromJson(json['pasoFlujoPedido_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarPasoFlujoPedidoData otherTyped = other as ActualizarPasoFlujoPedidoData;
    return pasoFlujoPedido_update == otherTyped.pasoFlujoPedido_update;
    
  }
  @override
  int get hashCode => pasoFlujoPedido_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pasoFlujoPedido_update != null) {
      json['pasoFlujoPedido_update'] = pasoFlujoPedido_update!.toJson();
    }
    return json;
  }

  ActualizarPasoFlujoPedidoData({
    this.pasoFlujoPedido_update,
  });
}

@immutable
class ActualizarPasoFlujoPedidoVariables {
  final String negocioId;
  final String id;
  final String etiqueta;
  final int orden;
  late final Optional<int>minutosSla;
  final DisparadorFlujo disparador;
  final bool activo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActualizarPasoFlujoPedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  id = nativeFromJson<String>(json['id']),
  etiqueta = nativeFromJson<String>(json['etiqueta']),
  orden = nativeFromJson<int>(json['orden']),
  disparador = DisparadorFlujo.values.byName(json['disparador']),
  activo = nativeFromJson<bool>(json['activo']) {
  
  
  
  
  
  
    minutosSla = Optional.optional(nativeFromJson, nativeToJson);
    minutosSla.value = json['minutosSla'] == null ? null : nativeFromJson<int>(json['minutosSla']);
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarPasoFlujoPedidoVariables otherTyped = other as ActualizarPasoFlujoPedidoVariables;
    return negocioId == otherTyped.negocioId && 
    id == otherTyped.id && 
    etiqueta == otherTyped.etiqueta && 
    orden == otherTyped.orden && 
    minutosSla == otherTyped.minutosSla && 
    disparador == otherTyped.disparador && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, id.hashCode, etiqueta.hashCode, orden.hashCode, minutosSla.hashCode, disparador.hashCode, activo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['id'] = nativeToJson<String>(id);
    json['etiqueta'] = nativeToJson<String>(etiqueta);
    json['orden'] = nativeToJson<int>(orden);
    if(minutosSla.state == OptionalState.set) {
      json['minutosSla'] = minutosSla.toJson();
    }
    json['disparador'] = 
    disparador.name
    ;
    json['activo'] = nativeToJson<bool>(activo);
    return json;
  }

  ActualizarPasoFlujoPedidoVariables({
    required this.negocioId,
    required this.id,
    required this.etiqueta,
    required this.orden,
    required this.minutosSla,
    required this.disparador,
    required this.activo,
  });
}

