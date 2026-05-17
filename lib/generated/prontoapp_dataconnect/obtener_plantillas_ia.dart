part of 'prontoapp.dart';

class ObtenerPlantillasIaVariablesBuilder {
  String negocioId;
  CasoUsoPlantilla casoUso;

  final FirebaseDataConnect _dataConnect;
  ObtenerPlantillasIaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.casoUso,});
  Deserializer<ObtenerPlantillasIaData> dataDeserializer = (dynamic json)  => ObtenerPlantillasIaData.fromJson(jsonDecode(json));
  Serializer<ObtenerPlantillasIaVariables> varsSerializer = (ObtenerPlantillasIaVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerPlantillasIaData, ObtenerPlantillasIaVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerPlantillasIaData, ObtenerPlantillasIaVariables> ref() {
    ObtenerPlantillasIaVariables vars= ObtenerPlantillasIaVariables(negocioId: negocioId,casoUso: casoUso,);
    return _dataConnect.query("ObtenerPlantillasIa", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerPlantillasIaPlantillasIa {
  final String id;
  final String codigo;
  final EnumValue<CasoUsoPlantilla> casoUso;
  final int version;
  final EnumValue<ProveedorLlm> proveedor;
  final String modelo;
  final String promptSistema;
  final String? promptUsuarioTemplate;
  final double? temperatura;
  final int? maxTokens;
  final String? idioma;
  final AnyValue? herramientasHabilitadas;
  final Timestamp actualizadoEn;
  ObtenerPlantillasIaPlantillasIa.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigo = nativeFromJson<String>(json['codigo']),
  casoUso = casoUsoPlantillaDeserializer(json['casoUso']),
  version = nativeFromJson<int>(json['version']),
  proveedor = proveedorLlmDeserializer(json['proveedor']),
  modelo = nativeFromJson<String>(json['modelo']),
  promptSistema = nativeFromJson<String>(json['promptSistema']),
  promptUsuarioTemplate = json['promptUsuarioTemplate'] == null ? null : nativeFromJson<String>(json['promptUsuarioTemplate']),
  temperatura = json['temperatura'] == null ? null : nativeFromJson<double>(json['temperatura']),
  maxTokens = json['maxTokens'] == null ? null : nativeFromJson<int>(json['maxTokens']),
  idioma = json['idioma'] == null ? null : nativeFromJson<String>(json['idioma']),
  herramientasHabilitadas = json['herramientasHabilitadas'] == null ? null : AnyValue.fromJson(json['herramientasHabilitadas']),
  actualizadoEn = Timestamp.fromJson(json['actualizadoEn']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaPlantillasIa otherTyped = other as ObtenerPlantillasIaPlantillasIa;
    return id == otherTyped.id && 
    codigo == otherTyped.codigo && 
    casoUso == otherTyped.casoUso && 
    version == otherTyped.version && 
    proveedor == otherTyped.proveedor && 
    modelo == otherTyped.modelo && 
    promptSistema == otherTyped.promptSistema && 
    promptUsuarioTemplate == otherTyped.promptUsuarioTemplate && 
    temperatura == otherTyped.temperatura && 
    maxTokens == otherTyped.maxTokens && 
    idioma == otherTyped.idioma && 
    herramientasHabilitadas == otherTyped.herramientasHabilitadas && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigo.hashCode, casoUso.hashCode, version.hashCode, proveedor.hashCode, modelo.hashCode, promptSistema.hashCode, promptUsuarioTemplate.hashCode, temperatura.hashCode, maxTokens.hashCode, idioma.hashCode, herramientasHabilitadas.hashCode, actualizadoEn.hashCode]);
  

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
    if (temperatura != null) {
      json['temperatura'] = nativeToJson<double?>(temperatura);
    }
    if (maxTokens != null) {
      json['maxTokens'] = nativeToJson<int?>(maxTokens);
    }
    if (idioma != null) {
      json['idioma'] = nativeToJson<String?>(idioma);
    }
    if (herramientasHabilitadas != null) {
      json['herramientasHabilitadas'] = herramientasHabilitadas!.toJson();
    }
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerPlantillasIaPlantillasIa({
    required this.id,
    required this.codigo,
    required this.casoUso,
    required this.version,
    required this.proveedor,
    required this.modelo,
    required this.promptSistema,
    this.promptUsuarioTemplate,
    this.temperatura,
    this.maxTokens,
    this.idioma,
    this.herramientasHabilitadas,
    required this.actualizadoEn,
  });
}

@immutable
class ObtenerPlantillasIaData {
  final List<ObtenerPlantillasIaPlantillasIa> plantillasIa;
  ObtenerPlantillasIaData.fromJson(dynamic json):
  
  plantillasIa = (json['plantillasIa'] as List<dynamic>)
        .map((e) => ObtenerPlantillasIaPlantillasIa.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaData otherTyped = other as ObtenerPlantillasIaData;
    return plantillasIa == otherTyped.plantillasIa;
    
  }
  @override
  int get hashCode => plantillasIa.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['plantillasIa'] = plantillasIa.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerPlantillasIaData({
    required this.plantillasIa,
  });
}

@immutable
class ObtenerPlantillasIaVariables {
  final String negocioId;
  final CasoUsoPlantilla casoUso;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerPlantillasIaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  casoUso = CasoUsoPlantilla.values.byName(json['casoUso']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerPlantillasIaVariables otherTyped = other as ObtenerPlantillasIaVariables;
    return negocioId == otherTyped.negocioId && 
    casoUso == otherTyped.casoUso;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, casoUso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['casoUso'] = 
    casoUso.name
    ;
    return json;
  }

  ObtenerPlantillasIaVariables({
    required this.negocioId,
    required this.casoUso,
  });
}

