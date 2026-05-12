part of 'prontoapp.dart';

class GuardarProductoVariablesBuilder {
  String id;
  String negocioId;
  Optional<String> _categoriaId = Optional.optional(nativeFromJson, nativeToJson);
  String nombre;
  Optional<String> _descripcion = Optional.optional(nativeFromJson, nativeToJson);
  String codigo;
  double precio;
  int stock;
  double descuento;
  bool disponible;

  final FirebaseDataConnect _dataConnect;  GuardarProductoVariablesBuilder categoriaId(String? t) {
   _categoriaId.value = t;
   return this;
  }
  GuardarProductoVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  GuardarProductoVariablesBuilder(this._dataConnect, {required  this.id,required  this.negocioId,required  this.nombre,required  this.codigo,required  this.precio,required  this.stock,required  this.descuento,required  this.disponible,});
  Deserializer<GuardarProductoData> dataDeserializer = (dynamic json)  => GuardarProductoData.fromJson(jsonDecode(json));
  Serializer<GuardarProductoVariables> varsSerializer = (GuardarProductoVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<GuardarProductoData, GuardarProductoVariables>> execute() {
    return ref().execute();
  }

  MutationRef<GuardarProductoData, GuardarProductoVariables> ref() {
    GuardarProductoVariables vars= GuardarProductoVariables(id: id,negocioId: negocioId,categoriaId: _categoriaId,nombre: nombre,descripcion: _descripcion,codigo: codigo,precio: precio,stock: stock,descuento: descuento,disponible: disponible,);
    return _dataConnect.mutation("GuardarProducto", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GuardarProductoProductoUpsert {
  final String id;
  GuardarProductoProductoUpsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GuardarProductoProductoUpsert otherTyped = other as GuardarProductoProductoUpsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GuardarProductoProductoUpsert({
    required this.id,
  });
}

@immutable
class GuardarProductoData {
  final GuardarProductoProductoUpsert producto_upsert;
  GuardarProductoData.fromJson(dynamic json):
  
  producto_upsert = GuardarProductoProductoUpsert.fromJson(json['producto_upsert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GuardarProductoData otherTyped = other as GuardarProductoData;
    return producto_upsert == otherTyped.producto_upsert;
    
  }
  @override
  int get hashCode => producto_upsert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['producto_upsert'] = producto_upsert.toJson();
    return json;
  }

  GuardarProductoData({
    required this.producto_upsert,
  });
}

@immutable
class GuardarProductoVariables {
  final String id;
  final String negocioId;
  late final Optional<String>categoriaId;
  final String nombre;
  late final Optional<String>descripcion;
  final String codigo;
  final double precio;
  final int stock;
  final double descuento;
  final bool disponible;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GuardarProductoVariables.fromJson(Map<String, dynamic> json):
  
  id = nativeFromJson<String>(json['id']),
  negocioId = nativeFromJson<String>(json['negocioId']),
  nombre = nativeFromJson<String>(json['nombre']),
  codigo = nativeFromJson<String>(json['codigo']),
  precio = nativeFromJson<double>(json['precio']),
  stock = nativeFromJson<int>(json['stock']),
  descuento = nativeFromJson<double>(json['descuento']),
  disponible = nativeFromJson<bool>(json['disponible']) {
  
  
  
  
    categoriaId = Optional.optional(nativeFromJson, nativeToJson);
    categoriaId.value = json['categoriaId'] == null ? null : nativeFromJson<String>(json['categoriaId']);
  
  
  
    descripcion = Optional.optional(nativeFromJson, nativeToJson);
    descripcion.value = json['descripcion'] == null ? null : nativeFromJson<String>(json['descripcion']);
  
  
  
  
  
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GuardarProductoVariables otherTyped = other as GuardarProductoVariables;
    return id == otherTyped.id && 
    negocioId == otherTyped.negocioId && 
    categoriaId == otherTyped.categoriaId && 
    nombre == otherTyped.nombre && 
    descripcion == otherTyped.descripcion && 
    codigo == otherTyped.codigo && 
    precio == otherTyped.precio && 
    stock == otherTyped.stock && 
    descuento == otherTyped.descuento && 
    disponible == otherTyped.disponible;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, negocioId.hashCode, categoriaId.hashCode, nombre.hashCode, descripcion.hashCode, codigo.hashCode, precio.hashCode, stock.hashCode, descuento.hashCode, disponible.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['negocioId'] = nativeToJson<String>(negocioId);
    if(categoriaId.state == OptionalState.set) {
      json['categoriaId'] = categoriaId.toJson();
    }
    json['nombre'] = nativeToJson<String>(nombre);
    if(descripcion.state == OptionalState.set) {
      json['descripcion'] = descripcion.toJson();
    }
    json['codigo'] = nativeToJson<String>(codigo);
    json['precio'] = nativeToJson<double>(precio);
    json['stock'] = nativeToJson<int>(stock);
    json['descuento'] = nativeToJson<double>(descuento);
    json['disponible'] = nativeToJson<bool>(disponible);
    return json;
  }

  GuardarProductoVariables({
    required this.id,
    required this.negocioId,
    required this.categoriaId,
    required this.nombre,
    required this.descripcion,
    required this.codigo,
    required this.precio,
    required this.stock,
    required this.descuento,
    required this.disponible,
  });
}

