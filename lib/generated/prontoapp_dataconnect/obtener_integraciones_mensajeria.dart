part of 'prontoapp.dart';

class ObtenerIntegracionesMensajeriaVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerIntegracionesMensajeriaVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerIntegracionesMensajeriaData> dataDeserializer = (dynamic json)  => ObtenerIntegracionesMensajeriaData.fromJson(jsonDecode(json));
  Serializer<ObtenerIntegracionesMensajeriaVariables> varsSerializer = (ObtenerIntegracionesMensajeriaVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerIntegracionesMensajeriaData, ObtenerIntegracionesMensajeriaVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerIntegracionesMensajeriaData, ObtenerIntegracionesMensajeriaVariables> ref() {
    ObtenerIntegracionesMensajeriaVariables vars= ObtenerIntegracionesMensajeriaVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerIntegracionesMensajeria", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerIntegracionesMensajeriaIntegracionesMensajeria {
  final String id;
  final EnumValue<CanalMensajeria> canal;
  final String identificadorExterno;
  final String? nombreVisible;
  final String? webhookUrl;
  final bool activo;
  final Timestamp? verificadoEn;
  ObtenerIntegracionesMensajeriaIntegracionesMensajeria.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  canal = canalMensajeriaDeserializer(json['canal']),
  identificadorExterno = nativeFromJson<String>(json['identificadorExterno']),
  nombreVisible = json['nombreVisible'] == null ? null : nativeFromJson<String>(json['nombreVisible']),
  webhookUrl = json['webhookUrl'] == null ? null : nativeFromJson<String>(json['webhookUrl']),
  activo = nativeFromJson<bool>(json['activo']),
  verificadoEn = json['verificadoEn'] == null ? null : Timestamp.fromJson(json['verificadoEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaIntegracionesMensajeria otherTyped = other as ObtenerIntegracionesMensajeriaIntegracionesMensajeria;
    return id == otherTyped.id && 
    canal == otherTyped.canal && 
    identificadorExterno == otherTyped.identificadorExterno && 
    nombreVisible == otherTyped.nombreVisible && 
    webhookUrl == otherTyped.webhookUrl && 
    activo == otherTyped.activo && 
    verificadoEn == otherTyped.verificadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, canal.hashCode, identificadorExterno.hashCode, nombreVisible.hashCode, webhookUrl.hashCode, activo.hashCode, verificadoEn.hashCode]);
  

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
    return json;
  }

  ObtenerIntegracionesMensajeriaIntegracionesMensajeria({
    required this.id,
    required this.canal,
    required this.identificadorExterno,
    this.nombreVisible,
    this.webhookUrl,
    required this.activo,
    this.verificadoEn,
  });
}

@immutable
class ObtenerIntegracionesMensajeriaData {
  final List<ObtenerIntegracionesMensajeriaIntegracionesMensajeria> integracionesMensajeria;
  ObtenerIntegracionesMensajeriaData.fromJson(dynamic json):
  
  integracionesMensajeria = (json['integracionesMensajeria'] as List<dynamic>)
        .map((e) => ObtenerIntegracionesMensajeriaIntegracionesMensajeria.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaData otherTyped = other as ObtenerIntegracionesMensajeriaData;
    return integracionesMensajeria == otherTyped.integracionesMensajeria;
    
  }
  @override
  int get hashCode => integracionesMensajeria.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['integracionesMensajeria'] = integracionesMensajeria.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerIntegracionesMensajeriaData({
    required this.integracionesMensajeria,
  });
}

@immutable
class ObtenerIntegracionesMensajeriaVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerIntegracionesMensajeriaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerIntegracionesMensajeriaVariables otherTyped = other as ObtenerIntegracionesMensajeriaVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerIntegracionesMensajeriaVariables({
    required this.negocioId,
  });
}

