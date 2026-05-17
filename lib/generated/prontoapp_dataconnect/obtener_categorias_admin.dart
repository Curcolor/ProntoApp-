part of 'prontoapp.dart';

class ObtenerCategoriasAdminVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerCategoriasAdminVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerCategoriasAdminData> dataDeserializer = (dynamic json)  => ObtenerCategoriasAdminData.fromJson(jsonDecode(json));
  Serializer<ObtenerCategoriasAdminVariables> varsSerializer = (ObtenerCategoriasAdminVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerCategoriasAdminData, ObtenerCategoriasAdminVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerCategoriasAdminData, ObtenerCategoriasAdminVariables> ref() {
    ObtenerCategoriasAdminVariables vars= ObtenerCategoriasAdminVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerCategoriasAdmin", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerCategoriasAdminCategorias {
  final String id;
  final String nombre;
  final String? emoji;
  final int orden;
  final bool activo;
  final Timestamp actualizadoEn;
  ObtenerCategoriasAdminCategorias.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  emoji = json['emoji'] == null ? null : nativeFromJson<String>(json['emoji']),
  orden = nativeFromJson<int>(json['orden']),
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

    final ObtenerCategoriasAdminCategorias otherTyped = other as ObtenerCategoriasAdminCategorias;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    emoji == otherTyped.emoji && 
    orden == otherTyped.orden && 
    activo == otherTyped.activo && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, emoji.hashCode, orden.hashCode, activo.hashCode, actualizadoEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if (emoji != null) {
      json['emoji'] = nativeToJson<String?>(emoji);
    }
    json['orden'] = nativeToJson<int>(orden);
    json['activo'] = nativeToJson<bool>(activo);
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerCategoriasAdminCategorias({
    required this.id,
    required this.nombre,
    this.emoji,
    required this.orden,
    required this.activo,
    required this.actualizadoEn,
  });
}

@immutable
class ObtenerCategoriasAdminData {
  final List<ObtenerCategoriasAdminCategorias> categorias;
  ObtenerCategoriasAdminData.fromJson(dynamic json):
  
  categorias = (json['categorias'] as List<dynamic>)
        .map((e) => ObtenerCategoriasAdminCategorias.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerCategoriasAdminData otherTyped = other as ObtenerCategoriasAdminData;
    return categorias == otherTyped.categorias;
    
  }
  @override
  int get hashCode => categorias.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categorias'] = categorias.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerCategoriasAdminData({
    required this.categorias,
  });
}

@immutable
class ObtenerCategoriasAdminVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerCategoriasAdminVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerCategoriasAdminVariables otherTyped = other as ObtenerCategoriasAdminVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerCategoriasAdminVariables({
    required this.negocioId,
  });
}

