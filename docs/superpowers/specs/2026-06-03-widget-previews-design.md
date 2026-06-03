# Widget Previews para ProntoApp — Design Spec

**Fecha:** 2026-06-03
**Autor:** Curcolor (con Claude Code)
**Estado:** Aprobado para planificación

## Objetivo

Habilitar [Flutter Widget Previews](https://docs.flutter.dev/tools/widget-previewer)
(`@Preview`) en todas las vistas visibles de `lib/features/`: las 29 pantallas
en carpetas `screens/` más los modales/diálogos en carpetas `widgets/`
(hasta ~36 archivos; algunos modales con clases base abstractas pueden quedar
fuera, ver §5). Cada
vista expone **una** preview que renderiza de forma **offline y determinista**
(sin red, sin timers, sin servidor) y con el mismo tema visual que la app.

## Contexto verificado

- **Flutter:** 3.41.6 stable · Dart 3.11.4. API `package:flutter/widget_previews.dart`
  presente. `flutter widget-preview start` disponible.
- **Tema app** (`lib/main.dart`): `ColorScheme.fromSeed(seedColor: Color(0xFF25D366))`,
  `useMaterial3: true`, `GoogleFonts.interTextTheme(...)`.
- **Providers** (`MultiProvider` en main.dart): `AuthService`, `InventoryProvider`,
  `NotificationProvider`, `OrderProvider`.
- **Riesgo clave:** los constructores de `InventoryProvider` y `OrderProvider`
  arrancan `Timer.periodic` + fetch HTTP a `localhost:5050`. Construir los
  providers reales en una preview => polling de red continuo y timers fugados.
  Por eso NO se usan los constructores reales en previews (ver §2).

## Firmas de la API (verificadas en el SDK)

```dart
const Preview({String group = 'Default', String? name, Size? size,
  double? textScaleFactor, WidgetWrapper? wrapper, PreviewTheme? theme,
  Brightness? brightness, PreviewLocalizations? localizations});

typedef WidgetWrapper = Widget Function(Widget);        // recibe child, devuelve wrapped
typedef PreviewTheme  = PreviewThemeData Function();
class PreviewThemeData({ThemeData? materialLight, materialDark, ...});
```

`@Preview` se aplica a funciones top-level (o métodos estáticos / constructores)
que devuelven `Widget` o `WidgetBuilder`. `wrapper` y `theme` deben referenciar
funciones top-level o estáticas (no closures).

## Decisiones (acordadas)

| Tema | Decisión |
|---|---|
| Alcance | Screens completas **+** modales/diálogos (~34 archivos) |
| Declaración | Función `@Preview` top-level por archivo |
| Variantes | Una preview por vista |
| Datos mock | Sample data inline + wrapper compartido |
| Providers con polling | Approach A: constructores `.preview()` aditivos |

## Arquitectura

### 1. Nuevo módulo `lib/preview_support/`

Helpers usados solo por las anotaciones de preview. No se referencian desde el
código de runtime de la app.

- **`preview_theme.dart`**
  ```dart
  PreviewThemeData previewTheme() => PreviewThemeData(
        materialLight: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
        ),
      );
  ```

- **`preview_wrapper.dart`**
  ```dart
  Widget previewWrapper(Widget child) => MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>.value(value: AuthService.preview()),
          ChangeNotifierProvider<InventoryProvider>.value(value: InventoryProvider.preview()),
          ChangeNotifierProvider<NotificationProvider>.value(value: NotificationProvider.preview()),
          ChangeNotifierProvider<OrderProvider>.value(value: OrderProvider.preview()),
        ],
        child: child,
      );
  ```
  Provee los 4 providers para que cualquier `Consumer`/`context.watch` durante
  `build` resuelva sin `ProviderNotFoundException`.

- **`preview_fixtures.dart`** — factories de sample data deterministas:
  - `OrderModel sampleOrder()` → `OrderModel(id:'P-PREVIEW', cliente:'Ana Gómez',
    telefono:'tg:1001', items:[ItemPedido(nombre:'Pizza Margarita', cantidad:2,
    precio:18000)], total:36000, estado:EstadoPedido.enCamino,
    tipo:TipoPedido.domicilio, direccion:'Calle 123 #45-67',
    creadoEn:DateTime(2026,6,3,12,30))`
  - `Product sampleProduct()` → `Product(id:'PR-PREVIEW', name:'Pizza Margarita',
    categoryId:'cat-1', price:18000, stock:24, minStock:5, prepTimeMinutes:15,
    isAvailable:true, description:'...', aiContext:'', aiActive:true,
    emoji:'🍕')`
  - `UserModel sampleUser()` → `UserModel(id:'U-PREVIEW', email:'ana@pronto.co',
    name:'Ana Gómez', role:RoleType.repartidor)`
  - `Map<String,dynamic> sampleMeta()` → `{}` con las claves que lea
    `perfil_empleado_screen` (a confirmar al leer el archivo en plan).

### 2. Constructores `.preview()` en providers (Approach A)

Cambio **aditivo**: nuevos constructores nombrados que siembran estado y NO
arrancan timers/red. No alteran el comportamiento de la app en runtime.

- `InventoryProvider.preview({List<Product>? products, List<Category>? categories})`
  — asigna `_products`/`_categories`; **no** llama `_loadData()` ni `_iniciarPolling()`.
- `OrderProvider.preview({List<OrderModel>? pedidos})` — asigna `_pedidos`;
  **sin** `Timer`. Repositorio: usar un stub o hacer el repo opcional/nullable
  en este constructor (a decidir en plan según firma de `OrderRepository`).
- `NotificationProvider.preview()` — seed simple (lista vacía o 1-2 ejemplos),
  sin red.
- `AuthService.preview()` — instancia sin red, opcionalmente con un usuario de
  ejemplo para pantallas que leen el usuario actual.

Detalle de implementación a resolver en el plan: cómo construir las instancias
`.preview()` sin requerir `SharedPreferences`/repos reales (stub in-memory o
repos nullable).

### 3. Una preview por archivo (~36 vistas)

Función top-level al final de cada archivo:

```dart
@Preview(name: 'Login', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget loginScreenPreview() => const LoginScreen();
```

- `group` = feature: `'Auth'`, `'Delivery'`, `'Kitchen'`, `'Manager'`.
- `name` = nombre legible de la vista.
- `size`: omitido (la vista se ajusta al frame del dispositivo del previewer).
- Imports añadidos por archivo: `package:flutter/widget_previews.dart` y los
  helpers de `lib/preview_support/`.

### 4. Vistas con argumentos requeridos

| Archivo | Arg requerido | Fixture |
|---|---|---|
| `delivery/screens/detalle_entrega_screen.dart` | `pedido` (OrderModel) | `sampleOrder()` |
| `delivery/screens/en_ruta_screen.dart` | `pedido` (OrderModel) | `sampleOrder()` |
| `manager/screens/perfil_empleado_screen.dart` | `usuario` (UserModel), `meta` (Map) | `sampleUser()`, `sampleMeta()` |
| `manager/widgets/ajustar_stock_modal.dart` | `product` (Product) | `sampleProduct()` |
| `manager/screens/agregar_editar_producto_screen.dart` | `productToEdit` opcional | sin arg (modo "crear") |

### 5. Inventario de archivos a anotar (29 screens + 7 widgets = hasta 36)

**Auth (5 screens + 2 widgets):** landing_page, login_screen, processing_screen,
recover_password_screen, register_screen, auth_modals\*, auth_popup_dialogs\*.

**Delivery (5 screens + 1 widget):** delivery_main_screen, detalle_entrega_screen,
en_ruta_screen, pedidos_para_entregar_screen, perfil_repartidor_screen,
entrega_confirmada_modal.

**Kitchen (5 screens):** cola_pedidos_screen, kitchen_main_screen,
pedidos_listos_screen, perfil_cocinero_screen, preparacion_screen.

**Manager (14 screens + 4 widgets):** agente_ia_contexto_screen, agentes_ia_screen,
agregar_editar_producto_screen, dashboard_screen, equipo_screen, inventario_screen,
invitar_empleado_screen, kpis_screen, manager_main_screen, notificaciones_screen,
orders_screen, perfil_empleado_screen, profile_screen, settings_screen,
ajustar_stock_modal, configurar_agente_modal, editar_perfil_modals\*,
invitacion_enviada_modal.

\* `auth_modals.dart`, `auth_popup_dialogs.dart`, `editar_perfil_modals.dart`
contienen helpers/clases base con muchos args requeridos. En el plan se decide,
por archivo, qué widget público concreto previsualizar (o si se omite por no ser
una "vista" autónoma).

## No-objetivos (YAGNI)

- Sin variantes light/dark ni multi-tamaño (una preview por vista).
- Sin previews para widgets atómicos reutilizables (botones, cards sueltas).
- Sin mock de respuestas de red ni servidor de previews.

## Verificación

1. `flutter analyze` sin errores nuevos.
2. `flutter widget-preview start` renderiza las ~36 vistas sin excepciones en
   consola.
3. Manual: abrir el previewer; confirmar agrupación por feature y tema verde
   `#25D366` aplicado.
4. `flutter test` (suite existente) sigue verde — los constructores `.preview()`
   no alteran runtime.

## Riesgos / cuestiones abiertas

- **Construcción de `.preview()` sin repos reales:** resolver en plan (stub
  in-memory vs repos nullable). Riesgo principal del esfuerzo.
- **Archivos de modales con clases base abstractas:** confirmar caso por caso
  qué widget público se previsualiza.
- **`@Preview` en archivos de producción:** las anotaciones permanecen en el
  código fuente; el tooling las ignora en builds de release (sin costo runtime).
