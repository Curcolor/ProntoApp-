part of 'prontoapp.dart';

class CrearCategoriaVariablesBuilder {
  String negocioId;
  String nombre;
  Optional<String> _emoji = Optional.optional(nativeFromJson, nativeToJson);
  int orden;

  final FirebaseDataConnect _dataConnect;  CrearCategoriaVariablesBuilder emoji(String? t) {
   _emoji.value = t;
   return this;
  }

  CrearCategoriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.nombre,required  this.orden,});
  Deserializer<CrearCategoriaData> dataDeserializer = (dynamic json)  => CrearCategoriaData.fromJson(jsonDecode(json));
  Serializer<CrearCategoriaVariables> varsSerializer = (CrearCategoriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearCategoriaData, CrearCategoriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearCategoriaData, CrearCategoriaVariables> ref() {
    CrearCategoriaVariables vars= CrearCategoriaVariables(negocioId: negocioId,nombre: nombre,emoji: _emoji,orden: orden,);
    return _dataConnect.mutation("CrearCategoria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearCategoriaCategoriaInsert {
  final String id;
  CrearCategoriaCategoriaInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearCategoriaCategoriaInsert otherTyped = other as CrearCategoriaCategoriaInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearCategoriaCategoriaInsert({
    required this.id,
  });
}

@immutable
class CrearCategoriaData {
  final CrearCategoriaCategoriaInsert categoria_insert;
  CrearCategoriaData.fromJson(dynamic json):
  
  categoria_insert = CrearCategoriaCategoriaInsert.fromJson(json['categoria_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearCategoriaData otherTyped = other as CrearCategoriaData;
    return categoria_insert == otherTyped.categoria_insert;
    
  }
  @override
  int get hashCode => categoria_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categoria_insert'] = categoria_insert.toJson();
    return json;
  }

  CrearCategoriaData({
    required this.categoria_insert,
  });
}

@immutable
class CrearCategoriaVariables {
  final String negocioId;
  final String nombre;
  late final Optional<String>emoji;
  final int orden;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearCategoriaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  nombre = nativeFromJson<String>(json['nombre']),
  orden = nativeFromJson<int>(json['orden']) {
  
  
  
  
    emoji = Optional.optional(nativeFromJson, nativeToJson);
    emoji.value = json['emoji'] == null ? null : nativeFromJson<String>(json['emoji']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearCategoriaVariables otherTyped = other as CrearCategoriaVariables;
    return negocioId == otherTyped.negocioId && 
    nombre == otherTyped.nombre && 
    emoji == otherTyped.emoji && 
    orden == otherTyped.orden;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, nombre.hashCode, emoji.hashCode, orden.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['nombre'] = nativeToJson<String>(nombre);
    if(emoji.state == OptionalState.set) {
      json['emoji'] = emoji.toJson();
    }
    json['orden'] = nativeToJson<int>(orden);
    return json;
  }

  CrearCategoriaVariables({
    required this.negocioId,
    required this.nombre,
    required this.emoji,
    required this.orden,
  });
}

