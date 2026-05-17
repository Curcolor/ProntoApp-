part of 'prontoapp.dart';

class CrearIntegracionMensajeriaVariablesBuilder {
  String negocioId;
  CanalMensajeria canal;
  String identificadorExterno;
  Optional<String> _nombreVisible = Optional.optional(nativeFromJson, nativeToJson);
  String credencialSecretRef;
  Optional<String> _webhookSecret = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _webhookUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CrearIntegracionMensajeriaVariablesBuilder nombreVisible(String? t) {
   _nombreVisible.value = t;
   return this;
  }
  CrearIntegracionMensajeriaVariablesBuilder webhookSecret(String? t) {
   _webhookSecret.value = t;
   return this;
  }
  CrearIntegracionMensajeriaVariablesBuilder webhookUrl(String? t) {
   _webhookUrl.value = t;
   return this;
  }

  CrearIntegracionMensajeriaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.canal,required  this.identificadorExterno,required  this.credencialSecretRef,});
  Deserializer<CrearIntegracionMensajeriaData> dataDeserializer = (dynamic json)  => CrearIntegracionMensajeriaData.fromJson(jsonDecode(json));
  Serializer<CrearIntegracionMensajeriaVariables> varsSerializer = (CrearIntegracionMensajeriaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearIntegracionMensajeriaData, CrearIntegracionMensajeriaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearIntegracionMensajeriaData, CrearIntegracionMensajeriaVariables> ref() {
    CrearIntegracionMensajeriaVariables vars= CrearIntegracionMensajeriaVariables(negocioId: negocioId,canal: canal,identificadorExterno: identificadorExterno,nombreVisible: _nombreVisible,credencialSecretRef: credencialSecretRef,webhookSecret: _webhookSecret,webhookUrl: _webhookUrl,);
    return _dataConnect.mutation("CrearIntegracionMensajeria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearIntegracionMensajeriaIntegracionMensajeriaInsert {
  final String id;
  CrearIntegracionMensajeriaIntegracionMensajeriaInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearIntegracionMensajeriaIntegracionMensajeriaInsert otherTyped = other as CrearIntegracionMensajeriaIntegracionMensajeriaInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearIntegracionMensajeriaIntegracionMensajeriaInsert({
    required this.id,
  });
}

@immutable
class CrearIntegracionMensajeriaData {
  final CrearIntegracionMensajeriaIntegracionMensajeriaInsert integracionMensajeria_insert;
  CrearIntegracionMensajeriaData.fromJson(dynamic json):
  
  integracionMensajeria_insert = CrearIntegracionMensajeriaIntegracionMensajeriaInsert.fromJson(json['integracionMensajeria_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearIntegracionMensajeriaData otherTyped = other as CrearIntegracionMensajeriaData;
    return integracionMensajeria_insert == otherTyped.integracionMensajeria_insert;
    
  }
  @override
  int get hashCode => integracionMensajeria_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['integracionMensajeria_insert'] = integracionMensajeria_insert.toJson();
    return json;
  }

  CrearIntegracionMensajeriaData({
    required this.integracionMensajeria_insert,
  });
}

@immutable
class CrearIntegracionMensajeriaVariables {
  final String negocioId;
  final CanalMensajeria canal;
  final String identificadorExterno;
  late final Optional<String>nombreVisible;
  final String credencialSecretRef;
  late final Optional<String>webhookSecret;
  late final Optional<String>webhookUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearIntegracionMensajeriaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  canal = CanalMensajeria.values.byName(json['canal']),
  identificadorExterno = nativeFromJson<String>(json['identificadorExterno']),
  credencialSecretRef = nativeFromJson<String>(json['credencialSecretRef']) {
  
  
  
  
  
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

    final CrearIntegracionMensajeriaVariables otherTyped = other as CrearIntegracionMensajeriaVariables;
    return negocioId == otherTyped.negocioId && 
    canal == otherTyped.canal && 
    identificadorExterno == otherTyped.identificadorExterno && 
    nombreVisible == otherTyped.nombreVisible && 
    credencialSecretRef == otherTyped.credencialSecretRef && 
    webhookSecret == otherTyped.webhookSecret && 
    webhookUrl == otherTyped.webhookUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, canal.hashCode, identificadorExterno.hashCode, nombreVisible.hashCode, credencialSecretRef.hashCode, webhookSecret.hashCode, webhookUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['canal'] = 
    canal.name
    ;
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
    return json;
  }

  CrearIntegracionMensajeriaVariables({
    required this.negocioId,
    required this.canal,
    required this.identificadorExterno,
    required this.nombreVisible,
    required this.credencialSecretRef,
    required this.webhookSecret,
    required this.webhookUrl,
  });
}

