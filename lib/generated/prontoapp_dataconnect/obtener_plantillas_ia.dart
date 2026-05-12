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
  final String prompt;
  final EnumValue<CasoUsoPlantilla> casoUso;
  final int version;
  final Timestamp actualizadoEn;
  ObtenerPlantillasIaPlantillasIa.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  codigo = nativeFromJson<String>(json['codigo']),
  prompt = nativeFromJson<String>(json['prompt']),
  casoUso = casoUsoPlantillaDeserializer(json['casoUso']),
  version = nativeFromJson<int>(json['version']),
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
    prompt == otherTyped.prompt && 
    casoUso == otherTyped.casoUso && 
    version == otherTyped.version && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, codigo.hashCode, prompt.hashCode, casoUso.hashCode, version.hashCode, actualizadoEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['codigo'] = nativeToJson<String>(codigo);
    json['prompt'] = nativeToJson<String>(prompt);
    json['casoUso'] = 
    casoUsoPlantillaSerializer(casoUso)
    ;
    json['version'] = nativeToJson<int>(version);
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerPlantillasIaPlantillasIa({
    required this.id,
    required this.codigo,
    required this.prompt,
    required this.casoUso,
    required this.version,
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

