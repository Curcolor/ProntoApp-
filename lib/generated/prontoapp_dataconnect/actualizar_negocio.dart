part of 'prontoapp.dart';

class ActualizarNegocioVariablesBuilder {
  String negocioId;
  String nombre;
  Optional<String> _direccion = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _horaApertura = Optional.optional(nativeFromJson, nativeToJson);
  Optional<String> _horaCierre = Optional.optional(nativeFromJson, nativeToJson);
  FormatoEntrega formatoEntrega;
  Optional<String> _numeroWhatsapp = Optional.optional(nativeFromJson, nativeToJson);
  String zonaHoraria;
  String monedaIso;
  int minutosGraciaSla;
  Optional<String> _logoUrl = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  ActualizarNegocioVariablesBuilder direccion(String? t) {
   _direccion.value = t;
   return this;
  }
  ActualizarNegocioVariablesBuilder horaApertura(String? t) {
   _horaApertura.value = t;
   return this;
  }
  ActualizarNegocioVariablesBuilder horaCierre(String? t) {
   _horaCierre.value = t;
   return this;
  }
  ActualizarNegocioVariablesBuilder numeroWhatsapp(String? t) {
   _numeroWhatsapp.value = t;
   return this;
  }
  ActualizarNegocioVariablesBuilder logoUrl(String? t) {
   _logoUrl.value = t;
   return this;
  }

  ActualizarNegocioVariablesBuilder(this._dataConnect, {required  this.negocioId,required  this.nombre,required  this.formatoEntrega,required  this.zonaHoraria,required  this.monedaIso,required  this.minutosGraciaSla,});
  Deserializer<ActualizarNegocioData> dataDeserializer = (dynamic json)  => ActualizarNegocioData.fromJson(jsonDecode(json));
  Serializer<ActualizarNegocioVariables> varsSerializer = (ActualizarNegocioVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<ActualizarNegocioData, ActualizarNegocioVariables>> execute() {
    return ref().execute();
  }

  MutationRef<ActualizarNegocioData, ActualizarNegocioVariables> ref() {
    ActualizarNegocioVariables vars= ActualizarNegocioVariables(negocioId: negocioId,nombre: nombre,direccion: _direccion,horaApertura: _horaApertura,horaCierre: _horaCierre,formatoEntrega: formatoEntrega,numeroWhatsapp: _numeroWhatsapp,zonaHoraria: zonaHoraria,monedaIso: monedaIso,minutosGraciaSla: minutosGraciaSla,logoUrl: _logoUrl,);
    return _dataConnect.mutation("ActualizarNegocio", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ActualizarNegocioNegocioUpdate {
  final String id;
  ActualizarNegocioNegocioUpdate.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarNegocioNegocioUpdate otherTyped = other as ActualizarNegocioNegocioUpdate;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  ActualizarNegocioNegocioUpdate({
    required this.id,
  });
}

@immutable
class ActualizarNegocioData {
  final ActualizarNegocioNegocioUpdate? negocio_update;
  ActualizarNegocioData.fromJson(dynamic json):
  
  negocio_update = json['negocio_update'] == null ? null : ActualizarNegocioNegocioUpdate.fromJson(json['negocio_update']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarNegocioData otherTyped = other as ActualizarNegocioData;
    return negocio_update == otherTyped.negocio_update;
    
  }
  @override
  int get hashCode => negocio_update.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (negocio_update != null) {
      json['negocio_update'] = negocio_update!.toJson();
    }
    return json;
  }

  ActualizarNegocioData({
    this.negocio_update,
  });
}

@immutable
class ActualizarNegocioVariables {
  final String negocioId;
  final String nombre;
  late final Optional<String>direccion;
  late final Optional<String>horaApertura;
  late final Optional<String>horaCierre;
  final FormatoEntrega formatoEntrega;
  late final Optional<String>numeroWhatsapp;
  final String zonaHoraria;
  final String monedaIso;
  final int minutosGraciaSla;
  late final Optional<String>logoUrl;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ActualizarNegocioVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']),
  nombre = nativeFromJson<String>(json['nombre']),
  formatoEntrega = FormatoEntrega.values.byName(json['formatoEntrega']),
  zonaHoraria = nativeFromJson<String>(json['zonaHoraria']),
  monedaIso = nativeFromJson<String>(json['monedaIso']),
  minutosGraciaSla = nativeFromJson<int>(json['minutosGraciaSla']) {
  
  
  
  
    direccion = Optional.optional(nativeFromJson, nativeToJson);
    direccion.value = json['direccion'] == null ? null : nativeFromJson<String>(json['direccion']);
  
  
    horaApertura = Optional.optional(nativeFromJson, nativeToJson);
    horaApertura.value = json['horaApertura'] == null ? null : nativeFromJson<String>(json['horaApertura']);
  
  
    horaCierre = Optional.optional(nativeFromJson, nativeToJson);
    horaCierre.value = json['horaCierre'] == null ? null : nativeFromJson<String>(json['horaCierre']);
  
  
  
    numeroWhatsapp = Optional.optional(nativeFromJson, nativeToJson);
    numeroWhatsapp.value = json['numeroWhatsapp'] == null ? null : nativeFromJson<String>(json['numeroWhatsapp']);
  
  
  
  
  
    logoUrl = Optional.optional(nativeFromJson, nativeToJson);
    logoUrl.value = json['logoUrl'] == null ? null : nativeFromJson<String>(json['logoUrl']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ActualizarNegocioVariables otherTyped = other as ActualizarNegocioVariables;
    return negocioId == otherTyped.negocioId && 
    nombre == otherTyped.nombre && 
    direccion == otherTyped.direccion && 
    horaApertura == otherTyped.horaApertura && 
    horaCierre == otherTyped.horaCierre && 
    formatoEntrega == otherTyped.formatoEntrega && 
    numeroWhatsapp == otherTyped.numeroWhatsapp && 
    zonaHoraria == otherTyped.zonaHoraria && 
    monedaIso == otherTyped.monedaIso && 
    minutosGraciaSla == otherTyped.minutosGraciaSla && 
    logoUrl == otherTyped.logoUrl;
    
  }
  @override
  int get hashCode => Object.hashAll([negocioId.hashCode, nombre.hashCode, direccion.hashCode, horaApertura.hashCode, horaCierre.hashCode, formatoEntrega.hashCode, numeroWhatsapp.hashCode, zonaHoraria.hashCode, monedaIso.hashCode, minutosGraciaSla.hashCode, logoUrl.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    json['nombre'] = nativeToJson<String>(nombre);
    if(direccion.state == OptionalState.set) {
      json['direccion'] = direccion.toJson();
    }
    if(horaApertura.state == OptionalState.set) {
      json['horaApertura'] = horaApertura.toJson();
    }
    if(horaCierre.state == OptionalState.set) {
      json['horaCierre'] = horaCierre.toJson();
    }
    json['formatoEntrega'] = 
    formatoEntrega.name
    ;
    if(numeroWhatsapp.state == OptionalState.set) {
      json['numeroWhatsapp'] = numeroWhatsapp.toJson();
    }
    json['zonaHoraria'] = nativeToJson<String>(zonaHoraria);
    json['monedaIso'] = nativeToJson<String>(monedaIso);
    json['minutosGraciaSla'] = nativeToJson<int>(minutosGraciaSla);
    if(logoUrl.state == OptionalState.set) {
      json['logoUrl'] = logoUrl.toJson();
    }
    return json;
  }

  ActualizarNegocioVariables({
    required this.negocioId,
    required this.nombre,
    required this.direccion,
    required this.horaApertura,
    required this.horaCierre,
    required this.formatoEntrega,
    required this.numeroWhatsapp,
    required this.zonaHoraria,
    required this.monedaIso,
    required this.minutosGraciaSla,
    required this.logoUrl,
  });
}

