part of 'prontoapp.dart';

class ActualizarPlantillaIaVariablesBuilder {
  String negocioId;
  String id;
  String codigo;
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
  bool activo;

  final FirebaseDataConnect _dataConnect;  ActualizarPlantillaIaVariablesBuilder promptUsuarioTemplate(String? t) {
   _promptUsuarioTemplate.value = t;
   return this;
  }
  ActualizarPlantillaIaVariablesBuilder herramientasHabilitadas(AnyValue? t) {
   _herramientasHabilitadas.value = t;
   return this;
  }
  ActualizarPlantillaIaVariablesBuilder temperatura(double? t) {
   _temperatura.value = t;
   return this;
  }
  ActualizarPlantillaIaVariablesBuilder topP(double? t) {
   _topP.value = t;
   return this;
  }
  ActualizarPlantillaIaVariablesBuilder maxTokens(int? t) {
   _maxTokens.value = t;
   return this;
  }

  ActualizarPlantillaIaVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.id,required  this.codigo,required  this.version,required  this.proveedor,required  this.modelo,required  this.promptSistema,required  this.idioma,required  this.activo,});
  Deserializer<ActualizarPlantillaIaData> dataDeserializer = (dynamic json)  => ActualizarPlantillaIaData.fromJson(jsonDecode(json));
  Serializer<ActualizarPlantillaIaVariables> varsSerializer = (ActualizarPlantillaIaVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActualizarPlantillaIaData, ActualizarPlantillaIaVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActualizarPlantillaIaData, ActualizarPlantillaIaVariables> ref() {
    ActualizarPlantillaIaVariables vars= ActualizarPlantillaIaVariables(negocioId: negocioId,id: id,codigo: codigo,version: version,proveedor: proveedor,modelo: modelo,promptSistema: promptSistema,promptUsuarioTemplate: _promptUsuarioTemplate,herramientasHabilitadas: _herramientasHabilitadas,temperatura: _temperatura,topP: _topP,maxTokens: _maxTokens,idioma: idioma,activo: activo,);
    return _dataConnect.mutation("ActualizarPlantillaIa", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActualizarPlantillaIaPlantillaIaUpdate {
  final String id;
  ActualizarPlantillaIaPlantillaIaUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarPlantillaIaPlantillaIaUpdate otherTyped = other as ActualizarPlantillaIaPlantillaIaUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActualizarPlantillaIaPlantillaIaUpdate({
    required this.id,
  });
}

@immutable
class ActualizarPlantillaIaData {
  final ActualizarPlantillaIaPlantillaIaUpdate? plantillaIa_update;
  ActualizarPlantillaIaData.fromJson(dynamic json):
  
  plantillaIa_update = json['plantillaIa_update'] == null ? null : ActualizarPlantillaIaPlantillaIaUpdate.fromJson(json['plantillaIa_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarPlantillaIaData otherTyped = other as ActualizarPlantillaIaData;
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

  ActualizarPlantillaIaData({
    this.plantillaIa_update,
  });
}

@immutable
class ActualizarPlantillaIaVariables {
  final String negocioId;
  final String id;
  final String codigo;
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
  final bool activo;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActualizarPlantillaIaVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  id = nativeFromJson<String>(json['id']),
  codigo = nativeFromJson<String>(json['codigo']),
  version = nativeFromJson<int>(json['version']),
  proveedor = ProveedorLlm.values.byName(json['proveedor']),
  modelo = nativeFromJson<String>(json['modelo']),
  promptSistema = nativeFromJson<String>(json['promptSistema']),
  idioma = nativeFromJson<String>(json['idioma']),
  activo = nativeFromJson<bool>(json['activo']) {
  
  
  
  
  
  
  
  
  
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

    final ActualizarPlantillaIaVariables otherTyped = other as ActualizarPlantillaIaVariables;
    return negocioId == otherTyped.negocioId && 
    id == otherTyped.id && 
    codigo == otherTyped.codigo && 
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
    activo == otherTyped.activo;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, id.hashCode, codigo.hashCode, version.hashCode, proveedor.hashCode, modelo.hashCode, promptSistema.hashCode, promptUsuarioTemplate.hashCode, herramientasHabilitadas.hashCode, temperatura.hashCode, topP.hashCode, maxTokens.hashCode, idioma.hashCode, activo.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['id'] = nativeToJson<String>(id);
    json['codigo'] = nativeToJson<String>(codigo);
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
    json['activo'] = nativeToJson<bool>(activo);
    return json;
  }

  ActualizarPlantillaIaVariables({
    required this.negocioId,
    required this.id,
    required this.codigo,
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
    required this.activo,
  });
}

