# Widget Previews Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Añadir `@Preview` de Flutter a las 33 vistas visibles de `lib/features/` para que rendericen offline y deterministas en `flutter widget-preview`.

**Architecture:** Tres helpers en `lib/preview_support/` (tema, wrapper de providers, fixtures de datos) más constructores `.preview()` aditivos en los 4 providers. Cada archivo de vista recibe una función top-level anotada con `@Preview` que devuelve el widget, usando el wrapper y tema compartidos.

**Tech Stack:** Flutter 3.41.6 / Dart 3.11.4, `package:flutter/widget_previews.dart`, `provider`, `google_fonts`.

**Spec:** `docs/superpowers/specs/2026-06-03-widget-previews-design.md`

---

## File Structure

**Crear:**
- `lib/preview_support/preview_theme.dart` — `previewTheme()`.
- `lib/preview_support/preview_fixtures.dart` — factories de sample data.
- `lib/preview_support/preview_wrapper.dart` — `previewWrapper(Widget)`.
- `test/preview_support/preview_providers_test.dart` — tests de los `.preview()`.
- `test/preview_support/preview_fixtures_test.dart` — tests de fixtures.

**Modificar (providers, cambio aditivo):**
- `lib/data/providers/inventory_provider.dart`
- `lib/data/providers/order_provider.dart`
- `lib/data/providers/notification_provider.dart`
- `lib/data/services/auth_service.dart`

**Modificar (33 vistas):** una función `@Preview` top-level por archivo (Tareas 7–10).

**Omitidos** (solo exponen `show…(context)` estáticos / widgets privados, no vistas autónomas): `auth_modals.dart`, `auth_popup_dialogs.dart`, `editar_perfil_modals.dart`.

---

## Task 1: InventoryProvider.preview()

**Files:**
- Modify: `lib/data/providers/inventory_provider.dart`
- Test: `test/preview_support/preview_providers_test.dart`

- [ ] **Step 1: Write the failing test**

Crear `test/preview_support/preview_providers_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';

void main() {
  test('InventoryProvider.preview seeds data and starts no timer', () {
    final p = InventoryProvider.preview(
      products: [
        Product(
          id: 'PR-1', name: 'Pizza', categoryId: 'c1', price: 18000,
          stock: 10, minStock: 2, prepTimeMinutes: 15, isAvailable: true,
          description: '', aiContext: '', aiActive: true, emoji: '🍕',
        ),
      ],
      categories: [Category(id: 'c1', name: 'Pizzas', emoji: '🍕')],
    );

    expect(p.products, hasLength(1));
    expect(p.categories, hasLength(1));
    // No debe lanzar: dispose sin timer activo.
    p.dispose();
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: FAIL — `The method 'preview' isn't defined for the type 'InventoryProvider'`.

- [ ] **Step 3: Make `_repository` nullable and add the preview constructor**

En `lib/data/providers/inventory_provider.dart`:

Cambiar el campo (línea 16):
```dart
  final InventoryRepository? _repository;
```

Cambiar el constructor principal (líneas 27–35) para asignar el campo desde un parámetro no-nulo:
```dart
  InventoryProvider(
    InventoryRepository repository, {
    String baseUrl = 'http://localhost:5050',
    String secreto = '',
  })  : _repository = repository,
        _baseUrl = baseUrl,
        _secreto = secreto {
    _loadData();
    _iniciarPolling();
  }

  /// Constructor solo para widget previews: siembra datos en memoria y NO
  /// arranca polling ni red.
  InventoryProvider.preview({
    List<Product>? products,
    List<Category>? categories,
  })  : _repository = null,
        _baseUrl = '',
        _secreto = '' {
    _products = products ?? <Product>[];
    _categories = categories ?? <Category>[];
  }
```

- [ ] **Step 4: Force-unwrap `_repository` at its (action-only) call sites**

En el mismo archivo, sustituir cada `_repository.` por `_repository!.` en estas líneas (todas dentro de métodos que NO se ejecutan en una preview estática): `saveAllData` (≈76), `getCategories`/`getProducts` en `_loadData` (≈95–96), `addCategory` (≈120), `addProduct` (≈126), `updateProduct` (≈132), `deleteProduct` (≈138).

Ejemplo:
```dart
  void _loadData() {
    _categories = _repository!.getCategories();
    _products = _repository!.getProducts();
    notifyListeners();
  }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: PASS.

- [ ] **Step 6: Verify the app still compiles**

Run: `flutter analyze lib/data/providers/inventory_provider.dart`
Expected: "No issues found!".

- [ ] **Step 7: Commit**

```bash
git add lib/data/providers/inventory_provider.dart test/preview_support/preview_providers_test.dart
git commit -m "feat: agregar constructor preview a InventoryProvider"
```

---

## Task 2: OrderProvider.preview()

**Files:**
- Modify: `lib/data/providers/order_provider.dart`
- Test: `test/preview_support/preview_providers_test.dart`

- [ ] **Step 1: Add the failing test**

Añadir a `test/preview_support/preview_providers_test.dart` (dentro del `main`, nuevo `test`):

```dart
  test('OrderProvider.preview seeds orders and starts no timer', () {
    final p = OrderProvider.preview(
      pedidos: [
        OrderModel(
          id: 'P-1', cliente: 'Ana', telefono: 'tg:1', items: const [],
          total: 1000, estado: EstadoPedido.recibido,
          tipo: TipoPedido.recoger, creadoEn: DateTime(2026, 6, 3),
        ),
      ],
    );

    expect(p.pedidos, hasLength(1));
    p.dispose();
  });
```

Añadir los imports al inicio del archivo de test:
```dart
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: FAIL — `The method 'preview' isn't defined for the type 'OrderProvider'`.

- [ ] **Step 3: Make `_repositorio` nullable and add the preview constructor**

En `lib/data/providers/order_provider.dart`:

Campo (línea 17):
```dart
  final OrderRepository? _repositorio;
```

Constructor principal (líneas 36–48): asignar desde el parámetro no-nulo para no usar `!` en el cache inicial:
```dart
  OrderProvider({
    required OrderRepository repositorio,
    String baseUrl = 'http://localhost:5050',
    String secreto = '',
  })  : _repositorio = repositorio,
        _baseUrl = baseUrl,
        _secreto = secreto {
    // Cargar cache inmediatamente para que la UI no quede en blanco
    _pedidos = repositorio.obtenerCache();

    // Iniciar polling al FastAPI
    _iniciarPolling();
  }

  /// Constructor solo para widget previews: siembra pedidos en memoria y NO
  /// arranca polling ni red.
  OrderProvider.preview({List<OrderModel>? pedidos})
      : _repositorio = null,
        _baseUrl = '',
        _secreto = '' {
    _pedidos = pedidos ?? <OrderModel>[];
  }
```

- [ ] **Step 4: Force-unwrap `_repositorio` at its (action-only) call sites**

Sustituir `_repositorio.` por `_repositorio!.` en `sincronizar`/acciones: `guardarCache` (≈190), `obtenerCache` (≈200), `guardarCache` (≈239), `guardarCache` (≈246), `guardarCache` (≈267). Ninguno se ejecuta en una preview estática.

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: PASS (2 tests).

- [ ] **Step 6: Verify compile**

Run: `flutter analyze lib/data/providers/order_provider.dart`
Expected: "No issues found!".

- [ ] **Step 7: Commit**

```bash
git add lib/data/providers/order_provider.dart test/preview_support/preview_providers_test.dart
git commit -m "feat: agregar constructor preview a OrderProvider"
```

---

## Task 3: NotificationProvider.preview() y AuthService.preview()

**Files:**
- Modify: `lib/data/providers/notification_provider.dart`
- Modify: `lib/data/services/auth_service.dart`
- Test: `test/preview_support/preview_providers_test.dart`

- [ ] **Step 1: Add the failing test**

Añadir a `test/preview_support/preview_providers_test.dart`:

```dart
  test('NotificationProvider.preview seeds sample notifications', () {
    final p = NotificationProvider.preview();
    expect(p.notifications, isNotEmpty);
  });

  test('AuthService.preview sets a current user', () {
    final auth = AuthService.preview();
    expect(auth.currentUser, isNotNull);
    expect(auth.isInitialized, isTrue);
  });
```

Imports a añadir:
```dart
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: FAIL — `preview` no definido en `NotificationProvider` / `AuthService`.

- [ ] **Step 3: Add NotificationProvider.preview()**

En `lib/data/providers/notification_provider.dart`, tras el constructor (línea 67):

```dart
  /// Constructor solo para widget previews: siembra notificaciones de ejemplo.
  factory NotificationProvider.preview() {
    final p = NotificationProvider();
    p.addNotification(NotificationModel(
      id: 'n1',
      title: 'Nuevo pedido recibido',
      description: 'Ana Gómez · \$36000',
      timestamp: DateTime.now(),
      type: NotificationType.pedido,
    ));
    p.addNotification(NotificationModel(
      id: 'n2',
      title: 'Agente IA actualizado',
      description: 'El bot respondió 12 mensajes hoy',
      timestamp: DateTime.now(),
      type: NotificationType.ia,
    ));
    return p;
  }
```

- [ ] **Step 4: Add AuthService.preview()**

En `lib/data/services/auth_service.dart`, tras `AuthService._internal();` (línea 9):

```dart
  /// Constructor solo para widget previews: deja el singleton con un usuario
  /// de ejemplo, sin tocar SharedPreferences ni la red.
  factory AuthService.preview({UserModel? user}) {
    _instance._currentUser = user ??
        UserModel(
          id: 'preview',
          email: 'ana@pronto.co',
          name: 'Ana Gómez',
          role: RoleType.gerente,
        );
    _instance._isInitialized = true;
    return _instance;
  }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `flutter test test/preview_support/preview_providers_test.dart -r expanded`
Expected: PASS (4 tests).

- [ ] **Step 6: Commit**

```bash
git add lib/data/providers/notification_provider.dart lib/data/services/auth_service.dart test/preview_support/preview_providers_test.dart
git commit -m "feat: agregar constructores preview a NotificationProvider y AuthService"
```

---

## Task 4: Fixtures de sample data

**Files:**
- Create: `lib/preview_support/preview_fixtures.dart`
- Test: `test/preview_support/preview_fixtures_test.dart`

- [ ] **Step 1: Write the failing test**

Crear `test/preview_support/preview_fixtures_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:prontoapp/preview_support/preview_fixtures.dart';

void main() {
  test('fixtures return non-empty deterministic data', () {
    expect(sampleProducts(), isNotEmpty);
    expect(sampleCategories(), isNotEmpty);
    expect(sampleOrders(), isNotEmpty);
    expect(sampleOrder().items, isNotEmpty);
    expect(sampleUser().name, isNotEmpty);
    expect(sampleMeta()['role'], isNotNull);
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/preview_support/preview_fixtures_test.dart -r expanded`
Expected: FAIL — `Target of URI doesn't exist: '.../preview_fixtures.dart'`.

- [ ] **Step 3: Create the fixtures file**

Crear `lib/preview_support/preview_fixtures.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:prontoapp/data/models/category_model.dart';
import 'package:prontoapp/data/models/order_model.dart';
import 'package:prontoapp/data/models/product_model.dart';
import 'package:prontoapp/data/models/user_model.dart';

/// Sample data determinista usado únicamente por las widget previews.

List<Category> sampleCategories() => [
      Category(id: 'cat-pizzas', name: 'Pizzas', emoji: '🍕'),
      Category(id: 'cat-bebidas', name: 'Bebidas', emoji: '🥤'),
    ];

List<Product> sampleProducts() => [
      Product(
        id: 'PR-1', name: 'Pizza Margarita', categoryId: 'cat-pizzas',
        price: 18000, stock: 24, minStock: 5, prepTimeMinutes: 15,
        isAvailable: true, description: 'Tomate, mozzarella y albahaca.',
        aiContext: '', aiActive: true, emoji: '🍕',
      ),
      Product(
        id: 'PR-2', name: 'Limonada', categoryId: 'cat-bebidas',
        price: 6000, stock: 3, minStock: 5, prepTimeMinutes: 3,
        isAvailable: true, description: 'Limonada natural 500ml.',
        aiContext: '', aiActive: true, emoji: '🥤',
      ),
    ];

Product sampleProduct() => sampleProducts().first;

OrderModel _order({
  required String id,
  required String cliente,
  required EstadoPedido estado,
  required TipoPedido tipo,
  int minutosAtras = 10,
}) =>
    OrderModel(
      id: id,
      cliente: cliente,
      telefono: 'tg:0001',
      items: const [
        ItemPedido(nombre: 'Pizza Margarita', cantidad: 2, precio: 18000),
        ItemPedido(nombre: 'Limonada', cantidad: 1, precio: 6000),
      ],
      total: 42000,
      estado: estado,
      tipo: tipo,
      direccion: tipo == TipoPedido.domicilio ? 'Calle 123 #45-67' : null,
      creadoEn: DateTime.now().subtract(Duration(minutes: minutosAtras)),
    );

List<OrderModel> sampleOrders() => [
      _order(id: 'P-A1', cliente: 'Ana Gómez', estado: EstadoPedido.recibido, tipo: TipoPedido.domicilio, minutosAtras: 5),
      _order(id: 'P-B2', cliente: 'Luis Pérez', estado: EstadoPedido.enPreparacion, tipo: TipoPedido.recoger, minutosAtras: 20),
      _order(id: 'P-C3', cliente: 'Sara Díaz', estado: EstadoPedido.listo, tipo: TipoPedido.domicilio, minutosAtras: 35),
      _order(id: 'P-D4', cliente: 'Juan Ruiz', estado: EstadoPedido.entregado, tipo: TipoPedido.recoger, minutosAtras: 90),
    ];

OrderModel sampleOrder() => sampleOrders().first;

UserModel sampleUser() => UserModel(
      id: 'U-PREVIEW',
      email: 'ana@pronto.co',
      name: 'Ana Gómez',
      role: RoleType.repartidor,
    );

/// `meta` que consume `perfil_empleado_screen.dart` (todas las claves que lee).
Map<String, dynamic> sampleMeta() => {
      'role': 'Repartidora',
      'initial': 'A',
      'initialColor': const Color(0xFFB45309),
      'gradientColors': const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
      'roleBg': const Color(0xFFFEF3C7),
      'roleIcon': FontAwesomeIcons.motorcycle,
      'roleColor': const Color(0xFFB45309),
      'statusDotColor': const Color(0xFF25D366),
      'statusText': 'Activa',
    };
```

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/preview_support/preview_fixtures_test.dart -r expanded`
Expected: PASS.

- [ ] **Step 5: Commit**

```bash
git add lib/preview_support/preview_fixtures.dart test/preview_support/preview_fixtures_test.dart
git commit -m "feat: agregar fixtures de datos para previews"
```

---

## Task 5: preview_theme.dart

**Files:**
- Create: `lib/preview_support/preview_theme.dart`

- [ ] **Step 1: Create the theme helper**

Crear `lib/preview_support/preview_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema aplicado a todas las widget previews. Replica el tema de la app
/// definido en `lib/main.dart`.
PreviewThemeData previewTheme() => PreviewThemeData(
      materialLight: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
    );
```

- [ ] **Step 2: Verify it analyzes clean**

Run: `flutter analyze lib/preview_support/preview_theme.dart`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/preview_support/preview_theme.dart
git commit -m "feat: agregar tema compartido para previews"
```

---

## Task 6: preview_wrapper.dart

**Files:**
- Create: `lib/preview_support/preview_wrapper.dart`

- [ ] **Step 1: Create the wrapper**

Crear `lib/preview_support/preview_wrapper.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/services/auth_service.dart';

import 'preview_fixtures.dart';

/// Envuelve el widget previsualizado con los providers de la app, usando
/// instancias `.preview()` (sin red ni timers). Firma compatible con
/// `WidgetWrapper = Widget Function(Widget)`.
Widget previewWrapper(Widget child) => MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: AuthService.preview()),
        ChangeNotifierProvider<InventoryProvider>.value(
          value: InventoryProvider.preview(
            products: sampleProducts(),
            categories: sampleCategories(),
          ),
        ),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: NotificationProvider.preview(),
        ),
        ChangeNotifierProvider<OrderProvider>.value(
          value: OrderProvider.preview(pedidos: sampleOrders()),
        ),
      ],
      child: child,
    );
```

- [ ] **Step 2: Verify it analyzes clean**

Run: `flutter analyze lib/preview_support/`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/preview_support/preview_wrapper.dart
git commit -m "feat: agregar wrapper de providers para previews"
```

---

## Task 7: Previews del feature Auth (5 vistas)

**Files (modify):** `lib/features/auth/screens/{landing_page,login_screen,processing_screen,recover_password_screen,register_screen}.dart`

- [ ] **Step 1: Add the preview function to each file**

En CADA archivo: añadir estos imports junto a los existentes…
```dart
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
```
…y añadir AL FINAL del archivo la función correspondiente:

```dart
@Preview(name: 'Landing', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget landingPagePreview() => const LandingPage();

@Preview(name: 'Login', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget loginScreenPreview() => const LoginScreen();

@Preview(name: 'Procesando', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget processingScreenPreview() => const ProcessingScreen();

@Preview(name: 'Recuperar contraseña', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget recoverPasswordScreenPreview() => const RecoverPasswordScreen();

@Preview(name: 'Registro', group: 'Auth', wrapper: previewWrapper, theme: previewTheme)
Widget registerScreenPreview() => const RegisterScreen();
```

(Cada bloque va en el archivo de su pantalla. `LandingPage` usa su default `role`.)

- [ ] **Step 2: Verify the feature analyzes clean**

Run: `flutter analyze lib/features/auth/`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/features/auth/screens/
git commit -m "feat: agregar previews a las pantallas de auth"
```

---

## Task 8: Previews del feature Delivery (6 vistas)

**Files (modify):** `lib/features/delivery/screens/{delivery_main_screen,detalle_entrega_screen,en_ruta_screen,pedidos_para_entregar_screen,perfil_repartidor_screen}.dart`, `lib/features/delivery/widgets/entrega_confirmada_modal.dart`

- [ ] **Step 1: Add the preview function to each file**

Imports a añadir en cada archivo (igual que Task 7). Las vistas con argumentos requeridos también importan los fixtures:
```dart
import 'package:prontoapp/preview_support/preview_fixtures.dart';
```

Funciones por archivo:

```dart
// delivery_main_screen.dart
@Preview(name: 'Delivery — Home', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget deliveryMainScreenPreview() => const DeliveryMainScreen();

// detalle_entrega_screen.dart  (requiere pedido)
@Preview(name: 'Detalle entrega', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget detalleEntregaScreenPreview() => DetalleEntregaScreen(pedido: sampleOrder());

// en_ruta_screen.dart  (requiere pedido)
@Preview(name: 'En ruta', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget enRutaScreenPreview() => EnRutaScreen(pedido: sampleOrder());

// pedidos_para_entregar_screen.dart
@Preview(name: 'Pedidos para entregar', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget pedidosParaEntregarScreenPreview() => const PedidosParaEntregarScreen();

// perfil_repartidor_screen.dart
@Preview(name: 'Perfil repartidor', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget perfilRepartidorScreenPreview() => const PerfilRepartidorScreen();

// entrega_confirmada_modal.dart
@Preview(name: 'Entrega confirmada', group: 'Delivery', wrapper: previewWrapper, theme: previewTheme)
Widget entregaConfirmadaModalPreview() => const EntregaConfirmadaModal();
```

- [ ] **Step 2: Verify the feature analyzes clean**

Run: `flutter analyze lib/features/delivery/`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/features/delivery/
git commit -m "feat: agregar previews a las pantallas de delivery"
```

---

## Task 9: Previews del feature Kitchen (5 vistas)

**Files (modify):** `lib/features/kitchen/screens/{cola_pedidos_screen,kitchen_main_screen,pedidos_listos_screen,perfil_cocinero_screen,preparacion_screen}.dart`

- [ ] **Step 1: Add the preview function to each file**

Imports igual que Task 7. Funciones (todas son const sin args):

```dart
// cola_pedidos_screen.dart
@Preview(name: 'Cola de pedidos', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget colaPedidosScreenPreview() => const ColaPedidosScreen();

// kitchen_main_screen.dart
@Preview(name: 'Cocina — Home', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget kitchenMainScreenPreview() => const KitchenMainScreen();

// pedidos_listos_screen.dart
@Preview(name: 'Pedidos listos', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget pedidosListosScreenPreview() => const PedidosListosScreen();

// perfil_cocinero_screen.dart
@Preview(name: 'Perfil cocinero', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget perfilCocineroScreenPreview() => const PerfilCocineroScreen();

// preparacion_screen.dart
@Preview(name: 'Preparación', group: 'Kitchen', wrapper: previewWrapper, theme: previewTheme)
Widget preparacionScreenPreview() => const PreparacionScreen();
```

- [ ] **Step 2: Verify the feature analyzes clean**

Run: `flutter analyze lib/features/kitchen/`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/features/kitchen/
git commit -m "feat: agregar previews a las pantallas de kitchen"
```

---

## Task 10: Previews del feature Manager (17 vistas)

**Files (modify):** los 14 `lib/features/manager/screens/*.dart` (excepto ninguno) y 3 widgets `lib/features/manager/widgets/{ajustar_stock_modal,configurar_agente_modal,invitacion_enviada_modal}.dart`.

- [ ] **Step 1: Add the preview function to each file**

Imports igual que Task 7; `perfil_empleado_screen.dart` y `ajustar_stock_modal.dart` también importan `preview_fixtures.dart`.

```dart
// agente_ia_contexto_screen.dart
@Preview(name: 'Agente IA — Contexto', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget agenteIaContextoScreenPreview() => const AgenteIaContextoScreen();

// agentes_ia_screen.dart
@Preview(name: 'Agentes IA', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget agentesIaScreenPreview() => const AgentesIaScreen();

// agregar_editar_producto_screen.dart  (productToEdit opcional → modo crear)
@Preview(name: 'Agregar producto', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget agregarEditarProductoScreenPreview() => const AgregarEditarProductoScreen();

// dashboard_screen.dart
@Preview(name: 'Dashboard', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget dashboardScreenPreview() => const DashboardScreen();

// equipo_screen.dart
@Preview(name: 'Equipo', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget equipoScreenPreview() => const EquipoScreen();

// inventario_screen.dart
@Preview(name: 'Inventario', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget inventarioScreenPreview() => const InventarioScreen();

// invitar_empleado_screen.dart
@Preview(name: 'Invitar empleado', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget invitarEmpleadoScreenPreview() => const InvitarEmpleadoScreen();

// kpis_screen.dart
@Preview(name: 'KPIs', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget kpisScreenPreview() => const KpisScreen();

// manager_main_screen.dart
@Preview(name: 'Manager — Home', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget managerMainScreenPreview() => const ManagerMainScreen();

// notificaciones_screen.dart
@Preview(name: 'Notificaciones', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget notificacionesScreenPreview() => const NotificacionesScreen();

// orders_screen.dart
@Preview(name: 'Pedidos', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget ordersScreenPreview() => const OrdersScreen();

// perfil_empleado_screen.dart  (requiere usuario + meta)
@Preview(name: 'Perfil empleado', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget perfilEmpleadoScreenPreview() =>
    PerfilEmpleadoScreen(usuario: sampleUser(), meta: sampleMeta());

// profile_screen.dart
@Preview(name: 'Perfil', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget profileScreenPreview() => const ProfileScreen();

// settings_screen.dart
@Preview(name: 'Ajustes', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget settingsScreenPreview() => const SettingsScreen();

// ajustar_stock_modal.dart  (requiere product)
@Preview(name: 'Ajustar stock', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget ajustarStockModalPreview() => AjustarStockModal(product: sampleProduct());

// configurar_agente_modal.dart
@Preview(name: 'Configurar agente', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget configurarAgenteModalPreview() => const ConfigurarAgenteModal();

// invitacion_enviada_modal.dart
@Preview(name: 'Invitación enviada', group: 'Manager', wrapper: previewWrapper, theme: previewTheme)
Widget invitacionEnviadaModalPreview() => const InvitacionEnviadaModal();
```

- [ ] **Step 2: Verify the feature analyzes clean**

Run: `flutter analyze lib/features/manager/`
Expected: "No issues found!".

- [ ] **Step 3: Commit**

```bash
git add lib/features/manager/
git commit -m "feat: agregar previews a las pantallas de manager"
```

---

## Task 11: Verificación final

**Files:** ninguno (solo verificación).

- [ ] **Step 1: Analyze the whole project**

Run: `flutter analyze`
Expected: "No issues found!" (sin errores nuevos respecto al baseline).

- [ ] **Step 2: Run the full test suite**

Run: `flutter test`
Expected: todos los tests pasan (incluye los nuevos de `test/preview_support/`).

- [ ] **Step 3: Launch the widget previewer and confirm rendering**

Run: `flutter widget-preview start`
Expected: arranca sin errores; las 33 previews aparecen agrupadas por `Auth`/`Delivery`/`Kitchen`/`Manager`, renderizan con el tema verde `#25D366` y sin excepciones en consola.

- [ ] **Step 4: Manual check**

Confirmar visualmente: las vistas con datos (dashboard, inventario, orders, notificaciones, detalle_entrega, perfil_empleado, ajustar_stock) muestran el sample data; ninguna muestra `ProviderNotFoundException` ni pantalla de error.

- [ ] **Step 5: Final commit (si quedaron cambios sin commitear)**

```bash
git add -A
git commit -m "chore: verificar widget previews en todas las vistas"
```

---

## Notas de ejecución

- **Orden:** Tareas 1–6 (infraestructura) antes que 7–10 (anotaciones). Task 11 al final.
- **Sin firma de IA** en commits; descripción en español, tipo Conventional Commits en inglés.
- **TDD:** Tareas 1–4 llevan test unitario primero. Las anotaciones (7–10) son metadata declarativa sin comportamiento testeable por unidad; su verificación es `flutter analyze` por feature + el previewer en Task 11.
- **Baseline:** correr `flutter analyze` antes de empezar para conocer warnings preexistentes y no atribuirlos a este trabajo.
