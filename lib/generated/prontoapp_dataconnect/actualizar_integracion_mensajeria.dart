part of 'prontoapp.dart';

class ActualizarIntegracionMensajeriaVariablesBuilder {
  String negocioId;
  String id;
  String identificadorExterno;
  Optional<String> _nombreVisible = Optional.optional(nativeFromJson, nativeToJson);
  String credencialSecretRef;
  Optional<String> _webhookSecret = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _webhookUrl = Optional.optional(nativeFromJson, nativeToJson);
  bool activo;

  final FirebaseDataConnect _dataConnect;  ActualizarIntegracionMensajeriaVariablesBuilder nombreVisible(String? t) {
   _nombreVisible.value = t;
   return this;
  }
  ActualizarIntegracionMensajeriaVariablesBuilder webhookSecret(String? t) {
   _webhookSecret.value = t;
   return this;
  }
  ActualizarIntegracionMensajeriaVariablesBuilder webhookUrl(String? t) {
   _webhookUrl.value = t;
   return this;
  }

  ActualizarIntegracionMensajeriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,required  this.identificadorExterno,required  this.credencialSecretRef,required  this.activo,});
  Deserializer<ActualizarIntegracionMensajeriaData> dataDeserializer = (dynamic json)  => ActualizarIntegracionMensajeriaData.fromJson(jsonDecode(json));
  Serializer<ActualizarIntegracionMensajeriaVariables> varsSerializer = (ActualizarIntegracionMensajeriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActualizarIntegracionMensajeriaData, ActualizarIntegracionMensajeriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActualizarIntegracionMensajeriaData, ActualizarIntegracionMensajeriaVariables> ref() {
    ActualizarIntegracionMensajeriaVariables vars= ActualizarIntegracionMensajeriaVariables(negocioId: negocioId,id: id,identificadorExterno: identificadorExterno,nombreVisible: _nombreVisible,credencialSecretRef: credencialSecretRef,webhookSecret: _webhookSecret,webhookUrl: _webhookUrl,activo: activo,);
    return _dataConnect.mutation("ActualizarIntegracionMensajeria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate {
  final String id;
  ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate otherTyped = other as ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate({
    required this.id,
  });
}

@immutable
class ActualizarIntegracionMensajeriaData {
  final ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate? integracionMensajeria_update;
  ActualizarIntegracionMensajeriaData.fromJson(dynamic json):
  
  integracionMensajeria_update = json['integracionMensajeria_update'] == null ? null : ActualizarIntegracionMensajeriaIntegracionMensajeriaUpdate.fromJson(json['integracionMensajeria_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarIntegracionMensajeriaData otherTyped = other as ActualizarIntegracionMensajeriaData;
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

  ActualizarIntegracionMensajeriaData({
    this.integracionMensajeria_update,
  });
}

@immutable
class ActualizarIntegracionMensajeriaVariables {
  final String negocioId;
  final String id;
  final String identificadorExterno;
  late final Optional<String>nombreVisible;
  final String credencialSecretRef;
  late final Optional<String>webhookSecret;
  late final Optional<String>webhookUrl;
  final bool activo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActualizarIntegracionMensajeriaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  id = nativeFromJson<String>(json['id']),
  identificadorExterno = nativeFromJson<String>(json['identificadorExterno']),
  credencialSecretRef = nativeFromJson<String>(json['credencialSecretRef']),
  activo = nativeFromJson<bool>(json['activo']) {
  
  
  
  
  
    nombreVisible = Optional.optional(nativeFromJson, nativeToJson);
    nombreVisible.value = json['nombreVisible'] == null ? null : nativeFromJson<String>(json['nombreVisible']);
  
  
  
    webhookSecret = Optional.optional(nativeFromJson, nativeToJson);
    webhookSecret.value = json['webhookSecret'] == null ? null : nativeFromJson<String>(json['webhookSecret']);
  
  
    webhookUrl = Optional.optional(nativeFromJson, nativeToJson);
    webhookUrl.value = json['webhookUrl'] == null ? null : nativeFromJson<String>(json['webhookUrl']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarIntegracionMensajeriaVariables otherTyped = other as ActualizarIntegracionMensajeriaVariables;
    return negocioId == otherTyped.negocioId && 
    id == otherTyped.id && 
    identificadorExterno == otherTyped.identificadorExterno && 
    nombreVisible == otherTyped.nombreVisible && 
    credencialSecretRef == otherTyped.credencialSecretRef && 
    webhookSecret == otherTyped.webhookSecret && 
    webhookUrl == otherTyped.webhookUrl && 
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, id.hashCode, identificadorExterno.hashCode, nombreVisible.hashCode, credencialSecretRef.hashCode, webhookSecret.hashCode, webhookUrl.hashCode, activo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['id'] = nativeToJson<String>(id);
    json['identificadorExterno'] = nativeToJson<String>(identificadorExterno);
    if(nombreVisible.state == OptionalState.set) {
      json['nombreVisible'] = nombreVisible.toJson();
    }
    json['credencialSecretRef'] = nativeToJson<String>(credencialSecretRef);
    if(webhookSecret.state == OptionalState.set) {
      json['webhookSecret'] = webhookSecret.toJson();
    }
    if(webhookUrl.state == OptionalState.set) {
      json['webhookUrl'] = webhookUrl.toJson();
    }
    json['activo'] = nativeToJson<bool>(activo);
    return json;
  }

  ActualizarIntegracionMensajeriaVariables({
    required this.negocioId,
    required this.id,
    required this.identificadorExterno,
    required this.nombreVisible,
    required this.credencialSecretRef,
    required this.webhookSecret,
    required this.webhookUrl,
    required this.activo,
  });
}

