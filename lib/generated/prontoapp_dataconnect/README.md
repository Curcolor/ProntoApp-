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

### ObtenerDashboardNegocioV2
#### Required Arguments
```dart
String negocioId = ...;
Timestamp pedidosDesde = ...;
ProntoappConnector.instance.obtenerDashboardNegocioV2(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerDashboardNegocioV2Data, ObtenerDashboardNegocioV2Variables>`
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

final result = await ProntoappConnector.instance.obtenerDashboardNegocioV2(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
);
ObtenerDashboardNegocioV2Data data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
Timestamp pedidosDesde = ...;

final ref = ProntoappConnector.instance.obtenerDashboardNegocioV2(
  negocioId: negocioId,
  pedidosDesde: pedidosDesde,
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


### ObtenerIntegracionesMensajeria
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerIntegracionesMensajeria(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerIntegracionesMensajeriaData, ObtenerIntegracionesMensajeriaVariables>`
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

final result = await ProntoappConnector.instance.obtenerIntegracionesMensajeria(
  negocioId: negocioId,
);
ObtenerIntegracionesMensajeriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerIntegracionesMensajeria(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerMiPerfilUsuarioAdmin
#### Required Arguments
```dart
// No required arguments
ProntoappConnector.instance.obtenerMiPerfilUsuarioAdmin().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerMiPerfilUsuarioAdminData, void>`
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

final result = await ProntoappConnector.instance.obtenerMiPerfilUsuarioAdmin();
ObtenerMiPerfilUsuarioAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = ProntoappConnector.instance.obtenerMiPerfilUsuarioAdmin().ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerNegocio
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerNegocio(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerNegocioData, ObtenerNegocioVariables>`
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

final result = await ProntoappConnector.instance.obtenerNegocio(
  negocioId: negocioId,
);
ObtenerNegocioData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerNegocio(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerCategoriasAdmin
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerCategoriasAdmin(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerCategoriasAdminData, ObtenerCategoriasAdminVariables>`
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

final result = await ProntoappConnector.instance.obtenerCategoriasAdmin(
  negocioId: negocioId,
);
ObtenerCategoriasAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerCategoriasAdmin(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerPasosFlujoPedidoAdmin
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerPasosFlujoPedidoAdmin(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerPasosFlujoPedidoAdminData, ObtenerPasosFlujoPedidoAdminVariables>`
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

final result = await ProntoappConnector.instance.obtenerPasosFlujoPedidoAdmin(
  negocioId: negocioId,
);
ObtenerPasosFlujoPedidoAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerPasosFlujoPedidoAdmin(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerPlantillasIaAdmin
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerPlantillasIaAdmin(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerPlantillasIaAdminData, ObtenerPlantillasIaAdminVariables>`
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

final result = await ProntoappConnector.instance.obtenerPlantillasIaAdmin(
  negocioId: negocioId,
);
ObtenerPlantillasIaAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerPlantillasIaAdmin(
  negocioId: negocioId,
).ref();
ref.execute();

ref.subscribe(...);
```


### ObtenerIntegracionesMensajeriaAdmin
#### Required Arguments
```dart
String negocioId = ...;
ProntoappConnector.instance.obtenerIntegracionesMensajeriaAdmin(
  negocioId: negocioId,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<ObtenerIntegracionesMensajeriaAdminData, ObtenerIntegracionesMensajeriaAdminVariables>`
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

final result = await ProntoappConnector.instance.obtenerIntegracionesMensajeriaAdmin(
  negocioId: negocioId,
);
ObtenerIntegracionesMensajeriaAdminData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;

final ref = ProntoappConnector.instance.obtenerIntegracionesMensajeriaAdmin(
  negocioId: negocioId,
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
  CrearClienteVariablesBuilder notas(String? t) {
   _notas.value = t;
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
.notas(notas)
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


### ActualizarNegocio
#### Required Arguments
```dart
String negocioId = ...;
String nombre = ...;
FormatoEntrega formatoEntrega = ...;
String zonaHoraria = ...;
String monedaIso = ...;
int minutosGraciaSla = ...;
ProntoappConnector.instance.actualizarNegocio(
  negocioId: negocioId,
  nombre: nombre,
  formatoEntrega: formatoEntrega,
  zonaHoraria: zonaHoraria,
  monedaIso: monedaIso,
  minutosGraciaSla: minutosGraciaSla,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ActualizarNegocio, we created `ActualizarNegocioBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ActualizarNegocioVariablesBuilder {
  ...
   ActualizarNegocioVariablesBuilder direccion(String? t) {
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

  ...
}
ProntoappConnector.instance.actualizarNegocio(
  negocioId: negocioId,
  nombre: nombre,
  formatoEntrega: formatoEntrega,
  zonaHoraria: zonaHoraria,
  monedaIso: monedaIso,
  minutosGraciaSla: minutosGraciaSla,
)
.direccion(direccion)
.horaApertura(horaApertura)
.horaCierre(horaCierre)
.numeroWhatsapp(numeroWhatsapp)
.logoUrl(logoUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ActualizarNegocioData, ActualizarNegocioVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.actualizarNegocio(
  negocioId: negocioId,
  nombre: nombre,
  formatoEntrega: formatoEntrega,
  zonaHoraria: zonaHoraria,
  monedaIso: monedaIso,
  minutosGraciaSla: minutosGraciaSla,
);
ActualizarNegocioData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String nombre = ...;
FormatoEntrega formatoEntrega = ...;
String zonaHoraria = ...;
String monedaIso = ...;
int minutosGraciaSla = ...;

final ref = ProntoappConnector.instance.actualizarNegocio(
  negocioId: negocioId,
  nombre: nombre,
  formatoEntrega: formatoEntrega,
  zonaHoraria: zonaHoraria,
  monedaIso: monedaIso,
  minutosGraciaSla: minutosGraciaSla,
).ref();
ref.execute();
```


### CrearCategoria
#### Required Arguments
```dart
String negocioId = ...;
String nombre = ...;
int orden = ...;
ProntoappConnector.instance.crearCategoria(
  negocioId: negocioId,
  nombre: nombre,
  orden: orden,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearCategoria, we created `CrearCategoriaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearCategoriaVariablesBuilder {
  ...
   CrearCategoriaVariablesBuilder emoji(String? t) {
   _emoji.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.crearCategoria(
  negocioId: negocioId,
  nombre: nombre,
  orden: orden,
)
.emoji(emoji)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearCategoriaData, CrearCategoriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearCategoria(
  negocioId: negocioId,
  nombre: nombre,
  orden: orden,
);
CrearCategoriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String nombre = ...;
int orden = ...;

final ref = ProntoappConnector.instance.crearCategoria(
  negocioId: negocioId,
  nombre: nombre,
  orden: orden,
).ref();
ref.execute();
```


### ActualizarCategoria
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
String nombre = ...;
int orden = ...;
ProntoappConnector.instance.actualizarCategoria(
  negocioId: negocioId,
  id: id,
  nombre: nombre,
  orden: orden,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ActualizarCategoria, we created `ActualizarCategoriaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ActualizarCategoriaVariablesBuilder {
  ...
   ActualizarCategoriaVariablesBuilder emoji(String? t) {
   _emoji.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.actualizarCategoria(
  negocioId: negocioId,
  id: id,
  nombre: nombre,
  orden: orden,
)
.emoji(emoji)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ActualizarCategoriaData, ActualizarCategoriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.actualizarCategoria(
  negocioId: negocioId,
  id: id,
  nombre: nombre,
  orden: orden,
);
ActualizarCategoriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;
String nombre = ...;
int orden = ...;

final ref = ProntoappConnector.instance.actualizarCategoria(
  negocioId: negocioId,
  id: id,
  nombre: nombre,
  orden: orden,
).ref();
ref.execute();
```


### DesactivarCategoria
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
ProntoappConnector.instance.desactivarCategoria(
  negocioId: negocioId,
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DesactivarCategoriaData, DesactivarCategoriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.desactivarCategoria(
  negocioId: negocioId,
  id: id,
);
DesactivarCategoriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;

final ref = ProntoappConnector.instance.desactivarCategoria(
  negocioId: negocioId,
  id: id,
).ref();
ref.execute();
```


### CrearIntegracionMensajeria
#### Required Arguments
```dart
String negocioId = ...;
CanalMensajeria canal = ...;
String identificadorExterno = ...;
String credencialSecretRef = ...;
ProntoappConnector.instance.crearIntegracionMensajeria(
  negocioId: negocioId,
  canal: canal,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearIntegracionMensajeria, we created `CrearIntegracionMensajeriaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearIntegracionMensajeriaVariablesBuilder {
  ...
   CrearIntegracionMensajeriaVariablesBuilder nombreVisible(String? t) {
   _nombreVisible.value = t;
   return this;
  }
  CrearIntegracionMensajeriaVariablesBuilder webhookSecret(String? t) {
   _webhookSecret.value = t;
   return this;
  }
  CrearIntegracionMensajeriaVariablesBuilder webhookUrl(String? t) {
   _webhookUrl.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.crearIntegracionMensajeria(
  negocioId: negocioId,
  canal: canal,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
)
.nombreVisible(nombreVisible)
.webhookSecret(webhookSecret)
.webhookUrl(webhookUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearIntegracionMensajeriaData, CrearIntegracionMensajeriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearIntegracionMensajeria(
  negocioId: negocioId,
  canal: canal,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
);
CrearIntegracionMensajeriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
CanalMensajeria canal = ...;
String identificadorExterno = ...;
String credencialSecretRef = ...;

final ref = ProntoappConnector.instance.crearIntegracionMensajeria(
  negocioId: negocioId,
  canal: canal,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
).ref();
ref.execute();
```


### ActualizarIntegracionMensajeria
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
String identificadorExterno = ...;
String credencialSecretRef = ...;
bool activo = ...;
ProntoappConnector.instance.actualizarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
  activo: activo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ActualizarIntegracionMensajeria, we created `ActualizarIntegracionMensajeriaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ActualizarIntegracionMensajeriaVariablesBuilder {
  ...
   ActualizarIntegracionMensajeriaVariablesBuilder nombreVisible(String? t) {
   _nombreVisible.value = t;
   return this;
  }
  ActualizarIntegracionMensajeriaVariablesBuilder webhookSecret(String? t) {
   _webhookSecret.value = t;
   return this;
  }
  ActualizarIntegracionMensajeriaVariablesBuilder webhookUrl(String? t) {
   _webhookUrl.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.actualizarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
  activo: activo,
)
.nombreVisible(nombreVisible)
.webhookSecret(webhookSecret)
.webhookUrl(webhookUrl)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ActualizarIntegracionMensajeriaData, ActualizarIntegracionMensajeriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.actualizarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
  activo: activo,
);
ActualizarIntegracionMensajeriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;
String identificadorExterno = ...;
String credencialSecretRef = ...;
bool activo = ...;

final ref = ProntoappConnector.instance.actualizarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
  identificadorExterno: identificadorExterno,
  credencialSecretRef: credencialSecretRef,
  activo: activo,
).ref();
ref.execute();
```


### DesactivarIntegracionMensajeria
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
ProntoappConnector.instance.desactivarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DesactivarIntegracionMensajeriaData, DesactivarIntegracionMensajeriaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.desactivarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
);
DesactivarIntegracionMensajeriaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;

final ref = ProntoappConnector.instance.desactivarIntegracionMensajeria(
  negocioId: negocioId,
  id: id,
).ref();
ref.execute();
```


### CrearPasoFlujoPedido
#### Required Arguments
```dart
String negocioId = ...;
EstadoPedido estado = ...;
String etiqueta = ...;
int orden = ...;
DisparadorFlujo disparador = ...;
ProntoappConnector.instance.crearPasoFlujoPedido(
  negocioId: negocioId,
  estado: estado,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearPasoFlujoPedido, we created `CrearPasoFlujoPedidoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearPasoFlujoPedidoVariablesBuilder {
  ...
   CrearPasoFlujoPedidoVariablesBuilder minutosSla(int? t) {
   _minutosSla.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.crearPasoFlujoPedido(
  negocioId: negocioId,
  estado: estado,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
)
.minutosSla(minutosSla)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearPasoFlujoPedidoData, CrearPasoFlujoPedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearPasoFlujoPedido(
  negocioId: negocioId,
  estado: estado,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
);
CrearPasoFlujoPedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
EstadoPedido estado = ...;
String etiqueta = ...;
int orden = ...;
DisparadorFlujo disparador = ...;

final ref = ProntoappConnector.instance.crearPasoFlujoPedido(
  negocioId: negocioId,
  estado: estado,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
).ref();
ref.execute();
```


### ActualizarPasoFlujoPedido
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
String etiqueta = ...;
int orden = ...;
DisparadorFlujo disparador = ...;
bool activo = ...;
ProntoappConnector.instance.actualizarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
  activo: activo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ActualizarPasoFlujoPedido, we created `ActualizarPasoFlujoPedidoBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ActualizarPasoFlujoPedidoVariablesBuilder {
  ...
   ActualizarPasoFlujoPedidoVariablesBuilder minutosSla(int? t) {
   _minutosSla.value = t;
   return this;
  }

  ...
}
ProntoappConnector.instance.actualizarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
  activo: activo,
)
.minutosSla(minutosSla)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ActualizarPasoFlujoPedidoData, ActualizarPasoFlujoPedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.actualizarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
  activo: activo,
);
ActualizarPasoFlujoPedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;
String etiqueta = ...;
int orden = ...;
DisparadorFlujo disparador = ...;
bool activo = ...;

final ref = ProntoappConnector.instance.actualizarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
  etiqueta: etiqueta,
  orden: orden,
  disparador: disparador,
  activo: activo,
).ref();
ref.execute();
```


### DesactivarPasoFlujoPedido
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
ProntoappConnector.instance.desactivarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DesactivarPasoFlujoPedidoData, DesactivarPasoFlujoPedidoVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.desactivarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
);
DesactivarPasoFlujoPedidoData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;

final ref = ProntoappConnector.instance.desactivarPasoFlujoPedido(
  negocioId: negocioId,
  id: id,
).ref();
ref.execute();
```


### CrearPlantillaIa
#### Required Arguments
```dart
String negocioId = ...;
String codigo = ...;
CasoUsoPlantilla casoUso = ...;
int version = ...;
ProveedorLlm proveedor = ...;
String modelo = ...;
String promptSistema = ...;
String idioma = ...;
ProntoappConnector.instance.crearPlantillaIa(
  negocioId: negocioId,
  codigo: codigo,
  casoUso: casoUso,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CrearPlantillaIa, we created `CrearPlantillaIaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CrearPlantillaIaVariablesBuilder {
  ...
   CrearPlantillaIaVariablesBuilder promptUsuarioTemplate(String? t) {
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

  ...
}
ProntoappConnector.instance.crearPlantillaIa(
  negocioId: negocioId,
  codigo: codigo,
  casoUso: casoUso,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
)
.promptUsuarioTemplate(promptUsuarioTemplate)
.herramientasHabilitadas(herramientasHabilitadas)
.temperatura(temperatura)
.topP(topP)
.maxTokens(maxTokens)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CrearPlantillaIaData, CrearPlantillaIaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.crearPlantillaIa(
  negocioId: negocioId,
  codigo: codigo,
  casoUso: casoUso,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
);
CrearPlantillaIaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String codigo = ...;
CasoUsoPlantilla casoUso = ...;
int version = ...;
ProveedorLlm proveedor = ...;
String modelo = ...;
String promptSistema = ...;
String idioma = ...;

final ref = ProntoappConnector.instance.crearPlantillaIa(
  negocioId: negocioId,
  codigo: codigo,
  casoUso: casoUso,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
).ref();
ref.execute();
```


### ActualizarPlantillaIa
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
String codigo = ...;
int version = ...;
ProveedorLlm proveedor = ...;
String modelo = ...;
String promptSistema = ...;
String idioma = ...;
bool activo = ...;
ProntoappConnector.instance.actualizarPlantillaIa(
  negocioId: negocioId,
  id: id,
  codigo: codigo,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
  activo: activo,
).execute();
```

#### Optional Arguments
We return a builder for each query. For ActualizarPlantillaIa, we created `ActualizarPlantillaIaBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class ActualizarPlantillaIaVariablesBuilder {
  ...
   ActualizarPlantillaIaVariablesBuilder promptUsuarioTemplate(String? t) {
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

  ...
}
ProntoappConnector.instance.actualizarPlantillaIa(
  negocioId: negocioId,
  id: id,
  codigo: codigo,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
  activo: activo,
)
.promptUsuarioTemplate(promptUsuarioTemplate)
.herramientasHabilitadas(herramientasHabilitadas)
.temperatura(temperatura)
.topP(topP)
.maxTokens(maxTokens)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<ActualizarPlantillaIaData, ActualizarPlantillaIaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.actualizarPlantillaIa(
  negocioId: negocioId,
  id: id,
  codigo: codigo,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
  activo: activo,
);
ActualizarPlantillaIaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;
String codigo = ...;
int version = ...;
ProveedorLlm proveedor = ...;
String modelo = ...;
String promptSistema = ...;
String idioma = ...;
bool activo = ...;

final ref = ProntoappConnector.instance.actualizarPlantillaIa(
  negocioId: negocioId,
  id: id,
  codigo: codigo,
  version: version,
  proveedor: proveedor,
  modelo: modelo,
  promptSistema: promptSistema,
  idioma: idioma,
  activo: activo,
).ref();
ref.execute();
```


### DesactivarPlantillaIa
#### Required Arguments
```dart
String negocioId = ...;
String id = ...;
ProntoappConnector.instance.desactivarPlantillaIa(
  negocioId: negocioId,
  id: id,
).execute();
```



#### Return Type
`execute()` returns a `OperationResult<DesactivarPlantillaIaData, DesactivarPlantillaIaVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await ProntoappConnector.instance.desactivarPlantillaIa(
  negocioId: negocioId,
  id: id,
);
DesactivarPlantillaIaData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
String negocioId = ...;
String id = ...;

final ref = ProntoappConnector.instance.desactivarPlantillaIa(
  negocioId: negocioId,
  id: id,
).ref();
ref.execute();
```

