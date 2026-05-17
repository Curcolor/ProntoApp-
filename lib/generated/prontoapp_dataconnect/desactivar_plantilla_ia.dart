part of 'prontoapp.dart';

class DesactivarPlantillaIaVariablesBuilder {
  String negocioId;
  String id;

  final FirebaseDataConnect _dataConnect;
  DesactivarPlantillaIaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,});
  Deserializer<DesactivarPlantillaIaData> dataDeserializer = (dynamic json)  => DesactivarPlantillaIaData.fromJson(jsonDecode(json));
  Serializer<DesactivarPlantillaIaVariables> varsSerializer = (DesactivarPlantillaIaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DesactivarPlantillaIaData, DesactivarPlantillaIaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DesactivarPlantillaIaData, DesactivarPlantillaIaVariables> ref() {
    DesactivarPlantillaIaVariables vars= DesactivarPlantillaIaVariables(negocioId: negocioId,id: id,);
    return _dataConnect.mutation("DesactivarPlantillaIa", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DesactivarPlantillaIaPlantillaIaUpdate {
  final String id;
  DesactivarPlantillaIaPlantillaIaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarPlantillaIaPlantillaIaUpdate otherTyped = other as DesactivarPlantillaIaPlantillaIaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DesactivarPlantillaIaPlantillaIaUpdate({
    required this.id,
  });
}

@immutable
class DesactivarPlantillaIaData {
  final DesactivarPlantillaIaPlantillaIaUpdate? plantillaIa_update;
  DesactivarPlantillaIaData.fromJson(dynamic json):
  
  plantillaIa_update = json['plantillaIa_update'] == null ? null : DesactivarPlantillaIaPlantillaIaUpdate.fromJson(json['plantillaIa_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarPlantillaIaData otherTyped = other as DesactivarPlantillaIaData;
    return plantillaIa_update == otherTyped.plantillaIa_update;
    
  }
  @override
  int get hashCode => plantillaIa_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (plantillaIa_update != null) {
      json['plantillaIa_update'] = plantillaIa_update!.toJson();
    }
    return json;
  }

  DesactivarPlantillaIaData({
    this.plantillaIa_update,
  });
}

@immutable
class DesactivarPlantillaIaVariables {
  final String negocioId;
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DesactivarPlantillaIaVariables.fromJson(Map<String, dynamic> json):
  
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

    final DesactivarPlantillaIaVariables otherTyped = other as DesactivarPlantillaIaVariables;
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

  DesactivarPlantillaIaVariables({
    required this.negocioId,
    required this.id,
  });
}

