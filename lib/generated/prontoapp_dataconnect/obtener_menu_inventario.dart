part of 'prontoapp.dart';

class ObtenerMenuInventarioVariablesBuilder {
  String negocioId;

  final FirebaseDataConnect _dataConnect;
  ObtenerMenuInventarioVariablesBuilder(this._dataConnect, {required  this.negocioId,});
  Deserializer<ObtenerMenuInventarioData> dataDeserializer = (dynamic json)  => ObtenerMenuInventarioData.fromJson(jsonDecode(json));
  Serializer<ObtenerMenuInventarioVariables> varsSerializer = (ObtenerMenuInventarioVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<ObtenerMenuInventarioData, ObtenerMenuInventarioVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ObtenerMenuInventarioData, ObtenerMenuInventarioVariables> ref() {
    ObtenerMenuInventarioVariables vars= ObtenerMenuInventarioVariables(negocioId: negocioId,);
    return _dataConnect.query("ObtenerMenuInventario", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class ObtenerMenuInventarioCategorias {
  final String id;
  final String nombre;
  final String? emoji;
  final int orden;
  ObtenerMenuInventarioCategorias.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  nombre = nativeFromJson<String>(json['nombre']),
  emoji = json['emoji'] == null ? null : nativeFromJson<String>(json['emoji']),
  orden = nativeFromJson<int>(json['orden']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMenuInventarioCategorias otherTyped = other as ObtenerMenuInventarioCategorias;
    return id == otherTyped.id && 
    nombre == otherTyped.nombre && 
    emoji == otherTyped.emoji && 
    orden == otherTyped.orden;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, nombre.hashCode, emoji.hashCode, orden.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['nombre'] = nativeToJson<String>(nombre);
    if (emoji != null) {
      json['emoji'] = nativeToJson<String?>(emoji);
    }
    json['orden'] = nativeToJson<int>(orden);
    return json;
  }

  ObtenerMenuInventarioCategorias({
    required this.id,
    required this.nombre,
    this.emoji,
    required this.orden,
  });
}

@immutable
class ObtenerMenuInventarioProductos {
  final String id;
  final String? categoriaId;
  final String nombre;
  final String? descripcion;
  final String codigo;
  final double precio;
  final int stock;
  final double descuento;
  final String? urlImagen;
  ObtenerMenuInventarioProductos.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  categoriaId = json['categoriaId'] == null ? null : nativeFromJson<String>(json['categoriaId']),
  nombre = nativeFromJson<String>(json['nombre']),
  descripcion = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']),
  codigo = nativeFromJson<String>(json['codigo']),
  precio = nativeFromJson<double>(json['precio']),
  stock = nativeFromJson<int>(json['stock']),
  descuento = nativeFromJson<double>(json['descuento']),
  urlImagen = json['urlImagen'] == null ? null : nativeFromJson<String>(json['urlImagen']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMenuInventarioProductos otherTyped = other as ObtenerMenuInventarioProductos;
    return id == otherTyped.id && 
    categoriaId == otherTyped.categoriaId && 
    nombre == otherTyped.nombre && 
    descripcion == otherTyped.descripcion && 
    codigo == otherTyped.codigo && 
    precio == otherTyped.precio && 
    stock == otherTyped.stock && 
    descuento == otherTyped.descuento && 
    urlImagen == otherTyped.urlImagen;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, categoriaId.hashCode, nombre.hashCode, descripcion.hashCode, codigo.hashCode, precio.hashCode, stock.hashCode, descuento.hashCode, urlImagen.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    if (categoriaId != null) {
      json['categoriaId'] = nativeToJson<String?>(categoriaId);
    }
    json['nombre'] = nativeToJson<String>(nombre);
    if (descripcion != null) {
      json['descripcion'] = nativeToJson<String?>(descripcion);
    }
    json['codigo'] = nativeToJson<String>(codigo);
    json['precio'] = nativeToJson<double>(precio);
    json['stock'] = nativeToJson<int>(stock);
    json['descuento'] = nativeToJson<double>(descuento);
    if (urlImagen != null) {
      json['urlImagen'] = nativeToJson<String?>(urlImagen);
    }
    return json;
  }

  ObtenerMenuInventarioProductos({
    required this.id,
    this.categoriaId,
    required this.nombre,
    this.descripcion,
    required this.codigo,
    required this.precio,
    required this.stock,
    required this.descuento,
    this.urlImagen,
  });
}

@immutable
class ObtenerMenuInventarioData {
  final List<ObtenerMenuInventarioCategorias> categorias;
  final List<ObtenerMenuInventarioProductos> productos;
  ObtenerMenuInventarioData.fromJson(dynamic json):
  
  categorias = (json['categorias'] as List<dynamic>)
        .map((e) => ObtenerMenuInventarioCategorias.fromJson(e))
        .toList(),
  productos = (json['productos'] as List<dynamic>)
        .map((e) => ObtenerMenuInventarioProductos.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMenuInventarioData otherTyped = other as ObtenerMenuInventarioData;
    return categorias == otherTyped.categorias && 
    productos == otherTyped.productos;
    
  }
  @override
  int get hashCode => Object.hashAll([categorias.hashCode, productos.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['categorias'] = categorias.map((e) => e.toJson()).toList();
    json['productos'] = productos.map((e) => e.toJson()).toList();
    return json;
  }

  ObtenerMenuInventarioData({
    required this.categorias,
    required this.productos,
  });
}

@immutable
class ObtenerMenuInventarioVariables {
  final String negocioId;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  ObtenerMenuInventarioVariables.fromJson(Map<String, dynamic> json):
  
  negocioId = nativeFromJson<String>(json['negocioId']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ObtenerMenuInventarioVariables otherTyped = other as ObtenerMenuInventarioVariables;
    return negocioId == otherTyped.negocioId;
    
  }
  @override
  int get hashCode => negocioId.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['negocioId'] = nativeToJson<String>(negocioId);
    return json;
  }

  ObtenerMenuInventarioVariables({
    required this.negocioId,
  });
}

