part of 'prontoapp.dart';

class DesactivarCategoriaVariablesBuilder {
  String negocioId;
  String id;

  final FirebaseDataConnect _dataConnect;
  DesactivarCategoriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,});
  Deserializer<DesactivarCategoriaData> dataDeserializer = (dynamic json)  => DesactivarCategoriaData.fromJson(jsonDecode(json));
  Serializer<DesactivarCategoriaVariables> varsSerializer = (DesactivarCategoriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DesactivarCategoriaData, DesactivarCategoriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DesactivarCategoriaData, DesactivarCategoriaVariables> ref() {
    DesactivarCategoriaVariables vars= DesactivarCategoriaVariables(negocioId: negocioId,id: id,);
    return _dataConnect.mutation("DesactivarCategoria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DesactivarCategoriaCategoriaUpdate {
  final String id;
  DesactivarCategoriaCategoriaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarCategoriaCategoriaUpdate otherTyped = other as DesactivarCategoriaCategoriaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DesactivarCategoriaCategoriaUpdate({
    required this.id,
  });
}

@immutable
class DesactivarCategoriaData {
  final DesactivarCategoriaCategoriaUpdate? categoria_update;
  DesactivarCategoriaData.fromJson(dynamic json):
  
  categoria_update = json['categoria_update'] == null ? null : DesactivarCategoriaCategoriaUpdate.fromJson(json['categoria_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarCategoriaData otherTyped = other as DesactivarCategoriaData;
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

  DesactivarCategoriaData({
    this.categoria_update,
  });
}

@immutable
class DesactivarCategoriaVariables {
  final String negocioId;
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DesactivarCategoriaVariables.fromJson(Map<String, dynamic> json):
  
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

    final DesactivarCategoriaVariables otherTyped = other as DesactivarCategoriaVariables;
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

  DesactivarCategoriaVariables({
    required this.negocioId,
    required this.id,
  });
}

