# Basic Usage

```dart
ProntoappConnector.instance.CrearCliente(crearClienteVariables).execute();
ProntoappConnector.instance.CrearPedidoManual(crearPedidoManualVariables).execute();
ProntoappConnector.instance.AgregarDetallePedido(agregarDetallePedidoVariables).execute();
ProntoappConnector.instance.CambiarEstadoPedido(cambiarEstadoPedidoVariables).execute();
ProntoappConnector.instance.AsignarPedido(asignarPedidoVariables).execute();
ProntoappConnector.instance.GuardarProducto(guardarProductoVariables).execute();
ProntoappConnector.instance.ObtenerDashboardNegocio(obtenerDashboardNegocioVariables).execute();
ProntoappConnector.instance.ObtenerPedidosKanban(obtenerPedidosKanbanVariables).execute();
ProntoappConnector.instance.ObtenerMenuInventario(obtenerMenuInventarioVariables).execute();
ProntoappConnector.instance.ObtenerPlantillasIa(obtenerPlantillasIaVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ProntoappConnector.instance.GuardarProducto({ ... })
.categoriaId(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

