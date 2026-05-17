part of 'prontoapp.dart';

class CrearPlantillaIaVariablesBuilder {
  String negocioId;
  String codigo;
  CasoUsoPlantilla casoUso;
  int version;
  ProveedorLlm proveedor;
  String modelo;
  String promptSistema;
  Optional<String> _promptUsuarioTemplate = Optional.optional(nativeFromJson, nativeToJson);
  Optional<AnyValue> _herramientasHabilitadas = Optional.optional(AnyValue.fromJson, defaultSerializer);
  Optional<double> _temperatura = Optional.optional(nativeFromJson, nativeToJson);
  Optional<double> _topP = Optional.optional(nativeFromJson, nativeToJson);
  Optional<int> _maxTokens = Optional.optional(nativeFromJson, nativeToJson);
  String idioma;

  final FirebaseDataConnect _dataConnect;  CrearPlantillaIaVariablesBuilder promptUsuarioTemplate(String? t) {
   _promptUsuarioTemplate.value = t;
   return this;
  }
  CrearPlantillaIaVariablesBuilder herramientasHabilitadas(AnyValue? t) {
   _herramientasHabilitadas.value = t;
   return this;
  }
  CrearPlantillaIaVariablesBuilder temperatura(double? t) {
   _temperatura.value = t;
   return this;
  }
  CrearPlantillaIaVariablesBuilder topP(double? t) {
   _topP.value = t;
   return this;
  }
  CrearPlantillaIaVariablesBuilder maxTokens(int? t) {
   _maxTokens.value = t;
   return this;
  }

  CrearPlantillaIaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.codigo,required  this.casoUso,required  this.version,required  this.proveedor,required  this.modelo,required  this.promptSistema,required  this.idioma,});
  Deserializer<CrearPlantillaIaData> dataDeserializer = (dynamic json)  => CrearPlantillaIaData.fromJson(jsonDecode(json));
  Serializer<CrearPlantillaIaVariables> varsSerializer = (CrearPlantillaIaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CrearPlantillaIaData, CrearPlantillaIaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CrearPlantillaIaData, CrearPlantillaIaVariables> ref() {
    CrearPlantillaIaVariables vars= CrearPlantillaIaVariables(negocioId: negocioId,codigo: codigo,casoUso: casoUso,version: version,proveedor: proveedor,modelo: modelo,promptSistema: promptSistema,promptUsuarioTemplate: _promptUsuarioTemplate,herramientasHabilitadas: _herramientasHabilitadas,temperatura: _temperatura,topP: _topP,maxTokens: _maxTokens,idioma: idioma,);
    return _dataConnect.mutation("CrearPlantillaIa", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CrearPlantillaIaPlantillaIaInsert {
  final String id;
  CrearPlantillaIaPlantillaIaInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPlantillaIaPlantillaIaInsert otherTyped = other as CrearPlantillaIaPlantillaIaInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CrearPlantillaIaPlantillaIaInsert({
    required this.id,
  });
}

@immutable
class CrearPlantillaIaData {
  final CrearPlantillaIaPlantillaIaInsert plantillaIa_insert;
  CrearPlantillaIaData.fromJson(dynamic json):
  
  plantillaIa_insert = CrearPlantillaIaPlantillaIaInsert.fromJson(json['plantillaIa_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPlantillaIaData otherTyped = other as CrearPlantillaIaData;
    return plantillaIa_insert == otherTyped.plantillaIa_insert;
    
  }
  @override
  int get hashCode => plantillaIa_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['plantillaIa_insert'] = plantillaIa_insert.toJson();
    return json;
  }

  CrearPlantillaIaData({
    required this.plantillaIa_insert,
  });
}

@immutable
class CrearPlantillaIaVariables {
  final String negocioId;
  final String codigo;
  final CasoUsoPlantilla casoUso;
  final int version;
  final ProveedorLlm proveedor;
  final String modelo;
  final String promptSistema;
  late final Optional<String>promptUsuarioTemplate;
  late final Optional<AnyValue>herramientasHabilitadas;
  late final Optional<double>temperatura;
  late final Optional<double>topP;
  late final Optional<int>maxTokens;
  final String idioma;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CrearPlantillaIaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  codigo = nativeFromJson<String>(json['codigo']),
  casoUso = CasoUsoPlantilla.values.byName(json['casoUso']),
  version = nativeFromJson<int>(json['version']),
  proveedor = ProveedorLlm.values.byName(json['proveedor']),
  modelo = nativeFromJson<String>(json['modelo']),
  promptSistema = nativeFromJson<String>(json['promptSistema']),
  idioma = nativeFromJson<String>(json['idioma']) {
  
  
  
  
  
  
  
  
  
    promptUsuarioTemplate = Optional.optional(nativeFromJson, nativeToJson);
    promptUsuarioTemplate.value = json['promptUsuarioTemplate'] == null ? null : nativeFromJson<String>(json['promptUsuarioTemplate']);
  
  
    herramientasHabilitadas = Optional.optional(AnyValue.fromJson, defaultSerializer);
    herramientasHabilitadas.value = json['herramientasHabilitadas'] == null ? null : AnyValue.fromJson(json['herramientasHabilitadas']);
  
  
    temperatura = Optional.optional(nativeFromJson, nativeToJson);
    temperatura.value = json['temperatura'] == null ? null : nativeFromJson<double>(json['temperatura']);
  
  
    topP = Optional.optional(nativeFromJson, nativeToJson);
    topP.value = json['topP'] == null ? null : nativeFromJson<double>(json['topP']);
  
  
    maxTokens = Optional.optional(nativeFromJson, nativeToJson);
    maxTokens.value = json['maxTokens'] == null ? null : nativeFromJson<int>(json['maxTokens']);
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CrearPlantillaIaVariables otherTyped = other as CrearPlantillaIaVariables;
    return negocioId == otherTyped.negocioId && 
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
    idioma == otherTyped.idioma;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, codigo.hashCode, casoUso.hashCode, version.hashCode, proveedor.hashCode, modelo.hashCode, promptSistema.hashCode, promptUsuarioTemplate.hashCode, herramientasHabilitadas.hashCode, temperatura.hashCode, topP.hashCode, maxTokens.hashCode, idioma.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['codigo'] = nativeToJson<String>(codigo);
    json['casoUso'] = 
    casoUso.name
    ;
    json['version'] = nativeToJson<int>(version);
    json['proveedor'] = 
    proveedor.name
    ;
    json['modelo'] = nativeToJson<String>(modelo);
    json['promptSistema'] = nativeToJson<String>(promptSistema);
    if(promptUsuarioTemplate.state == OptionalState.set) {
      json['promptUsuarioTemplate'] = promptUsuarioTemplate.toJson();
    }
    if(herramientasHabilitadas.state == OptionalState.set) {
      json['herramientasHabilitadas'] = herramientasHabilitadas.toJson();
    }
    if(temperatura.state == OptionalState.set) {
      json['temperatura'] = temperatura.toJson();
    }
    if(topP.state == OptionalState.set) {
      json['topP'] = topP.toJson();
    }
    if(maxTokens.state == OptionalState.set) {
      json['maxTokens'] = maxTokens.toJson();
    }
    json['idioma'] = nativeToJson<String>(idioma);
    return json;
  }

  CrearPlantillaIaVariables({
    required this.negocioId,
    required this.codigo,
    required this.casoUso,
    required this.version,
    required this.proveedor,
    required this.modelo,
    required this.promptSistema,
    required this.promptUsuarioTemplate,
    required this.herramientasHabilitadas,
    required this.temperatura,
    required this.topP,
    required this.maxTokens,
    required this.idioma,
  });
}

