part of 'prontoapp.dart';

class AsignarPedidoVariablesBuilder {
  String negocioId;
  String pedidoId;
  String usuarioAsignadoId;

  final FirebaseDataConnect _dataConnect;
  AsignarPedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.pedidoId,required  this.usuarioAsignadoId,});
  Deserializer<AsignarPedidoData> dataDeserializer = (dynamic json)  => AsignarPedidoData.fromJson(jsonDecode(json));
  Serializer<AsignarPedidoVariables> varsSerializer = (AsignarPedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AsignarPedidoData, AsignarPedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AsignarPedidoData, AsignarPedidoVariables> ref() {
    AsignarPedidoVariables vars= AsignarPedidoVariables(negocioId: negocioId,pedidoId: pedidoId,usuarioAsignadoId: usuarioAsignadoId,);
    return _dataConnect.mutation("AsignarPedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AsignarPedidoPedidoUpdate {
  final String id;
  AsignarPedidoPedidoUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AsignarPedidoPedidoUpdate otherTyped = other as AsignarPedidoPedidoUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AsignarPedidoPedidoUpdate({
    required this.id,
  });
}

@immutable
class AsignarPedidoData {
  final AsignarPedidoPedidoUpdate? pedido_update;
  AsignarPedidoData.fromJson(dynamic json):
  
  pedido_update = json['pedido_update'] == null ? null : AsignarPedidoPedidoUpdate.fromJson(json['pedido_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AsignarPedidoData otherTyped = other as AsignarPedidoData;
    return pedido_update == otherTyped.pedido_update;
    
  }
  @override
  int get hashCode => pedido_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (pedido_update != null) {
      json['pedido_update'] = pedido_update!.toJson();
    }
    return json;
  }

  AsignarPedidoData({
    this.pedido_update,
  });
}

@immutable
class AsignarPedidoVariables {
  final String negocioId;
  final String pedidoId;
  final String usuarioAsignadoId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AsignarPedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  pedidoId = nativeFromJson<String>(json['pedidoId']),
  usuarioAsignadoId = nativeFromJson<String>(json['usuarioAsignadoId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AsignarPedidoVariables otherTyped = other as AsignarPedidoVariables;
    return negocioId == otherTyped.negocioId && 
    pedidoId == otherTyped.pedidoId && 
    usuarioAsignadoId == otherTyped.usuarioAsignadoId;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, pedidoId.hashCode, usuarioAsignadoId.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['pedidoId'] = nativeToJson<String>(pedidoId);
    json['usuarioAsignadoId'] = nativeToJson<String>(usuarioAsignadoId);
    return json;
  }

  AsignarPedidoVariables({
    required this.negocioId,
    required this.pedidoId,
    required this.usuarioAsignadoId,
  });
}

