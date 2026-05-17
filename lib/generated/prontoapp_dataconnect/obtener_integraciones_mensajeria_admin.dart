part of 'prontoapp.dart';

class ObtenerIntegracionesMensajeriaAdminVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerIntegracionesMensajeriaAdminVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerIntegracionesMensajeriaAdminData> dataDeserializer = (dynamic json)  => ObtenerIntegracionesMensajeriaAdminData.fromJson(jsonDecode(json));
  Serializer<ObtenerIntegracionesMensajeriaAdminVariables> varsSerializer = (ObtenerIntegracionesMensajeriaAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerIntegracionesMensajeriaAdminData, ObtenerIntegracionesMensajeriaAdminVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerIntegracionesMensajeriaAdminData, ObtenerIntegracionesMensajeriaAdminVariables> ref() {
    ObtenerIntegracionesMensajeriaAdminVariables vars= ObtenerIntegracionesMensajeriaAdminVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerIntegracionesMensajeriaAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria {
  final String id;
  final EnumValue<CanalMensajeria> canal;
  final String identificadorExterno;
  final String? nombreVisible;
  final String? webhookUrl;
  final bool activo;
  final Timestamp? verificadoEn;
  final Timestamp actualizadoEn;
  ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  canal = canalMensajeriaDeserializer(json['canal']),
  identificadorExterno = nativeFromJson<String>(json['identificadorExterno']),
  nombreVisible = json['nombreVisible'] == null ? null : nativeFromJson<String>(json['nombreVisible']),
  webhookUrl = json['webhookUrl'] == null ? null : nativeFromJson<String>(json['webhookUrl']),
  activo = nativeFromJson<bool>(json['activo']),
  verificadoEn = json['verificadoEn'] == null ? null : Timestamp.fromJson(json['verificadoEn']),
  actualizadoEn = Timestamp.fromJson(json['actualizadoEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria otherTyped = other as ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria;
    return id == otherTyped.id && 
    canal == otherTyped.canal && 
    identificadorExterno == otherTyped.identificadorExterno && 
    nombreVisible == otherTyped.nombreVisible && 
    webhookUrl == otherTyped.webhookUrl && 
    activo == otherTyped.activo && 
    verificadoEn == otherTyped.verificadoEn && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, canal.hashCode, identificadorExterno.hashCode, nombreVisible.hashCode, webhookUrl.hashCode, activo.hashCode, verificadoEn.hashCode, actualizadoEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['canal'] = 
    canalMensajeriaSerializer(canal)
    ;
    json['identificadorExterno'] = nativeToJson<String>(identificadorExterno);
    if (nombreVisible != null) {
      json['nombreVisible'] = nativeToJson<String?>(nombreVisible);
    }
    if (webhookUrl != null) {
      json['webhookUrl'] = nativeToJson<String?>(webhookUrl);
    }
    json['activo'] = nativeToJson<bool>(activo);
    if (verificadoEn != null) {
      json['verificadoEn'] = verificadoEn!.toJson();
    }
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria({
    required this.id,
    required this.canal,
    required this.identificadorExterno,
    this.nombreVisible,
    this.webhookUrl,
    required this.activo,
    this.verificadoEn,
    required this.actualizadoEn,
  });
}

@immutable
class ObtenerIntegracionesMensajeriaAdminData {
  final List<ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria> integracionesMensajeria;
  ObtenerIntegracionesMensajeriaAdminData.fromJson(dynamic json):
  
  integracionesMensajeria = (json['integracionesMensajeria'] as List<dynamic>)
        .map((e) => ObtenerIntegracionesMensajeriaAdminIntegracionesMensajeria.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaAdminData otherTyped = other as ObtenerIntegracionesMensajeriaAdminData;
    return integracionesMensajeria == otherTyped.integracionesMensajeria;
    
  }
  @override
  int get hashCode => integracionesMensajeria.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['integracionesMensajeria'] = integracionesMensajeria.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerIntegracionesMensajeriaAdminData({
    required this.integracionesMensajeria,
  });
}

@immutable
class ObtenerIntegracionesMensajeriaAdminVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerIntegracionesMensajeriaAdminVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaAdminVariables otherTyped = other as ObtenerIntegracionesMensajeriaAdminVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerIntegracionesMensajeriaAdminVariables({
    required this.negocioId,
  });
}

