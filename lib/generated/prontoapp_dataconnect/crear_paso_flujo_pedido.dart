part of 'prontoapp.dart';

class CrearPasoFlujoPedidoVariablesBuilder {
  String negocioId;
  EstadoPedido estado;
  String etiqueta;
  int orden;
  Optional<int> _minutosSla = Optional.optional(nativeFromJson, nativeToJson);
  DisparadorFlujo disparador;

  final FirebaseDataConnect _dataConnect;  CrearPasoFlujoPedidoVariablesBuilder minutosSla(int? t) {
   _minutosSla.value = t;
   return this;
  }

  CrearPasoFlujoPedidoVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.estado,required  this.etiqueta,required  this.orden,required  this.disparador,});
  Deserializer<CrearPasoFlujoPedidoData> dataDeserializer = (dynamic json)  => CrearPasoFlujoPedidoData.fromJson(jsonDecode(json));
  Serializer<CrearPasoFlujoPedidoVariables> varsSerializer = (CrearPasoFlujoPedidoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearPasoFlujoPedidoData, CrearPasoFlujoPedidoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearPasoFlujoPedidoData, CrearPasoFlujoPedidoVariables> ref() {
    CrearPasoFlujoPedidoVariables vars= CrearPasoFlujoPedidoVariables(negocioId: negocioId,estado: estado,etiqueta: etiqueta,orden: orden,minutosSla: _minutosSla,disparador: disparador,);
    return _dataConnect.mutation("CrearPasoFlujoPedido", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearPasoFlujoPedidoPasoFlujoPedidoInsert {
  final String id;
  CrearPasoFlujoPedidoPasoFlujoPedidoInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPasoFlujoPedidoPasoFlujoPedidoInsert otherTyped = other as CrearPasoFlujoPedidoPasoFlujoPedidoInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearPasoFlujoPedidoPasoFlujoPedidoInsert({
    required this.id,
  });
}

@immutable
class CrearPasoFlujoPedidoData {
  final CrearPasoFlujoPedidoPasoFlujoPedidoInsert pasoFlujoPedido_insert;
  CrearPasoFlujoPedidoData.fromJson(dynamic json):
  
  pasoFlujoPedido_insert = CrearPasoFlujoPedidoPasoFlujoPedidoInsert.fromJson(json['pasoFlujoPedido_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPasoFlujoPedidoData otherTyped = other as CrearPasoFlujoPedidoData;
    return pasoFlujoPedido_insert == otherTyped.pasoFlujoPedido_insert;
    
  }
  @override
  int get hashCode => pasoFlujoPedido_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['pasoFlujoPedido_insert'] = pasoFlujoPedido_insert.toJson();
    return json;
  }

  CrearPasoFlujoPedidoData({
    required this.pasoFlujoPedido_insert,
  });
}

@immutable
class CrearPasoFlujoPedidoVariables {
  final String negocioId;
  final EstadoPedido estado;
  final String etiqueta;
  final int orden;
  late final Optional<int>minutosSla;
  final DisparadorFlujo disparador;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearPasoFlujoPedidoVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  estado = EstadoPedido.values.byName(json['estado']),
  etiqueta = nativeFromJson<String>(json['etiqueta']),
  orden = nativeFromJson<int>(json['orden']),
  disparador = DisparadorFlujo.values.byName(json['disparador']) {
  
  
  
  
  
  
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

    final CrearPasoFlujoPedidoVariables otherTyped = other as CrearPasoFlujoPedidoVariables;
    return negocioId == otherTyped.negocioId && 
    estado == otherTyped.estado && 
    etiqueta == otherTyped.etiqueta && 
    orden == otherTyped.orden && 
    minutosSla == otherTyped.minutosSla && 
    disparador == otherTyped.disparador;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, estado.hashCode, etiqueta.hashCode, orden.hashCode, minutosSla.hashCode, disparador.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['estado'] = 
    estado.name
    ;
    json['etiqueta'] = nativeToJson<String>(etiqueta);
    json['orden'] = nativeToJson<int>(orden);
    if(minutosSla.state == OptionalState.set) {
      json['minutosSla'] = minutosSla.toJson();
    }
    json['disparador'] = 
    disparador.name
    ;
    return json;
  }

  CrearPasoFlujoPedidoVariables({
    required this.negocioId,
    required this.estado,
    required this.etiqueta,
    required this.orden,
    required this.minutosSla,
    required this.disparador,
  });
}

