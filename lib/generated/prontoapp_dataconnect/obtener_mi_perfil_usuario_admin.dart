part of 'prontoapp.dart';

class ObtenerMiPerfilUsuarioAdminVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ObtenerMiPerfilUsuarioAdminVariablesBuilder(this._dataConnect, );
  Deserializer<ObtenerMiPerfilUsuarioAdminData> dataDeserializer = (dynamic json)  => ObtenerMiPerfilUsuarioAdminData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ObtenerMiPerfilUsuarioAdminData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerMiPerfilUsuarioAdminData, void> ref() {
    
    return _dataConnect.query("ObtenerMiPerfilUsuarioAdmin", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ObtenerMiPerfilUsuarioAdminUsuariosAdmin {
  final String id;
  final String nombre;
  final String email;
  final EnumValue<RolAdmin> cargo;
  final bool activo;
  final String negocioId;
  final Timestamp creadoEn;
  final ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio negocio;
  ObtenerMiPerfilUsuarioAdminUsuariosAdmin.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  email = nativeFromJson<String>(json['email']),
  cargo = rolAdminDeserializer(json['cargo']),
  activo = nativeFromJson<bool>(json['activo']),
  negocioId = nativeFromJson<String>(json['negocioId']),
  creadoEn = Timestamp.fromJson(json['creadoEn']),
  negocio = ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio.fromJson(json['negocio']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMiPerfilUsuarioAdminUsuariosAdmin otherTyped = other as ObtenerMiPerfilUsuarioAdminUsuariosAdmin;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    email == otherTyped.email && 
    cargo == otherTyped.cargo && 
    activo == otherTyped.activo && 
    negocioId == otherTyped.negocioId && 
    creadoEn == otherTyped.creadoEn && 
    negocio == otherTyped.negocio;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, email.hashCode, cargo.hashCode, activo.hashCode, negocioId.hashCode, creadoEn.hashCode, negocio.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['email'] = nativeToJson<String>(email);
    json['cargo'] = 
    rolAdminSerializer(cargo)
    ;
    json['activo'] = nativeToJson<bool>(activo);
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['creadoEn'] = creadoEn.toJson();
    json['negocio'] = negocio.toJson();
    return json;
  }

  ObtenerMiPerfilUsuarioAdminUsuariosAdmin({
    required this.id,
    required this.nombre,
    required this.email,
    required this.cargo,
    required this.activo,
    required this.negocioId,
    required this.creadoEn,
    required this.negocio,
  });
}

@immutable
class ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio {
  final String id;
  final String nombre;
  final EnumValue<TipoNegocio> tipoNegocio;
  final EnumValue<FormatoEntrega> formatoEntrega;
  final String zonaHoraria;
  final String monedaIso;
  ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  tipoNegocio = tipoNegocioDeserializer(json['tipoNegocio']),
  formatoEntrega = formatoEntregaDeserializer(json['formatoEntrega']),
  zonaHoraria = nativeFromJson<String>(json['zonaHoraria']),
  monedaIso = nativeFromJson<String>(json['monedaIso']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio otherTyped = other as ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    tipoNegocio == otherTyped.tipoNegocio && 
    formatoEntrega == otherTyped.formatoEntrega && 
    zonaHoraria == otherTyped.zonaHoraria && 
    monedaIso == otherTyped.monedaIso;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, tipoNegocio.hashCode, formatoEntrega.hashCode, zonaHoraria.hashCode, monedaIso.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['tipoNegocio'] = 
    tipoNegocioSerializer(tipoNegocio)
    ;
    json['formatoEntrega'] = 
    formatoEntregaSerializer(formatoEntrega)
    ;
    json['zonaHoraria'] = nativeToJson<String>(zonaHoraria);
    json['monedaIso'] = nativeToJson<String>(monedaIso);
    return json;
  }

  ObtenerMiPerfilUsuarioAdminUsuariosAdminNegocio({
    required this.id,
    required this.nombre,
    required this.tipoNegocio,
    required this.formatoEntrega,
    required this.zonaHoraria,
    required this.monedaIso,
  });
}

@immutable
class ObtenerMiPerfilUsuarioAdminData {
  final List<ObtenerMiPerfilUsuarioAdminUsuariosAdmin> usuariosAdmin;
  ObtenerMiPerfilUsuarioAdminData.fromJson(dynamic json):
  
  usuariosAdmin = (json['usuariosAdmin'] as List<dynamic>)
        .map((e) => ObtenerMiPerfilUsuarioAdminUsuariosAdmin.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMiPerfilUsuarioAdminData otherTyped = other as ObtenerMiPerfilUsuarioAdminData;
    return usuariosAdmin == otherTyped.usuariosAdmin;
    
  }
  @override
  int get hashCode => usuariosAdmin.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['usuariosAdmin'] = usuariosAdmin.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerMiPerfilUsuarioAdminData({
    required this.usuariosAdmin,
  });
}

