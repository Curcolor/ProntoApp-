part of 'prontoapp.dart';

class AgregarDetallePedidoVariablesBuilder {
  String negocioId;
  String pedidoId;
  Optional<String> _productoId = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _productoCodigoSnapshot = Optional.optional(nativeFromJson, nativeToJson);
  String productoNombreSnapshot;
  int cantidad;
  double precioUnitario;
  double descuento;
  double subtotal;

  final FirebaseDataConnect _dataConnect;  AgregarDetallePedidoVariablesBuilder productoId(String? t) {
   _productoId.value = t;
   return this;
  }
  AgregarDetallePedidoVariablesBuilder productoCodigoSnapshot(String? t) {
   _productoCodigoSnapshot.value = t;
   return this;
  }

  AgregarDetallePedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.pedidoId,required  this.productoNombreSnapshot,required  this.cantidad,required  this.precioUnitario,required  this.descuento,required  this.subtotal,});
  Deserializer<AgregarDetallePedidoData> dataDeserializer = (dynamic json)  => AgregarDetallePedidoData.fromJson(jsonDecode(json));
  Serializer<AgregarDetallePedidoVariables> varsSerializer = (AgregarDetallePedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<AgregarDetallePedidoData, AgregarDetallePedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<AgregarDetallePedidoData, AgregarDetallePedidoVariables> ref() {
    AgregarDetallePedidoVariables vars= AgregarDetallePedidoVariables(negocioId: negocioId,pedidoId: pedidoId,productoId: _productoId,productoCodigoSnapshot: _productoCodigoSnapshot,productoNombreSnapshot: productoNombreSnapshot,cantidad: cantidad,precioUnitario: precioUnitario,descuento: descuento,subtotal: subtotal,);
    return _dataConnect.mutation("AgregarDetallePedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class AgregarDetallePedidoDetallePedidoInsert {
  final String id;
  AgregarDetallePedidoDetallePedidoInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AgregarDetallePedidoDetallePedidoInsert otherTyped = other as AgregarDetallePedidoDetallePedidoInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  AgregarDetallePedidoDetallePedidoInsert({
    required this.id,
  });
}

@immutable
class AgregarDetallePedidoData {
  final AgregarDetallePedidoDetallePedidoInsert detallePedido_insert;
  AgregarDetallePedidoData.fromJson(dynamic json):
  
  detallePedido_insert = AgregarDetallePedidoDetallePedidoInsert.fromJson(json['detallePedido_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AgregarDetallePedidoData otherTyped = other as AgregarDetallePedidoData;
    return detallePedido_insert == otherTyped.detallePedido_insert;
    
  }
  @override
  int get hashCode => detallePedido_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['detallePedido_insert'] = detallePedido_insert.toJson();
    return json;
  }

  AgregarDetallePedidoData({
    required this.detallePedido_insert,
  });
}

@immutable
class AgregarDetallePedidoVariables {
  final String negocioId;
  final String pedidoId;
  late final Optional<String>productoId;
  late final Optional<String>productoCodigoSnapshot;
  final String productoNombreSnapshot;
  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final double subtotal;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  AgregarDetallePedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  pedidoId = nativeFromJson<String>(json['pedidoId']),
  productoNombreSnapshot = nativeFromJson<String>(json['productoNombreSnapshot']),
  cantidad = nativeFromJson<int>(json['cantidad']),
  precioUnitario = nativeFromJson<double>(json['precioUnitario']),
  descuento = nativeFromJson<double>(json['descuento']),
  subtotal = nativeFromJson<double>(json['subtotal']) {
  
  
  
  
    productoId = Optional.optional(nativeFromJson, nativeToJson);
    productoId.value = json['productoId'] == null ? null : nativeFromJson<String>(json['productoId']);
  
  
    productoCodigoSnapshot = Optional.optional(nativeFromJson, nativeToJson);
    productoCodigoSnapshot.value = json['productoCodigoSnapshot'] == null ? null : nativeFromJson<String>(json['productoCodigoSnapshot']);
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final AgregarDetallePedidoVariables otherTyped = other as AgregarDetallePedidoVariables;
    return negocioId == otherTyped.negocioId && 
    pedidoId == otherTyped.pedidoId && 
    productoId == otherTyped.productoId && 
    productoCodigoSnapshot == otherTyped.productoCodigoSnapshot && 
    productoNombreSnapshot == otherTyped.productoNombreSnapshot && 
    cantidad == otherTyped.cantidad && 
    precioUnitario == otherTyped.precioUnitario && 
    descuento == otherTyped.descuento && 
    subtotal == otherTyped.subtotal;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, pedidoId.hashCode, productoId.hashCode, productoCodigoSnapshot.hashCode, productoNombreSnapshot.hashCode, cantidad.hashCode, precioUnitario.hashCode, descuento.hashCode, subtotal.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['pedidoId'] = nativeToJson<String>(pedidoId);
    if(productoId.state == OptionalState.set) {
      json['productoId'] = productoId.toJson();
    }
    if(productoCodigoSnapshot.state == OptionalState.set) {
      json['productoCodigoSnapshot'] = productoCodigoSnapshot.toJson();
    }
    json['productoNombreSnapshot'] = nativeToJson<String>(productoNombreSnapshot);
    json['cantidad'] = nativeToJson<int>(cantidad);
    json['precioUnitario'] = nativeToJson<double>(precioUnitario);
    json['descuento'] = nativeToJson<double>(descuento);
    json['subtotal'] = nativeToJson<double>(subtotal);
    return json;
  }

  AgregarDetallePedidoVariables({
    required this.negocioId,
    required this.pedidoId,
    required this.productoId,
    required this.productoCodigoSnapshot,
    required this.productoNombreSnapshot,
    required this.cantidad,
    required this.precioUnitario,
    required this.descuento,
    required this.subtotal,
  });
}

