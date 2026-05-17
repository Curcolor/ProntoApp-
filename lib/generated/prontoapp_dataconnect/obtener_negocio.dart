part of 'prontoapp.dart';

class ObtenerNegocioVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerNegocioVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerNegocioData> dataDeserializer = (dynamic json)  => ObtenerNegocioData.fromJson(jsonDecode(json));
  Serializer<ObtenerNegocioVariables> varsSerializer = (ObtenerNegocioVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerNegocioData, ObtenerNegocioVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerNegocioData, ObtenerNegocioVariables> ref() {
    ObtenerNegocioVariables vars= ObtenerNegocioVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerNegocio", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerNegocioNegocio {
  final String id;
  final String nombre;
  final EnumValue<TipoNegocio> tipoNegocio;
  final String? direccion;
  final String? horaApertura;
  final String? horaCierre;
  final EnumValue<FormatoEntrega> formatoEntrega;
  final String? numeroWhatsapp;
  final String zonaHoraria;
  final String monedaIso;
  final int minutosGraciaSla;
  final String? logoUrl;
  final bool activo;
  final Timestamp actualizadoEn;
  ObtenerNegocioNegocio.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  tipoNegocio = tipoNegocioDeserializer(json['tipoNegocio']),
  direccion = json['direccion'] == null ? null : nativeFromJson<String>(json['direccion']),
  horaApertura = json['horaApertura'] == null ? null : nativeFromJson<String>(json['horaApertura']),
  horaCierre = json['horaCierre'] == null ? null : nativeFromJson<String>(json['horaCierre']),
  formatoEntrega = formatoEntregaDeserializer(json['formatoEntrega']),
  numeroWhatsapp = json['numeroWhatsapp'] == null ? null : nativeFromJson<String>(json['numeroWhatsapp']),
  zonaHoraria = nativeFromJson<String>(json['zonaHoraria']),
  monedaIso = nativeFromJson<String>(json['monedaIso']),
  minutosGraciaSla = nativeFromJson<int>(json['minutosGraciaSla']),
  logoUrl = json['logoUrl'] == null ? null : nativeFromJson<String>(json['logoUrl']),
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

    final ObtenerNegocioNegocio otherTyped = other as ObtenerNegocioNegocio;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    tipoNegocio == otherTyped.tipoNegocio && 
    direccion == otherTyped.direccion && 
    horaApertura == otherTyped.horaApertura && 
    horaCierre == otherTyped.horaCierre && 
    formatoEntrega == otherTyped.formatoEntrega && 
    numeroWhatsapp == otherTyped.numeroWhatsapp && 
    zonaHoraria == otherTyped.zonaHoraria && 
    monedaIso == otherTyped.monedaIso && 
    minutosGraciaSla == otherTyped.minutosGraciaSla && 
    logoUrl == otherTyped.logoUrl && 
    activo == otherTyped.activo && 
    actualizadoEn == otherTyped.actualizadoEn;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, tipoNegocio.hashCode, direccion.hashCode, horaApertura.hashCode, horaCierre.hashCode, formatoEntrega.hashCode, numeroWhatsapp.hashCode, zonaHoraria.hashCode, monedaIso.hashCode, minutosGraciaSla.hashCode, logoUrl.hashCode, activo.hashCode, actualizadoEn.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    json['tipoNegocio'] = 
    tipoNegocioSerializer(tipoNegocio)
    ;
    if (direccion != null) {
      json['direccion'] = nativeToJson<String?>(direccion);
    }
    if (horaApertura != null) {
      json['horaApertura'] = nativeToJson<String?>(horaApertura);
    }
    if (horaCierre != null) {
      json['horaCierre'] = nativeToJson<String?>(horaCierre);
    }
    json['formatoEntrega'] = 
    formatoEntregaSerializer(formatoEntrega)
    ;
    if (numeroWhatsapp != null) {
      json['numeroWhatsapp'] = nativeToJson<String?>(numeroWhatsapp);
    }
    json['zonaHoraria'] = nativeToJson<String>(zonaHoraria);
    json['monedaIso'] = nativeToJson<String>(monedaIso);
    json['minutosGraciaSla'] = nativeToJson<int>(minutosGraciaSla);
    if (logoUrl != null) {
      json['logoUrl'] = nativeToJson<String?>(logoUrl);
    }
    json['activo'] = nativeToJson<bool>(activo);
    json['actualizadoEn'] = actualizadoEn.toJson();
    return json;
  }

  ObtenerNegocioNegocio({
    required this.id,
    required this.nombre,
    required this.tipoNegocio,
    this.direccion,
    this.horaApertura,
    this.horaCierre,
    required this.formatoEntrega,
    this.numeroWhatsapp,
    required this.zonaHoraria,
    required this.monedaIso,
    required this.minutosGraciaSla,
    this.logoUrl,
    required this.activo,
    required this.actualizadoEn,
  });
}

@immutable
class ObtenerNegocioData {
  final ObtenerNegocioNegocio? negocio;
  ObtenerNegocioData.fromJson(dynamic json):
  
  negocio = json['negocio'] == null ? null : ObtenerNegocioNegocio.fromJson(json['negocio']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerNegocioData otherTyped = other as ObtenerNegocioData;
    return negocio == otherTyped.negocio;
    
  }
  @override
  int get hashCode => negocio.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (negocio != null) {
      json['negocio'] = negocio!.toJson();
    }
    return json;
  }

  ObtenerNegocioData({
    this.negocio,
  });
}

@immutable
class ObtenerNegocioVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerNegocioVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerNegocioVariables otherTyped = other as ObtenerNegocioVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerNegocioVariables({
    required this.negocioId,
  });
}

