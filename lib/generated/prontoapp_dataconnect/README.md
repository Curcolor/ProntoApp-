# prontoapp_dataconnect SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
ProntoappConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ObtenerDashboardNegocio
#### Required Arguments
```dart
String negocioId = ...;
Timestamp pedidosDesde = ...;
DateTime metricasDesde = ...;
DateTime metricasHasta = ...;
ProntoappConnector.instance.obtenerDashboardNegocio(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
  metricasDesde: metricasDesde,
  metricasHasta: metricasHasta,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerDashboardNegocioData, ObtenerDashboardNegocioVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ProntoappConnector.instance.obtenerDashboardNegocio(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
  metricasDesde: metricasDesde,
  metricasHasta: metricasHasta,
);
ObtenerDashboardNegocioData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
Timestamp pedidosDesde = ...;
DateTime metricasDesde = ...;
DateTime metricasHasta = ...;

final ref = ProntoappConnector.instance.obtenerDashboardNegocio(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
  metricasDesde: metricasDesde,
  metricasHasta: metricasHasta,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerPedidosKanban
#### Required Arguments
```dart
String negocioId = ...;
EstadoPedido estado = ...;
ProntoappConnector.instance.obtenerPedidosKanban(
  negocioId: negocioId,
  estado: estado,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerPedidosKanbanData, ObtenerPedidosKanbanVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ProntoappConnector.instance.obtenerPedidosKanban(
  negocioId: negocioId,
  estado: estado,
);
ObtenerPedidosKanbanData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
EstadoPedido estado = ...;

final ref = ProntoappConnector.instance.obtenerPedidosKanban(
  negocioId: negocioId,
  estado: estado,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerMenuInventario
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerMenuInventario(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerMenuInventarioData, ObtenerMenuInventarioVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ProntoappConnector.instance.obtenerMenuInventario(
  negocioId: negocioId,
);
ObtenerMenuInventarioData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerMenuInventario(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerPlantillasIa
#### Required Arguments
```dart
String negocioId = ...;
CasoUsoPlantilla casoUso = ...;
ProntoappConnector.instance.obtenerPlantillasIa(
  negocioId: negocioId,
  casoUso: casoUso,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerPlantillasIaData, ObtenerPlantillasIaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await ProntoappConnector.instance.obtenerPlantillasIa(
  negocioId: negocioId,
  casoUso: casoUso,
);
ObtenerPlantillasIaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
CasoUsoPlantilla casoUso = ...;

final ref = ProntoappConnector.instance.obtenerPlantillasIa(
  negocioId: negocioId,
  casoUso: casoUso,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CrearCliente
#### Required Arguments
```dart
String negocioId = ...;
String nombre = ...;
String numeroWhatsapp = ...;
ProntoappConnector.instance.crearCliente(
  negocioId: negocioId,
  nombre: nombre,
  numeroWhatsapp: numeroWhatsapp,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearCliente, we created `CrearClienteBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearClienteVariablesBuilder {
  ...
   CrearClienteVariablesBuilder email(String? t) {
   _email.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.crearCliente(
  negocioId: negocioId,
  nombre: nombre,
  numeroWhatsapp: numeroWhatsapp,
)
.email(email)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearClienteData, CrearClienteVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearCliente(
  negocioId: negocioId,
  nombre: nombre,
  numeroWhatsapp: numeroWhatsapp,
);
CrearClienteData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String nombre = ...;
String numeroWhatsapp = ...;

final ref = ProntoappConnector.instance.crearCliente(
  negocioId: negocioId,
  nombre: nombre,
  numeroWhatsapp: numeroWhatsapp,
).ref();
ref.execute();
```


### CrearPedidoManual
#### Required Arguments
```dart
String negocioId = ...;
String codigoPedido = ...;
double total = ...;
ProntoappConnector.instance.crearPedidoManual(
  negocioId: negocioId,
  codigoPedido: codigoPedido,
  total: total,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearPedidoManual, we created `CrearPedidoManualBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearPedidoManualVariablesBuilder {
  ...
   CrearPedidoManualVariablesBuilder clienteId(String? t) {
   _clienteId.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder clienteNombreSnapshot(String? t) {
   _clienteNombreSnapshot.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder clienteWhatsappSnapshot(String? t) {
   _clienteWhatsappSnapshot.value = t;
   return this;
  }
  CrearPedidoManualVariablesBuilder notas(String? t) {
   _notas.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.crearPedidoManual(
  negocioId: negocioId,
  codigoPedido: codigoPedido,
  total: total,
)
.clienteId(clienteId)
.clienteNombreSnapshot(clienteNombreSnapshot)
.clienteWhatsappSnapshot(clienteWhatsappSnapshot)
.notas(notas)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearPedidoManualData, CrearPedidoManualVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearPedidoManual(
  negocioId: negocioId,
  codigoPedido: codigoPedido,
  total: total,
);
CrearPedidoManualData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String codigoPedido = ...;
double total = ...;

final ref = ProntoappConnector.instance.crearPedidoManual(
  negocioId: negocioId,
  codigoPedido: codigoPedido,
  total: total,
).ref();
ref.execute();
```


### AgregarDetallePedido
#### Required Arguments
```dart
String negocioId = ...;
String pedidoId = ...;
String productoNombreSnapshot = ...;
int cantidad = ...;
double precioUnitario = ...;
double descuento = ...;
double subtotal = ...;
ProntoappConnector.instance.agregarDetallePedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  productoNombreSnapshot: productoNombreSnapshot,
  cantidad: cantidad,
  precioUnitario: precioUnitario,
  descuento: descuento,
  subtotal: subtotal,
).execute();
```

#### Optional Arguments
We return a builder for each query. For AgregarDetallePedido, we created `AgregarDetallePedidoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class AgregarDetallePedidoVariablesBuilder {
  ...
   AgregarDetallePedidoVariablesBuilder productoId(String? t) {
   _productoId.value = t;
   return this;
  }
  AgregarDetallePedidoVariablesBuilder productoCodigoSnapshot(String? t) {
   _productoCodigoSnapshot.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.agregarDetallePedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  productoNombreSnapshot: productoNombreSnapshot,
  cantidad: cantidad,
  precioUnitario: precioUnitario,
  descuento: descuento,
  subtotal: subtotal,
)
.productoId(productoId)
.productoCodigoSnapshot(productoCodigoSnapshot)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<AgregarDetallePedidoData, AgregarDetallePedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.agregarDetallePedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  productoNombreSnapshot: productoNombreSnapshot,
  cantidad: cantidad,
  precioUnitario: precioUnitario,
  descuento: descuento,
  subtotal: subtotal,
);
AgregarDetallePedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String pedidoId = ...;
String productoNombreSnapshot = ...;
int cantidad = ...;
double precioUnitario = ...;
double descuento = ...;
double subtotal = ...;

final ref = ProntoappConnector.instance.agregarDetallePedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  productoNombreSnapshot: productoNombreSnapshot,
  cantidad: cantidad,
  precioUnitario: precioUnitario,
  descuento: descuento,
  subtotal: subtotal,
).ref();
ref.execute();
```


### CambiarEstadoPedido
#### Required Arguments
```dart
String negocioId = ...;
String pedidoId = ...;
EstadoPedido estadoNuevo = ...;
ProntoappConnector.instance.cambiarEstadoPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  estadoNuevo: estadoNuevo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CambiarEstadoPedido, we created `CambiarEstadoPedidoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CambiarEstadoPedidoVariablesBuilder {
  ...
   CambiarEstadoPedidoVariablesBuilder estadoAnterior(EstadoPedido? t) {
   _estadoAnterior.value = t;
   return this;
  }
  CambiarEstadoPedidoVariablesBuilder usuarioCambioId(String? t) {
   _usuarioCambioId.value = t;
   return this;
  }
  CambiarEstadoPedidoVariablesBuilder motivo(String? t) {
   _motivo.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.cambiarEstadoPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  estadoNuevo: estadoNuevo,
)
.estadoAnterior(estadoAnterior)
.usuarioCambioId(usuarioCambioId)
.motivo(motivo)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CambiarEstadoPedidoData, CambiarEstadoPedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.cambiarEstadoPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  estadoNuevo: estadoNuevo,
);
CambiarEstadoPedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String pedidoId = ...;
EstadoPedido estadoNuevo = ...;

final ref = ProntoappConnector.instance.cambiarEstadoPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  estadoNuevo: estadoNuevo,
).ref();
ref.execute();
```


### AsignarPedido
#### Required Arguments
```dart
String negocioId = ...;
String pedidoId = ...;
String usuarioAsignadoId = ...;
ProntoappConnector.instance.asignarPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  usuarioAsignadoId: usuarioAsignadoId,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<AsignarPedidoData, AsignarPedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.asignarPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  usuarioAsignadoId: usuarioAsignadoId,
);
AsignarPedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String pedidoId = ...;
String usuarioAsignadoId = ...;

final ref = ProntoappConnector.instance.asignarPedido(
  negocioId: negocioId,
  pedidoId: pedidoId,
  usuarioAsignadoId: usuarioAsignadoId,
).ref();
ref.execute();
```


### GuardarProducto
#### Required Arguments
```dart
String id = ...;
String negocioId = ...;
String nombre = ...;
String codigo = ...;
double precio = ...;
int stock = ...;
double descuento = ...;
bool disponible = ...;
ProntoappConnector.instance.guardarProducto(
  id: id,
  negocioId: negocioId,
  nombre: nombre,
  codigo: codigo,
  precio: precio,
  stock: stock,
  descuento: descuento,
  disponible: disponible,
).execute();
```

#### Optional Arguments
We return a builder for each query. For GuardarProducto, we created `GuardarProductoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class GuardarProductoVariablesBuilder {
  ...
   GuardarProductoVariablesBuilder categoriaId(String? t) {
   _categoriaId.value = t;
   return this;
  }
  GuardarProductoVariablesBuilder descripcion(String? t) {
   _descripcion.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.guardarProducto(
  id: id,
  negocioId: negocioId,
  nombre: nombre,
  codigo: codigo,
  precio: precio,
  stock: stock,
  descuento: descuento,
  disponible: disponible,
)
.categoriaId(categoriaId)
.descripcion(descripcion)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<GuardarProductoData, GuardarProductoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.guardarProducto(
  id: id,
  negocioId: negocioId,
  nombre: nombre,
  codigo: codigo,
  precio: precio,
  stock: stock,
  descuento: descuento,
  disponible: disponible,
);
GuardarProductoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String id = ...;
String negocioId = ...;
String nombre = ...;
String codigo = ...;
double precio = ...;
int stock = ...;
double descuento = ...;
bool disponible = ...;

final ref = ProntoappConnector.instance.guardarProducto(
  id: id,
  negocioId: negocioId,
  nombre: nombre,
  codigo: codigo,
  precio: precio,
  stock: stock,
  descuento: descuento,
  disponible: disponible,
).ref();
ref.execute();
```

