part of 'prontoapp.dart';

class ActualizarCategoriaVariablesBuilder {
  String negocioId;
  String id;
  String nombre;
  Optional<String> _emoji = Optional.optional(nativeFromJson, nativeToJson);
  int orden;

  final FirebaseDataConnect _dataConnect;  ActualizarCategoriaVariablesBuilder emoji(String? t) {
   _emoji.value = t;
   return this;
  }

  ActualizarCategoriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,required  this.nombre,required  this.orden,});
  Deserializer<ActualizarCategoriaData> dataDeserializer = (dynamic json)  => ActualizarCategoriaData.fromJson(jsonDecode(json));
  Serializer<ActualizarCategoriaVariables> varsSerializer = (ActualizarCategoriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActualizarCategoriaData, ActualizarCategoriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActualizarCategoriaData, ActualizarCategoriaVariables> ref() {
    ActualizarCategoriaVariables vars= ActualizarCategoriaVariables(negocioId: negocioId,id: id,nombre: nombre,emoji: _emoji,orden: orden,);
    return _dataConnect.mutation("ActualizarCategoria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActualizarCategoriaCategoriaUpdate {
  final String id;
  ActualizarCategoriaCategoriaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarCategoriaCategoriaUpdate otherTyped = other as ActualizarCategoriaCategoriaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActualizarCategoriaCategoriaUpdate({
    required this.id,
  });
}

@immutable
class ActualizarCategoriaData {
  final ActualizarCategoriaCategoriaUpdate? categoria_update;
  ActualizarCategoriaData.fromJson(dynamic json):
  
  categoria_update = json['categoria_update'] == null ? null : ActualizarCategoriaCategoriaUpdate.fromJson(json['categoria_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarCategoriaData otherTyped = other as ActualizarCategoriaData;
    return categoria_update == otherTyped.categoria_update;
    
  }
  @override
  int get hashCode => categoria_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (categoria_update != null) {
      json['categoria_update'] = categoria_update!.toJson();
    }
    return json;
  }

  ActualizarCategoriaData({
    this.categoria_update,
  });
}

@immutable
class ActualizarCategoriaVariables {
  final String negocioId;
  final String id;
  final String nombre;
  late final Optional<String>emoji;
  final int orden;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActualizarCategoriaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  id = nativeFromJson<String>(json['id']),
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

    final ActualizarCategoriaVariables otherTyped = other as ActualizarCategoriaVariables;
    return negocioId == otherTyped.negocioId && 
    id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    emoji == otherTyped.emoji && 
    orden == otherTyped.orden;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, id.hashCode, nombre.hashCode, emoji.hashCode, orden.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if(emoji.state == OptionalState.set) {
      json['emoji'] = emoji.toJson();
    }
    json['orden'] = nativeToJson<int>(orden);
    return json;
  }

  ActualizarCategoriaVariables({
    required this.negocioId,
    required this.id,
    required this.nombre,
    required this.emoji,
    required this.orden,
  });
}

