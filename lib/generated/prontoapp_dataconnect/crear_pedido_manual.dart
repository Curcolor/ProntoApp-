part of 'prontoapp.dart';

class CrearPedidoManualVariablesBuilder {
  String negocioId;
  Optional<String> _clienteId = Optional.optional(nativeFromJson, nativeToJson);
  String codigoPedido;
  double total;
  Optional<String> _clienteNombreSnapshot = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _clienteWhatsappSnapshot = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _notas = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CrearPedidoManualVariablesBuilder clienteId(String? t) {
   _clienteId.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder clienteNombreSnapshot(String? t) {
   _clienteNombreSnapshot.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder clienteWhatsappSnapshot(String? t) {
   _clienteWhatsappSnapshot.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder notas(String? t) {
   _notas.value = t;
   return this;
  }

  CrearPedidoManualVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.codigoPedido,required  this.total,});
  Deserializer<CrearPedidoManualData> dataDeserializer = (dynamic json)  => CrearPedidoManualData.fromJson(jsonDecode(json));
  Serializer<CrearPedidoManualVariables> varsSerializer = (CrearPedidoManualVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearPedidoManualData, CrearPedidoManualVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearPedidoManualData, CrearPedidoManualVariables> ref() {
    CrearPedidoManualVariables vars= CrearPedidoManualVariables(negocioId: negocioId,clienteId: _clienteId,codigoPedido: codigoPedido,total: total,clienteNombreSnapshot: _clienteNombreSnapshot,clienteWhatsappSnapshot: _clienteWhatsappSnapshot,notas: _notas,);
    return _dataConnect.mutation("CrearPedidoManual", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearPedidoManualPedidoInsert {
  final String id;
  CrearPedidoManualPedidoInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPedidoManualPedidoInsert otherTyped = other as CrearPedidoManualPedidoInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearPedidoManualPedidoInsert({
    required this.id,
  });
}

@immutable
class CrearPedidoManualData {
  final CrearPedidoManualPedidoInsert pedido_insert;
  CrearPedidoManualData.fromJson(dynamic json):
  
  pedido_insert = CrearPedidoManualPedidoInsert.fromJson(json['pedido_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPedidoManualData otherTyped = other as CrearPedidoManualData;
    return pedido_insert == otherTyped.pedido_insert;
    
  }
  @override
  int get hashCode => pedido_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pedido_insert'] = pedido_insert.toJson();
    return json;
  }

  CrearPedidoManualData({
    required this.pedido_insert,
  });
}

@immutable
class CrearPedidoManualVariables {
  final String negocioId;
  late final Optional<String>clienteId;
  final String codigoPedido;
  final double total;
  late final Optional<String>clienteNombreSnapshot;
  late final Optional<String>clienteWhatsappSnapshot;
  late final Optional<String>notas;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearPedidoManualVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  codigoPedido = nativeFromJson<String>(json['codigoPedido']),
  total = nativeFromJson<double>(json['total']) {
  
  
  
    clienteId = Optional.optional(nativeFromJson, nativeToJson);
    clienteId.value = json['clienteId'] == null ? null : nativeFromJson<String>(json['clienteId']);
  
  
  
  
    clienteNombreSnapshot = Optional.optional(nativeFromJson, nativeToJson);
    clienteNombreSnapshot.value = json['clienteNombreSnapshot'] == null ? null : nativeFromJson<String>(json['clienteNombreSnapshot']);
  
  
    clienteWhatsappSnapshot = Optional.optional(nativeFromJson, nativeToJson);
    clienteWhatsappSnapshot.value = json['clienteWhatsappSnapshot'] == null ? null : nativeFromJson<String>(json['clienteWhatsappSnapshot']);
  
  
    notas = Optional.optional(nativeFromJson, nativeToJson);
    notas.value = json['notas'] == null ? null : nativeFromJson<String>(json['notas']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPedidoManualVariables otherTyped = other as CrearPedidoManualVariables;
    return negocioId == otherTyped.negocioId && 
    clienteId == otherTyped.clienteId && 
    codigoPedido == otherTyped.codigoPedido && 
    total == otherTyped.total && 
    clienteNombreSnapshot == otherTyped.clienteNombreSnapshot && 
    clienteWhatsappSnapshot == otherTyped.clienteWhatsappSnapshot && 
    notas == otherTyped.notas;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, clienteId.hashCode, codigoPedido.hashCode, total.hashCode, clienteNombreSnapshot.hashCode, clienteWhatsappSnapshot.hashCode, notas.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    if(clienteId.state == OptionalState.set) {
      json['clienteId'] = clienteId.toJson();
    }
    json['codigoPedido'] = nativeToJson<String>(codigoPedido);
    json['total'] = nativeToJson<double>(total);
    if(clienteNombreSnapshot.state == OptionalState.set) {
      json['clienteNombreSnapshot'] = clienteNombreSnapshot.toJson();
    }
    if(clienteWhatsappSnapshot.state == OptionalState.set) {
      json['clienteWhatsappSnapshot'] = clienteWhatsappSnapshot.toJson();
    }
    if(notas.state == OptionalState.set) {
      json['notas'] = notas.toJson();
    }
    return json;
  }

  CrearPedidoManualVariables({
    required this.negocioId,
    required this.clienteId,
    required this.codigoPedido,
    required this.total,
    required this.clienteNombreSnapshot,
    required this.clienteWhatsappSnapshot,
    required this.notas,
  });
}

