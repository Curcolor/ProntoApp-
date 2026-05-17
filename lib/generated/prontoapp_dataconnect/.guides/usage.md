# Basic Usage

```dart
ProntoappConnector.instance.CrearCliente(crearClienteVariables).execute();
ProntoappConnector.instance.ActualizarNegocio(actualizarNegocioVariables).execute();
ProntoappConnector.instance.CrearCategoria(crearCategoriaVariables).execute();
ProntoappConnector.instance.ActualizarCategoria(actualizarCategoriaVariables).execute();
ProntoappConnector.instance.DesactivarCategoria(desactivarCategoriaVariables).execute();
ProntoappConnector.instance.CrearIntegracionMensajeria(crearIntegracionMensajeriaVariables).execute();
ProntoappConnector.instance.ActualizarIntegracionMensajeria(actualizarIntegracionMensajeriaVariables).execute();
ProntoappConnector.instance.DesactivarIntegracionMensajeria(desactivarIntegracionMensajeriaVariables).execute();
ProntoappConnector.instance.CrearPasoFlujoPedido(crearPasoFlujoPedidoVariables).execute();
ProntoappConnector.instance.ActualizarPasoFlujoPedido(actualizarPasoFlujoPedidoVariables).execute();

```

## Optional Fields

Some operations may have optional fields. In these cases, the Flutter SDK exposes a builder method, and will have to be set separately.

Optional fields can be discovered based on classes that have `Optional` object types.

This is an example of a mutation with an optional field:

```dart
await ProntoappConnector.instance.ActualizarPlantillaIa({ ... })
.promptUsuarioTemplate(...)
.execute();
```

Note: the above example is a mutation, but the same logic applies to query operations as well. Additionally, `createMovie` is an example, and may not be available to the user.

