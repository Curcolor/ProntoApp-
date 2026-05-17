part of 'prontoapp.dart';

class DesactivarIntegracionMensajeriaVariablesBuilder {
  String negocioId;
  String id;

  final FirebaseDataConnect _dataConnect;
  DesactivarIntegracionMensajeriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,});
  Deserializer<DesactivarIntegracionMensajeriaData> dataDeserializer = (dynamic json)  => DesactivarIntegracionMensajeriaData.fromJson(jsonDecode(json));
  Serializer<DesactivarIntegracionMensajeriaVariables> varsSerializer = (DesactivarIntegracionMensajeriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<DesactivarIntegracionMensajeriaData, DesactivarIntegracionMensajeriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<DesactivarIntegracionMensajeriaData, DesactivarIntegracionMensajeriaVariables> ref() {
    DesactivarIntegracionMensajeriaVariables vars= DesactivarIntegracionMensajeriaVariables(negocioId: negocioId,id: id,);
    return _dataConnect.mutation("DesactivarIntegracionMensajeria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate {
  final String id;
  DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate otherTyped = other as DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate({
    required this.id,
  });
}

@immutable
class DesactivarIntegracionMensajeriaData {
  final DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate? integracionMensajeria_update;
  DesactivarIntegracionMensajeriaData.fromJson(dynamic json):
  
  integracionMensajeria_update = json['integracionMensajeria_update'] == null ? null : DesactivarIntegracionMensajeriaIntegracionMensajeriaUpdate.fromJson(json['integracionMensajeria_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final DesactivarIntegracionMensajeriaData otherTyped = other as DesactivarIntegracionMensajeriaData;
    return integracionMensajeria_update == otherTyped.integracionMensajeria_update;
    
  }
  @override
  int get hashCode => integracionMensajeria_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (integracionMensajeria_update != null) {
      json['integracionMensajeria_update'] = integracionMensajeria_update!.toJson();
    }
    return json;
  }

  DesactivarIntegracionMensajeriaData({
    this.integracionMensajeria_update,
  });
}

@immutable
class DesactivarIntegracionMensajeriaVariables {
  final String negocioId;
  final String id;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  DesactivarIntegracionMensajeriaVariables.fromJson(Map<String, dynamic> json):
  
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

    final DesactivarIntegracionMensajeriaVariables otherTyped = other as DesactivarIntegracionMensajeriaVariables;
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

  DesactivarIntegracionMensajeriaVariables({
    required this.negocioId,
    required this.id,
  });
}

