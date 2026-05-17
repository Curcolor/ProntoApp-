part of 'prontoapp.dart';

class ObtenerPlantillasIaAdminVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerPlantillasIaAdminVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerPlantillasIaAdminData> dataDeserializer = (dynamic json)  => ObtenerPlantillasIaAdminData.fromJson(jsonDecode(json));
  Serializer<ObtenerPlantillasIaAdminVariables> varsSerializer = (ObtenerPlantillasIaAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerPlantillasIaAdminData, ObtenerPlantillasIaAdminVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerPlantillasIaAdminData, ObtenerPlantillasIaAdminVariables> ref() {
    ObtenerPlantillasIaAdminVariables vars= ObtenerPlantillasIaAdminVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerPlantillasIaAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerPlantillasIaAdminPlantillasIa {
  final String id;
  final String codigo;
  final EnumValue<CasoUsoPlantilla> casoUso;
  final int version;
  final EnumValue<ProveedorLlm> proveedor;
  final String modelo;
  final String promptSistema;
  final String? promptUsuarioTemplate;
  final AnyValue? herramientasHabilitadas;
  final double? temperatura;
  final double? topP;
  final int? maxTokens;
  final String? idioma;
  final bool activo;
  final Timestamp actualizadoEn;
  ObtenerPlantillasIaAdminPlantillasIa.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigo = nativeFromJson<String>(json['codigo']),
  casoUso = casoUsoPlantillaDeserializer(json['casoUso']),
  version = nativeFromJson<int>(json['version']),
  proveedor = proveedorLlmDeserializer(json['proveedor']),
  modelo = nativeFromJson<String>(json['modelo']),
  promptSistema = nativeFromJson<String>(json['promptSistema']),
  promptUsuarioTemplate = json['promptUsuarioTemplate'] == null ? null : nativeFromJson<String>(json['promptUsuarioTemplate']),
  herramientasHabilitadas = json['herramientasHabilitadas'] == null ? null : AnyValue.fromJson(json['herramientasHabilitadas']),
  temperatura = json['temperatura'] == null ? null : nativeFromJson<double>(json['temperatura']),
  topP = json['topP'] == null ? null : nativeFromJson<double>(json['topP']),
  maxTokens = json['maxTokens'] == null ? null : nativeFromJson<int>(json['maxTokens']),
  idioma = json['idioma'] == null ? null : nativeFromJson<String>(json['idioma']),
  activo = nativeFromJson<bool>(json['activo']),
  actualizadoEn = Timestamp.fromJson(json['actualizadoEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaAdminPlantillasIa otherTyped = other as ObtenerPlantillasIaAdminPlantillasIa;
    return id == otherTyped.id && 
    codigo == otherTyped.codigo && 
    casoUso == otherTyped.casoUso && 
    version == otherTyped.version && 
    proveedor == otherTyped.proveedor && 
    modelo == otherTyped.modelo && 
    promptSistema == otherTyped.promptSistema && 
    promptUsuarioTemplate == otherTyped.promptUsuarioTemplate && 
    herramientasHabilitadas == otherTyped.herramientasHabilitadas && 
    temperatura == otherTyped.temperatura && 
    topP == otherTyped.topP && 
    maxTokens == otherTyped.maxTokens && 
    idioma == otherTyped.idioma && 
    activo == otherTyped.activo && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigo.hashCode, casoUso.hashCode, version.hashCode, proveedor.hashCode, modelo.hashCode, promptSistema.hashCode, promptUsuarioTemplate.hashCode, herramientasHabilitadas.hashCode, temperatura.hashCode, topP.hashCode, maxTokens.hashCode, idioma.hashCode, activo.hashCode, actualizadoEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['codigo'] = nativeToJson<String>(codigo);
    json['casoUso'] = 
    casoUsoPlantillaSerializer(casoUso)
    ;
    json['version'] = nativeToJson<int>(version);
    json['proveedor'] = 
    proveedorLlmSerializer(proveedor)
    ;
    json['modelo'] = nativeToJson<String>(modelo);
    json['promptSistema'] = nativeToJson<String>(promptSistema);
    if (promptUsuarioTemplate != null) {
      json['promptUsuarioTemplate'] = nativeToJson<String?>(promptUsuarioTemplate);
    }
    if (herramientasHabilitadas != null) {
      json['herramientasHabilitadas'] = herramientasHabilitadas!.toJson();
    }
    if (temperatura != null) {
      json['temperatura'] = nativeToJson<double?>(temperatura);
    }
    if (topP != null) {
      json['topP'] = nativeToJson<double?>(topP);
    }
    if (maxTokens != null) {
      json['maxTokens'] = nativeToJson<int?>(maxTokens);
    }
    if (idioma != null) {
      json['idioma'] = nativeToJson<String?>(idioma);
    }
    json['activo'] = nativeToJson<bool>(activo);
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerPlantillasIaAdminPlantillasIa({
    required this.id,
    required this.codigo,
    required this.casoUso,
    required this.version,
    required this.proveedor,
    required this.modelo,
    required this.promptSistema,
    this.promptUsuarioTemplate,
    this.herramientasHabilitadas,
    this.temperatura,
    this.topP,
    this.maxTokens,
    this.idioma,
    required this.activo,
    required this.actualizadoEn,
  });
}

@immutable
class ObtenerPlantillasIaAdminData {
  final List<ObtenerPlantillasIaAdminPlantillasIa> plantillasIa;
  ObtenerPlantillasIaAdminData.fromJson(dynamic json):
  
  plantillasIa = (json['plantillasIa'] as List<dynamic>)
        .map((e) => ObtenerPlantillasIaAdminPlantillasIa.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaAdminData otherTyped = other as ObtenerPlantillasIaAdminData;
    return plantillasIa == otherTyped.plantillasIa;
    
  }
  @override
  int get hashCode => plantillasIa.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['plantillasIa'] = plantillasIa.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerPlantillasIaAdminData({
    required this.plantillasIa,
  });
}

@immutable
class ObtenerPlantillasIaAdminVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerPlantillasIaAdminVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaAdminVariables otherTyped = other as ObtenerPlantillasIaAdminVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerPlantillasIaAdminVariables({
    required this.negocioId,
  });
}

