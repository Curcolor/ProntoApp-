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

