part of 'prontoapp.dart';

class CrearClienteVariablesBuilder {
  String negocioId;
  String nombre;
  String numeroWhatsapp;
  Optional<String> _email = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _notas = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CrearClienteVariablesBuilder email(String? t) {
   _email.value = t;
   return this;
  }
  CrearClienteVariablesBuilder notas(String? t) {
   _notas.value = t;
   return this;
  }

  CrearClienteVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.nombre,required  this.numeroWhatsapp,});
  Deserializer<CrearClienteData> dataDeserializer = (dynamic json)  => CrearClienteData.fromJson(jsonDecode(json));
  Serializer<CrearClienteVariables> varsSerializer = (CrearClienteVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearClienteData, CrearClienteVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearClienteData, CrearClienteVariables> ref() {
    CrearClienteVariables vars= CrearClienteVariables(negocioId: negocioId,nombre: nombre,numeroWhatsapp: numeroWhatsapp,email: _email,notas: _notas,);
    return _dataConnect.mutation("CrearCliente", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearClienteClienteInsert {
  final String id;
  CrearClienteClienteInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearClienteClienteInsert otherTyped = other as CrearClienteClienteInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearClienteClienteInsert({
    required this.id,
  });
}

@immutable
class CrearClienteData {
  final CrearClienteClienteInsert cliente_insert;
  CrearClienteData.fromJson(dynamic json):
  
  cliente_insert = CrearClienteClienteInsert.fromJson(json['cliente_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearClienteData otherTyped = other as CrearClienteData;
    return cliente_insert == otherTyped.cliente_insert;
    
  }
  @override
  int get hashCode => cliente_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['cliente_insert'] = cliente_insert.toJson();
    return json;
  }

  CrearClienteData({
    required this.cliente_insert,
  });
}

@immutable
class CrearClienteVariables {
  final String negocioId;
  final String nombre;
  final String numeroWhatsapp;
  late final Optional<String>email;
  late final Optional<String>notas;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearClienteVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  nombre = nativeFromJson<String>(json['nombre']),
  numeroWhatsapp = nativeFromJson<String>(json['numeroWhatsapp']) {
  
  
  
  
  
    email = Optional.optional(nativeFromJson, nativeToJson);
    email.value = json['email'] == null ? null : nativeFromJson<String>(json['email']);
  
  
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

    final CrearClienteVariables otherTyped = other as CrearClienteVariables;
    return negocioId == otherTyped.negocioId && 
    nombre == otherTyped.nombre && 
    numeroWhatsapp == otherTyped.numeroWhatsapp && 
    email == otherTyped.email && 
    notas == otherTyped.notas;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, nombre.hashCode, numeroWhatsapp.hashCode, email.hashCode, notas.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['nombre'] = nativeToJson<String>(nombre);
    json['numeroWhatsapp'] = nativeToJson<String>(numeroWhatsapp);
    if(email.state == OptionalState.set) {
      json['email'] = email.toJson();
    }
    if(notas.state == OptionalState.set) {
      json['notas'] = notas.toJson();
    }
    return json;
  }

  CrearClienteVariables({
    required this.negocioId,
    required this.nombre,
    required this.numeroWhatsapp,
    required this.email,
    required this.notas,
  });
}

