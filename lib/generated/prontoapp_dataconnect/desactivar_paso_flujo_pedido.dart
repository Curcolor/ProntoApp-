part of 'prontoapp.dart';

class DesactivarPasoFlujoPedidoVariablesBuilder {
  String negocioId;
  String id;

  final FirebaseDataConnect _dataConnect;
  DesactivarPasoFlujoPedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,});
  Deserializer<DesactivarPasoFlujoPedidoData> dataDeserializer = (dynamic json)  => DesactivarPasoFlujoPedidoData.fromJson(jsonDecode(json));
  Serializer<DesactivarPasoFlujoPedidoVariables> varsSerializer = (DesactivarPasoFlujoPedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DesactivarPasoFlujoPedidoData, DesactivarPasoFlujoPedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DesactivarPasoFlujoPedidoData, DesactivarPasoFlujoPedidoVariables> ref() {
    DesactivarPasoFlujoPedidoVariables vars= DesactivarPasoFlujoPedidoVariables(negocioId: negocioId,id: id,);
    return _dataConnect.mutation("DesactivarPasoFlujoPedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate {
  final String id;
  DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate otherTyped = other as DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate({
    required this.id,
  });
}

@immutable
class DesactivarPasoFlujoPedidoData {
  final DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate? pasoFlujoPedido_update;
  DesactivarPasoFlujoPedidoData.fromJson(dynamic json):
  
  pasoFlujoPedido_update = json['pasoFlujoPedido_update'] == null ? null : DesactivarPasoFlujoPedidoPasoFlujoPedidoUpdate.fromJson(json['pasoFlujoPedido_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarPasoFlujoPedidoData otherTyped = other as DesactivarPasoFlujoPedidoData;
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

  DesactivarPasoFlujoPedidoData({
    this.pasoFlujoPedido_update,
  });
}

@immutable
class DesactivarPasoFlujoPedidoVariables {
  final String negocioId;
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DesactivarPasoFlujoPedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarPasoFlujoPedidoVariables otherTyped = other as DesactivarPasoFlujoPedidoVariables;
    return negocioId == otherTyped.negocioId && 
    id == otherTyped.id;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, id.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DesactivarPasoFlujoPedidoVariables({
    required this.negocioId,
    required this.id,
  });
}

