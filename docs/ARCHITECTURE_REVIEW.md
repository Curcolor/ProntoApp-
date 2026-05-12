# ProntoApp — Architecture Review

> Auditoría arquitectural del proyecto Flutter `ProntoApp-`.
> **Fecha**: 2026-05-11
> **Auditor**: Principal Engineer Review (Claude Opus 4.7)
> **Alcance**: Fases 1, 2, 3 y 5 completadas. Fase 4 (Figma) parcial — pendiente con MCP autenticado y URL del file.
> **Branch**: `main` · **Commit base**: `cfbc342`
> **Leyenda**: **HECHO** = verificado en código · **SUPOSICIÓN** = inferido · **PENDIENTE VALIDAR** = requiere confirmación del owner.

---

## 1. Executive Summary

Prontoa! avanzó más rápido que su propio documento de formulación. El estudio técnico describe un panel web HTML/JS + React que opera sobre WhatsApp Business; el repositorio entrega una aplicación Flutter móvil multi-plataforma que opera sobre un bot de Telegram. La aplicación tiene ~17.500 líneas de código bien organizadas en una estructura por features, y cubre los flujos visuales de tres roles internos (gerente, cocinero, repartidor) con un nivel de fidelidad visual alto. Sin embargo, no es desplegable a producción tal cual: tiene un token secreto en el repositorio, contraseñas en texto plano en el dispositivo, tráfico HTTP sin TLS apuntando a `localhost`, y autenticación falsa que vive 100% en el cliente. La calidad interna también tiene deuda alta: 19 archivos superan las 400 líneas, hay 812 colores literales esparcidos donde debería haber tokens, y la cobertura de tests es cero. La buena noticia es que la base es refactorizable: la separación por feature, el uso de Provider, y la trazabilidad explícita a nodos de Figma indican que el equipo conoce el rumbo. Antes de continuar añadiendo features se requiere (1) rotar el secreto y removerlo del git history, (2) reemplazar la autenticación falsa por JWT contra el backend, (3) cerrar el gap entre el documento de formulación y la realidad del producto (canal, stack, rol nuevo, alcance). Sin esos tres pasos no hay producto comercializable.

---

## 2. Hallazgo crítico: gap entre formulación y código real

| Aspecto | Formulación (`docs/formulacion-proyecto.md`) | Código real | Severidad |
|---|---|---|---|
| **Stack frontend** | HTML5/CSS3/JS — "Panel web" (§2.2.2, L1307-1310). Menciones aisladas de React (L2011, L2039) | **Flutter/Dart** (Android+iOS+Web) | **CRÍTICA** — doc nunca actualizado |
| **Canal de mensajería** | WhatsApp Business API (§2.2.1, L1283; n8n integrado a WhatsApp) | **Telegram** (`order_model.dart:138` `'tg:12345678'`; comentarios "bot de Telegram") | **CRÍTICA** — branding miente |
| **Branding visual** | "WhatsApp" en todo el doc | App muestra `FontAwesomeIcons.whatsapp` + paleta verde WhatsApp + sheet "WhatsApp Business" en perfil | **ALTA** — riesgo legal de marca |
| **Actores** | 3 actores: Administrador, Cliente (WhatsApp), Repartidor | 3 roles: gerente, **cocinero (NUEVO)**, repartidor. Cliente correctamente excluido. | **ALTA** — scope creep no documentado |
| **Infra dependencias** | n8n, Kafka, Redis, S3, K8s | 0 evidencia en código móvil (correcto si vive en backend) — **PENDIENTE VALIDAR backend** | MEDIA |
| **Auth** | RNF-02: "autenticación mediante roles y encriptación" | Auth 100% local, passwords plaintext en SharedPreferences | **CRÍTICA** |

**Conclusión**: el documento de formulación está desactualizado en mínimo 4 puntos sustanciales. La evaluación financiera del documento (TIR 14,17%, VPN +29M COP, 27 semanas) se calculó sobre supuestos que ya no aplican (rol DevOps, dev Frontend React, licencias WhatsApp Business API). **Re-evaluar viabilidad financiera con stack real es trabajo pendiente.**

---

## 3. Estado actual (síntesis Fases 1-2)

### 3.1 Inventario (HECHO)

| Métrica | Valor |
|---|---|
| Dart SDK | `^3.11.3` |
| Versión app | `1.0.0+1` |
| Plataformas target | Android + iOS + Web |
| Archivos `.dart` | 50 |
| LOC totales / efectivas | 17.495 / 16.294 |
| Screens | ~30 |
| Models | 4 (`Order`, `Product`, `Category`, `User`) |
| Providers (ChangeNotifier) | 3 (`Order`, `Inventory`, `Notification`) |
| Repositories | 2 (`Order`, `Inventory`) — solo cache local |
| Services | 1 (`AuthService` — fake) |
| Widgets custom reusables | 1 (`CustomTextField`) + 7 modales |
| Tests | Solo `widget_test.dart` boilerplate → **cobertura ~0%** |
| CI/CD | Ninguno (`.github/workflows` no existe) |
| State mgmt | `provider` 6.1.5 (mezclado con setState) |

### 3.2 Stack declarado en `pubspec.yaml`

`cupertino_icons ^1.0.8` · `google_fonts ^8.0.2` · `font_awesome_flutter ^11.0.0` · `flutter_svg ^2.2.4` · `shared_preferences ^2.5.5` · `provider ^6.1.5+1` · `http ^1.2.2` · `flutter_lints ^6.0.0`

**Notablemente AUSENTES**: `flutter_secure_storage`, `flutter_dotenv`, `intl`, `freezed`, `json_serializable`, `dio`/`retrofit`, `cached_network_image`, `go_router`, Sentry/Crashlytics, FCM/Firebase Messaging, Riverpod, BLoC.

### 3.3 Arquitectura actual (HECHO)

```
lib/
├── main.dart                          # bootstrap + MultiProvider
├── app/routes.dart                    # 4 rutas estáticas + role-based home
├── core/
│   ├── constants/app_colors.dart      # Paleta WhatsApp + Slate + status
│   └── widgets/custom_text_field.dart
├── data/
│   ├── models/                        # 4 modelos (fromJson/toJson manual)
│   ├── providers/                     # 3 ChangeNotifier con HTTP embebido
│   ├── repositories/                  # 2 cache de SharedPreferences
│   └── services/auth_service.dart     # Singleton + ChangeNotifier (fake auth)
└── features/
    ├── auth/      (5 screens + 2 widgets)
    ├── delivery/  (5 screens + 1 widget)
    ├── kitchen/   (5 screens)
    └── manager/   (15 screens + 4 widgets)
```

**Patrón reconocible**: Feature-first + Provider + Repository (parcial).

### 3.4 Top 10 archivos por tamaño

| Líneas | Archivo |
|---:|---|
| 1065 | `lib/features/manager/widgets/editar_perfil_modals.dart` |
| 887 | `lib/features/manager/screens/agregar_editar_producto_screen.dart` |
| 649 | `lib/features/delivery/screens/detalle_entrega_screen.dart` |
| 645 | `lib/features/manager/screens/dashboard_screen.dart` |
| 632 | `lib/features/manager/screens/inventario_screen.dart` |
| 625 | `lib/features/kitchen/screens/preparacion_screen.dart` |
| 604 | `lib/features/manager/screens/perfil_empleado_screen.dart` |
| 592 | `lib/features/manager/screens/profile_screen.dart` |
| 590 | `lib/features/auth/screens/register_screen.dart` |
| 576 | `lib/features/auth/widgets/auth_popup_dialogs.dart` |

→ 19 archivos > 400 LOC (god widgets).

### 3.5 Diagnóstico de deuda técnica

| # | Issue | Severidad | Evidencia |
|---|---|---|---|
| 1 | Secret hex 64-char hardcoded en repo | **CRÍTICA** | `main.dart:39,47` `secreto: '83c58120…b43f43'` |
| 2 | Passwords plaintext en SharedPreferences | **CRÍTICA** | `auth_service.dart:32-46, 86-87` |
| 3 | HTTP sin TLS apuntando a localhost hardcoded | **CRÍTICA** | `main.dart:38,46` `http://localhost:5050` |
| 4 | Auth 100% client-side (sin backend real) | **CRÍTICA** | `auth_service.dart` no llama al FastAPI |
| 5 | Login SnackBar filtra credenciales demo | **CRÍTICA** | `login_screen.dart:61` `'usa gerente@prontoa.com / password123'` |
| 6 | God widgets (19 archivos > 400 LOC) | ALTA | Ver tabla 3.4 |
| 7 | 812 colores literales en 37 archivos (tokens ignorados) | ALTA | `Grep Color\(0xFF` → 812 hits |
| 8 | Hardcoding de contenido de negocio | ALTA | "Mi Panadería", "Panadería El Trigo Dorado", emails fake |
| 9 | Polling cada 5s en 2 providers sin lifecycle ni backoff | ALTA | `order_provider.dart:34`, `inventory_provider.dart:38` |
| 10 | Manejo errores: catch silencioso + optimistic write sin rollback | ALTA | `order_provider.dart:243-248`, `inventory_provider.dart:80-82` |
| 11 | HTTP brinca la capa Repository | ALTA | Repos son solo cache, providers contienen HTTP |
| 12 | Observabilidad 0 (sin print/debugPrint/Sentry/Crashlytics/analytics) | ALTA | `Grep print\|debugPrint` → 0 hits |
| 13 | Testabilidad ~0% — sin tests, sin CI | ALTA | Solo `widget_test.dart` boilerplate |
| 14 | Singletons + estado global mutable | MEDIA | `AuthService._instance` + ChangeNotifier registrado |
| 15 | Mezcla setState + Provider sin convención | MEDIA | 54 setState en 20 screens + 49 Consumer en 22 archivos |
| 16 | Routing pobre (sin tipado, sin guards, sin deep links) | MEDIA | `routes.dart` 4 rutas + navegación manual |
| 17 | Duplicación visual: 7 modales bottom-sheet sin base común | MEDIA | `auth_modals`, `auth_popup_dialogs`, `entrega_confirmada_modal`, etc. |
| 18 | JSON serialization manual (sin `freezed`/`json_serializable`) | MEDIA | `OrderModel.copyWith` solo soporta `estado` |
| 19 | `_buildXxx` dentro de StatefulWidget — rebuilds completos | BAJA | Patrón generalizado |
| 20 | Lint set mínimo (solo `flutter_lints`) | BAJA | `analysis_options.yaml` |

---

## 4. Alineación con negocio y diseño (síntesis Fases 3-4)

### 4.1 Cobertura de Requerimientos Funcionales

| RF | Nombre | Estado | Notas |
|---|---|---|---|
| RF-01 | Automatización pedidos WhatsApp | **NO APLICA A MÓVIL + DIVERGENTE** | Canal real = Telegram |
| RF-02 | Gestión Visual Kanban | **PARCIAL** | Tabs por estado, no drag-drop; faltan 2 de 6 estados doc (Pagado/Cerrado) |
| RF-03 | Notificaciones automáticas al cliente | **NO APLICA A MÓVIL** | Backend responsibility |
| RF-04 | Procesamiento multimodal | **NO APLICA A MÓVIL** | Backend |
| RF-05 | Impresión automática tiquetes | **NO IMPLEMENTADO** | 0 código de impresión Bluetooth/ESC-POS |
| RF-06 | Supervisión Humana | **PARCIAL** | UI de "Agentes IA" presente, falta live feed/chat-takeover |
| RF-07 | Panel KPIs | **IMPLEMENTADO (mock-data)** | `kpis_screen.dart` + dashboard; cálculos client-side |
| RF-08 | Modificación pedidos (tiempo gracia) | **NO IMPLEMENTADO** | `copyWith` solo soporta cambio de estado |

### 4.2 Cobertura de Requerimientos No Funcionales

| RNF | Nombre | Estado en móvil |
|---|---|---|
| RNF-01 | Rendimiento (<5min, multi-pedido) | PARCIAL — polling 5s contribuye; pero detección de cambios por `length` pierde updates |
| RNF-02 | Seguridad/Autenticación | **FALLA** — ver issues 1-5 |
| RNF-03 | Escalabilidad | NO APLICA (backend) |
| RNF-04 | Usabilidad (3 interacciones) | NO MEDIDO — sin analytics |
| RNF-05 | Mantenibilidad modular | **FALLA EN MÓVIL** — god widgets, 0 tests, HTTP fuera de repos |
| RNF-06 | Compatibilidad multi-plataforma + POS | PARCIAL — Flutter cubre 3 targets; POS no integrado |

### 4.3 Features huérfanas (en código, no en doc)

- Rol completo "Cocinero" (`features/kitchen/*`, 5 screens, ~30% del código)
- Gestión de equipo/invitar empleado/perfil empleado (4 archivos)
- Editor de perfiles con 6 sub-modales (1065 LOC en un archivo, incluye "WhatsApp Business sheet")
- OAuth Google/Facebook (dialogs mock, no SSO real)
- Notificaciones in-app al gerente (vs RF-03 que era para cliente)
- `processing_screen.dart` (loading post-login)

### 4.4 Cobertura de Casos de Uso (CU-01..CU-15)

| Grupo | Implementado | Parcial | No implementado |
|---|---|---|---|
| Administrador (CU-01..08) | CU-05, CU-07 | CU-01 | CU-02, CU-03, CU-04, CU-06, CU-08 |
| Cliente (CU-09..13) | — | — | NO APLICA (vive en bot) |
| Repartidor (CU-14..15) | — | CU-14, CU-15 | — |

### 4.5 Features documentadas costosas con arquitectura actual

(Por qué duele con el código de hoy — ver detalle en Fase 3)

1. **RF-05 Impresión automática** — requiere driver Bluetooth/ESC-POS + push del backend (no hay FCM); 2-3 sprints.
2. **RF-08 Modificación con tiempo de gracia** — `copyWith` incompleto, race conditions con polling 5s, falta endpoint editar items.
3. **CU-06 Estados Kanban personalizables** — `EstadoPedido` es enum hardcoded; convertir a datos rompe `order_provider` completo.
4. **CU-08 Plantillas de notificaciones** — no existe sistema de plantillas en código.
5. **CU-03 Supervisar conversaciones** — requiere socket/SSE, app solo tiene polling REST.
6. **RF-06 Derivación a operador** — requiere stack reactivo (Riverpod + WebSocket).
7. **Migración a WhatsApp Business** — datos en formato `tg:NNN`, debe migrar a E.164, plantillas WABA, verificación Meta.
8. **RNF-02 Auth real** — reemplazar `AuthService` por JWT + `flutter_secure_storage` + route guards.
9. **Multi-tenancy** — strings de negocio hardcoded; debe venir de sesión.

### 4.6 Diseño Figma (Fase 4 — PENDIENTE)

- MCP Figma **conectado** al cierre de esta sesión pero tools no descubiertos (requiere reinicio de sesión Claude Code).
- Sin URL del file Figma proporcionada.
- `editar_perfil_modals.dart` referencia **node IDs explícitos** (`2234:887`, `2234:536`, `2234:624`, `2234:703`) → existe trazabilidad code↔Figma que se puede validar 1:1 cuando MCP esté operativo.
- Paleta `core/constants/app_colors.dart` corresponde 1:1 con Tailwind Slate + WhatsApp brand → **SUPOSICIÓN**: Figma usa sistema Tailwind. Confirmar.
- **Listado de pantallas implementadas** (~30) en sección 3.3 para mapeo contra Figma en próxima sesión.

---

## 5. Riesgos top 5

| # | Riesgo | Probabilidad | Impacto | Mitigación inmediata |
|---|---|---|---|---|
| 1 | **Compromiso del backend por secreto en repo** | ALTA | Total | Rotar token YA; `git filter-repo` para purgar; mover a `--dart-define`; auditar logs del backend |
| 2 | **Auth falsa permite acceso sin login** | CIERTA | Total | Reemplazar `AuthService` por JWT contra backend antes de cualquier piloto |
| 3 | **Marketing-product mismatch** (doc dice WhatsApp, app usa Telegram) | CIERTA | Alto | Decidir: pivotar a Telegram oficialmente + actualizar doc + rebrand, o migrar canal a WhatsApp Business (12+ semanas con Meta) |
| 4 | **Web target con secretos visibles** | MEDIA | Alto | Si `flutter build web` se publica, secrets viven en JS bundle → bloquear web build hasta que secretos salgan del código |
| 5 | **Imposibilidad de operar producción** (HTTP localhost, sin TLS, sin FCM, sin observabilidad) | CIERTA | Alto | Stack mínimo de prod: HTTPS + dotenv/dart-define + Sentry + FCM + CI/CD |

(Riesgos doc materializándose, riesgos nuevos, y bottlenecks de performance/productividad detallados en Fase 5 del transcript.)

---

## 6. Plan de acción

### 6.1 REQUERIDO — bloqueante para producción

| # | Acción | Esfuerzo | Valor | Justificación |
|---|---|---|---|---|
| R1 | Rotar token `X-Secret` en backend; remover de código; purgar git history con `git filter-repo`; mover a `--dart-define=PRONTOA_SECRET=…` | S | Alto | Bloqueante de seguridad #1 |
| R2 | Reemplazar `AuthService` local por **JWT contra backend** (`/auth/login`, `/auth/refresh`); guardar tokens en `flutter_secure_storage`; eliminar campo `password` de `UserModel` y de cache | M | Alto | RNF-02 + bloqueante absoluto |
| R3 | Parametrizar `baseUrl` por flavor (dev/staging/prod) vía `--dart-define`; bloquear `cleartext_traffic` en `AndroidManifest.xml` + `App Transport Security` iOS; forzar HTTPS | S | Alto | Sin esto no hay build prod |
| R4 | Remover SnackBar `'usa gerente@prontoa.com / password123'` (`login_screen.dart:61`); crear seed de usuarios demo solo en `kDebugMode` | S | Alto | Filtra credenciales en prod |
| R5 | Decidir y documentar canal real: **Telegram oficial o migración a WhatsApp Business**. Actualizar `docs/formulacion-proyecto.md` con ADR explícito | S | Alto | Cierra marketing-product mismatch + riesgo legal |
| R6 | Actualizar documento de formulación reflejando: stack Flutter, canal real, rol Cocinero adicional, alcance real (panel admin móvil, no web HTML/JS) | S | Alto | Stakeholders desalineados |
| R7 | Implementar **route guards por rol** y `go_router` con tipado de args; eliminar `AuthService()` singleton llamado directo en `routes.dart:36` | M | Alto | Backend-driven role no se hereda solo del singleton |
| R8 | Agregar **Sentry o Firebase Crashlytics**; capturar errores en los 16 try/catch existentes (`catch (_)`) y reportar | S | Alto | Producción ciega = bug fixing imposible |
| R9 | CI básico (GitHub Actions): `flutter analyze`, `flutter test`, build APK debug; bloquear merge si falla | S | Alto | Sin gate, master se rompe en semana 2 |
| R10 | Eliminar branding WhatsApp si canal real es Telegram (`FontAwesomeIcons.whatsapp` en login, sheet "WhatsApp Business" en perfil, paleta verde WhatsApp); o lo contrario | S | Medio | Coherencia + riesgo legal Meta |

**Esfuerzo total estimado REQUERIDO**: 2-3 sprints (4-6 semanas con 1 dev senior).

### 6.2 OPCIONAL — mejora de calidad sin bloquear

| # | Acción | Esfuerzo | Valor |
|---|---|---|---|
| O1 | Extraer un `ThemeData` central + `TextTheme` con escala (`display`/`headline`/`title`/`body`/`label`); migrar los 812 `Color(0xFF…)` → `Theme.of(context).colorScheme.X` | L | Alto |
| O2 | Romper los 19 god widgets en componentes (`MetricCard`, `StatusPill`, `OrderListItem`, `KanbanTab`, `BaseBottomSheet`, etc.); meta: ningún archivo > 300 LOC | L | Alto |
| O3 | Mover HTTP de Providers a `RemoteDataSource` dentro de Repositories; Providers solo orquestan estado | M | Alto |
| O4 | Migrar a `freezed` + `json_serializable` para los 4 modelos | M | Medio |
| O5 | Reemplazar `Timer.periodic(5s)` por **SSE/WebSocket** (`/pedidos/stream`) o push FCM cuando backend lo soporte; agregar `WidgetsBindingObserver` para pausar polling en background | M | Alto |
| O6 | Cachear filtros del `OrderProvider` (recibidos/preparando/etc.) en lugar de recalcular en cada getter | S | Medio |
| O7 | Implementar **tests**: unit para `OrderModel.fromJson`/`copyWith`, providers (con mock repo), 2-3 widget tests críticos (login, dashboard, inventario) | M | Alto |
| O8 | Cifrar cache local sensible (clientes, teléfonos, direcciones) — `hive` con encryption o `flutter_secure_storage` para datos PII | M | Medio |
| O9 | Reemplazar OAuth Google/Facebook mock por implementación real (`google_sign_in`, `flutter_facebook_auth`), o eliminar botones | S | Bajo |
| O10 | `analysis_options.yaml` con `very_good_analysis` o lint set estricto; pre-commit hook (`lefthook`) | S | Medio |
| O11 | i18n con `intl`: extraer strings ES a `arb`; preparar para multi-país | M | Bajo |
| O12 | `cached_network_image` cuando entren imágenes de productos | S | Bajo |
| O13 | Implementar `RF-05` (impresión Bluetooth/ESC-POS) cuando backend dispare push | L | Alto |
| O14 | Implementar `RF-08` (modificación con tiempo de gracia) con lock optimista server-side | L | Medio |

### 6.3 FUTURO — documentar, no ejecutar ahora

| # | Acción | Cuándo |
|---|---|---|
| F1 | Migrar de `provider` a `riverpod` 2.x (mejor testabilidad, code-gen, scope automático) | Cuando equipo crezca > 3 devs |
| F2 | Reemplazar polling por arquitectura event-driven (Kafka consumer en backend → WebSocket al móvil) | Cuando backend implemente Kafka (doc lo prevé) |
| F3 | Modo dark | Cuando O1 (theme) esté listo |
| F4 | Multi-tenancy real: estructura `BusinessModel` cargado en sesión, todas las strings de UI provenientes de `business.*` | Cuando se firme el primer cliente |
| F5 | Code Connect Figma↔Flutter para mantener trazabilidad automática | Cuando O1+O2 estén listos |
| F6 | Análisis SAST en CI (semgrep, `dependabot`) | Después de R9 |
| F7 | E2E tests con `patrol` o `integration_test` | Después de O7 |
| F8 | Soporte offline-first robusto (queue de mutaciones, sync diferencial) | Si MiPymes operan con conectividad inestable |

---

## 7. Arquitectura target propuesta

### 7.1 Estructura de carpetas recomendada

```
lib/
├── main.dart                          # bootstrap mínimo
├── app/
│   ├── app.dart                       # ProntoApp widget root
│   ├── router.dart                    # go_router + guards por rol
│   ├── theme/                         # ThemeData, TextTheme, color tokens
│   └── di.dart                        # inyección (GetIt o Riverpod providers raíz)
├── core/
│   ├── constants/                     # app_colors, app_dimensions, app_strings
│   ├── network/                       # ApiClient (Dio), interceptors (auth, log, retry)
│   ├── storage/                       # SecureStorage, PrefsService
│   ├── errors/                        # Failure sealed class, ErrorMapper
│   ├── logger/                        # Sentry + logger wrapper
│   └── widgets/                       # Botones, inputs, modales BASE reusables
├── data/
│   ├── models/                        # freezed + json_serializable
│   │   ├── order/
│   │   ├── product/
│   │   └── user/
│   ├── datasources/
│   │   ├── remote/                    # *_remote_datasource.dart (HTTP)
│   │   └── local/                     # *_local_datasource.dart (Hive/Prefs)
│   └── repositories/                  # Combina remote + local, retorna Either<Failure, T>
├── domain/                            # (opcional, si se va Clean Arch)
│   ├── entities/                      # Pure Dart, sin Flutter
│   └── usecases/                      # Un caso de uso = una clase
└── features/
    ├── auth/
    │   ├── providers/                 # state providers Riverpod
    │   ├── screens/
    │   └── widgets/
    ├── manager/   (sub-features: dashboard, kpis, inventory, team, settings)
    ├── kitchen/
    └── delivery/

test/
├── unit/                              # modelos, providers, usecases
├── widget/                            # screens críticos
└── integration/                       # flows end-to-end
```

**Justificación**:
- `core/network/ApiClient` con interceptors → JWT + retry + logging centralizados (resuelve issues #1, #5, #8, #11).
- `datasources/remote` separados de `datasources/local` → resuelve issue #11 (HTTP brincando repo) y desbloquea testabilidad.
- `core/widgets` con `BaseBottomSheet`, `BaseButton`, `BaseCard` → mata duplicación (issue #17).
- `app/theme` central → resuelve issue #7 (812 colores raw).
- `domain/` opcional: solo si la complejidad lo justifica. Para una app de gestión, `data/` + `features/` puede bastar.

### 7.2 State management recomendado

**Riverpod 2.x** (no flutter_bloc, no GetX). Justificación:

| Criterio | Provider (actual) | Riverpod | BLoC | GetX |
|---|---|---|---|---|
| Tamaño equipo (3-5 devs MiPyme) | OK | ✓✓ | OK (curva alta) | ✗ (anti-patrón comunidad) |
| Complejidad real (CRUD + polling + auth) | Marginal | ✓✓ | Overkill | — |
| Curva aprendizaje | Baja (ya usado) | Media (similar a Provider) | Alta | Baja pero deuda alta |
| Testabilidad | Mala | ✓✓ Excelente | Excelente | Mala |
| Code generation | No | ✓ (Riverpod Generator) | ✓ | No |
| Compatibilidad con código actual | ✓ | ✓ (mismo modelo mental) | ✗ rewrite | ✗ rewrite |
| Soporte de scopes/auto-dispose | Manual | ✓ Automático | Manual | Manual |

**Migración recomendada**: NO rewrite. Comenzar con un solo feature (Auth) en Riverpod; coexistir con `provider` en el resto. Migrar feature por feature.

Si el equipo siente que Provider 6.x cubre + el riesgo de migrar no se compensa, **mantener Provider** es defendible. La condición es: **establecer convención escrita** (Selector<T,R> en lugar de Consumer<T>; nada de `Provider.of(context, listen:true)` profundo; nada de singletons paralelos como `AuthService._instance`).

### 7.3 Quick wins (< 1 sprint cada uno)

| QW | Acción | Resultado en una semana |
|---|---|---|
| **QW1** | R1 + R3 + R4 (rotar secreto, parametrizar URL, remover SnackBar credenciales) | App compilable en build "real" + secret out of repo |
| **QW2** | O1 paso 1: cargar todos los strings de color de pantallas top-5 al `AppColors`; meta: reducir `Grep Color\(0xFF` de 812 a < 200 | Theme migration arrancado, modo dark factible |
| **QW3** | R8 + R9 (Sentry + CI básico) | Producción observable + gate de calidad |

### 7.4 Lo que NO deberías cambiar todavía (anti over-engineering)

- **NO** migrar a Clean Architecture estricta (`domain/` usecases) — sobre-ingeniería para 5k DAU. Repository + Provider basta.
- **NO** introducir BLoC — equipo no lo necesita; switch costo > beneficio.
- **NO** romper `provider` antes de estabilizar auth y secrets. Refactor de state mgmt sobre auth rota = caos.
- **NO** internacionalizar (`intl`) hasta que firmen primer cliente fuera de Colombia. Strings ES por ahora bastan.
- **NO** implementar modo dark hasta que O1 (tema centralizado) esté hecho.
- **NO** reescribir los modelos a `freezed` antes de auth/seguridad — es deuda fría, no caliente.
- **NO** integrar POS (RNF-06) hasta que el flujo gerente↔cocinero↔repartidor esté estable end-to-end con backend real.

---

## 8. Métricas de éxito (validación a 3 meses)

| Métrica | Hoy | Meta 3 meses | Cómo se mide |
|---|---|---|---|
| Secret hardcoded en repo | 1 (sha del token) | 0 | `git grep '83c58120'` retorna vacío en `main`; `gitleaks` en CI |
| Auth contra backend con JWT | No | Sí | Login emite request a `/auth/login`, recibe JWT, lo guarda en `flutter_secure_storage` |
| Cobertura de tests (líneas) | ~0% | ≥ 30% | `flutter test --coverage` + `lcov` |
| God widgets (archivos > 400 LOC) | 19 | ≤ 8 | `find lib -name '*.dart' \| xargs wc -l \| awk '$1>400'` |
| Colores literales `Color(0xFF…)` | 812 | ≤ 100 | `Grep` count |
| LOC en `editar_perfil_modals.dart` | 1065 | ≤ 350 | `wc -l` |
| CI green rate en `main` | n/a | ≥ 95% | GitHub Actions stats |
| Crash-free rate en producción | n/a | ≥ 99% | Sentry/Crashlytics |
| Tiempo medio sync `/pedidos` p95 | n/a | ≤ 2s | Sentry transactions |
| `flutter analyze` errores | n/a | 0 | CI gate |
| Doc `formulacion-proyecto.md` actualizado (stack, canal, rol cocinero) | No | Sí | Diff visible + ADRs en `docs/adr/` |
| Trazabilidad Figma↔código (Code Connect o referencias) | Parcial (4 nodos) | Cobertura ≥ 80% pantallas | Auditoría manual |
| Build prod APK firmado | No factible | Sí | Pipeline `release` corre |

---

## 9. Pendientes para próxima sesión

### 9.1 Fase 4 (Figma) — ✅ COMPLETADA (sesión 2026-05-11)

Resultado: ver **Sección 10** abajo. Lo que sigue debajo (9.2–9.4) refleja el plan original; los ítems Figma puros ya fueron ejecutados.

### 9.2 Tareas concretas a ejecutar con Figma MCP vivo

1. `get_metadata(file-key)` → confirmar nombre del archivo, frames principales, page count.
2. Para cada pantalla listada en sección 3.3, hacer `get_code` o `get_image` y comparar 1:1 con código.
3. `get_variable_defs(file-key)` → extraer **design tokens** oficiales (colors, typography, spacing) y compararlos contra `core/constants/app_colors.dart`. Determinar si hay tokens en Figma que no están en código (gap).
4. Resolver los 4 node IDs ya referenciados en `editar_perfil_modals.dart`: `2234:887`, `2234:536`, `2234:624`, `2234:703`.
5. Verificar si Figma define componentes reusables (`MetricCard`, `BottomSheet`, `Tab`, `Chip`, `OrderCard`) — si sí, identificar duplicación en código que debería instanciar el componente.
6. Detectar pantallas en Figma que **no** existen en código (gap inverso) — posibles features pendientes.
7. Detectar pantallas en código que **no** existen en Figma (improvisaciones del dev).
8. Confirmar branding: ¿logo en Figma usa ícono WhatsApp o algo distinto?
9. Confirmar si Figma incluye **modo dark** (si sí, app debería soportarlo).
10. Confirmar si Figma incluye flujos de **Cocinero** (validar si el rol nuevo está diseñado o improvisado).

### 9.3 Validaciones externas pendientes (requieren al owner)

| # | Validar | A quién preguntar |
|---|---|---|
| V1 | ¿El backend FastAPI vive en repo separado? ¿Tiene Kafka, Redis, S3 implementados según doc? | Equipo backend |
| V2 | ¿La decisión Telegram vs WhatsApp es definitiva? ¿Por qué se cambió? | Product / fundador |
| V3 | ¿El rol "Cocinero" fue aprobado por stakeholders o se agregó sin formalizar? | Product |
| V4 | ¿Se planea publicar el target `web/` de Flutter? Si sí, los secrets son inviables ahí | Tech lead |
| V5 | ¿Está bien que el doc de formulación quede desactualizado o requiere re-aprobación académica/comercial? | Owner + tutor del documento |
| V6 | ¿Se compró WhatsApp Business API (Meta) o Telegram? Verificar costos reales vs financiero del doc | Finanzas |
| V7 | ¿Existe POS objetivo concreto para RNF-06 o es genérico? | Product |

### 9.4 Próximos pasos sugeridos al re-entrar a sesión

1. Confirmar V1–V7 con el owner.
2. Completar Fase 4 (Figma) con MCP vivo.
3. Crear ADRs en `docs/adr/`:
   - `0001-flutter-multi-platform.md`
   - `0002-telegram-vs-whatsapp.md`
   - `0003-rol-cocinero.md`
   - `0004-auth-jwt-backend.md`
   - `0005-state-management.md` (provider vs riverpod decision)
4. Abrir issues en GitHub para cada item REQUERIDO (R1–R10).
5. Arrancar QW1 (rotar secreto) en una rama dedicada `chore/secrets-cleanup`.

---

## 10. Fase 4 — Auditoría Figma (sesión 2026-05-11)

> **File auditado**: `https://www.figma.com/design/fPFAUoRJyEbEXrQfHg1JNp/ProntoApp-`
> **Método**: Figma MCP (`get_metadata`, `get_design_context`, `get_variable_defs`, `get_screenshot`, `get_libraries`).
> **Cobertura**: 65 top-level frames mapeados. 7 screenshots descargados a `.codeviz/figma_shots/`. Metadata XML serializado a `.codeviz/figma_metadata.xml` (573 KB, 7953 líneas).

### 10.1 Hallazgos principales

| # | Hallazgo | Severidad | Detalle |
|---|---|---|---|
| F1 | **Figma file NO suscribe ningún design system library** | **ALTA** | `libraries_added_to_file: []`. Lista de bibliotecas comunes (Material 3, iOS 26, SDS) está *available_to_add* pero **0 adoptadas**. Confirma diseño 100% ad-hoc — coherente con los 812 colores literales del audit. |
| F2 | **Figma no tiene Variables Collection** | **ALTA** | `get_variable_defs(root) → {}`. Los tokens existen sólo como CSS custom properties locales (`--color/azure/11`, etc.) en el código exportado, no en la colección formal de variables de Figma. Por eso `app_colors.dart` no puede sincronizarse automáticamente. |
| F3 | **Branding Figma = WhatsApp confirmado al 100%** | **CRÍTICA** | Landing dice "Automatiza tus pedidos de **WhatsApp**" + stats "31K+ Negocios, <5min Respuesta, 52% Adopción IA"; Login muestra ícono WhatsApp; Dashboard order cards dicen "vía **WhatsApp**"; existe `Pop 05 — WhatsApp Business` con QR de reconexión multi-sesión. **El código usa Telegram (`tg:12345678`). Mismatch CRÍTICO entre diseño y código.** |
| F4 | **Tokens de color WhatsApp extraídos** | INFO | Gradient brand `#25D366 → #128C7E` (Mountain Meadow → Surfie Green) coincide con `app_colors.dart:5`. Otros tokens detectados: azure/11 `#0F172A`, azure/27 `#334155`, azure/65 `#94A3B8`, grey/91 `#E2E8F0`, grey/96 `#F1F5F9`, grey/98 `#F8FAFC`, grey/46 `#757575`. Tipografía: Inter (400/600/800) + Font Awesome 5 Solid (`` lock, `` eye, `` check, `` shield, `` key). |
| F5 | **Rol Cocinero está DISEÑADO en Figma — no fue improvisación del dev** | INFO | 5 frames dedicados: `01 — Cola de Pedidos`, `02 — Pedido en Preparación`, `03 — Pedidos Listos`, `04 — Perfil Cocinero`, `01 — Landing - KITCHEN VERSION`. BottomNav propio (4 tabs: Cola/En curso/Listos/Perfil). **Esto invalida la suposición del audit anterior** de que Cocinero era scope creep no documentado — el diseño existe. Sigue siendo gap **vs el documento de formulación** (donde Cocinero no aparece). |
| F6 | **NO existe modo dark en Figma** | INFO | 0 frames con "dark" / "theme" / "night" en el nombre. La app puede ignorar dark mode sin gap respecto al diseño. |
| F7 | **Feature "Agente IA" SÍ está implementada en código** (corrige hipótesis previa del audit) | INFO | Figma tiene `07-0-3-01 — Agente IA · Plantillas y Modelos` (selector multi-LLM: GPT-4o Mini, GPT-4o, Claude Haiku, Gemini + 4 plantillas: Tomador de Pedidos, Atención al Cliente, Ventas, Chef Virtual) y `07-0-3-02 — Agente IA · Contexto Personalizado`. **Existen ambos en código**: `manager/screens/agentes_ia_screen.dart` (374 LOC), `agente_ia_contexto_screen.dart` (285 LOC), `widgets/configurar_agente_modal.dart` (354 LOC = 1013 LOC totales). **El audit original se equivocó** asumiendo que era feature solo-Figma. Pendiente validar si la lógica conecta a backend real o es stub visual. |
| F8 | **3 versiones de flujo Auth en Figma** (Manager + Kitchen + Delivery) **vs 1 en código** | MEDIA | Frames `237:95` (Landing Manager), `2287:261` (Landing KITCHEN VERSION), `2287:770` (Landing DELIVERY VERSION) son **visualmente idénticos** entre sí. Lo mismo para Login (237:177 / 2287:199 / 2287:708) y Registro (237:258 / 2287:128). El código tiene 1 solo `landing_page.dart` compartido. **Decisión del dev fue correcta** (DRY) salvo que diseñador quiera onboarding diferenciado por rol — pendiente validar con product. |
| F9 | **Pop 01 (Editar Correo) y Pop 02 (Editar Teléfono)** existen en Figma + código | INFO | `editar_perfil_modals.dart:6` `showEditarCorreo`, línea 30 `showEditarTelefono`. No estaban anotados con node IDs Figma (a diferencia de Pop 03–06). Recomendable anotar para trazabilidad. |
| F10 | **Pop 10/11 Login con Google/Facebook**: OAuth diseñado | MEDIA | Frames `2234:1296` (Google) y `2234:1421` (Facebook). Implementación en `auth/widgets/auth_popup_dialogs.dart` (576 LOC). Como auth actual es 100% local y fake (sección 5 del audit), **estos botones probablemente no conectan a OAuth real**. Verificar. |

### 10.2 Mapa Figma ↔ Código (coverage)

| Figma frame | Node ID | Código | Estado |
|---|---|---|---|
| 01 — Landing | `237:95` | `auth/screens/landing_page.dart` | ✓ implementado |
| 02 — Iniciar Sesión | `237:177` | `auth/screens/login_screen.dart` | ✓ |
| 03 — Registro | `237:258` | `auth/screens/register_screen.dart` | ✓ |
| recuperar contraseña | `2052:71` | `auth/screens/recover_password_screen.dart` | ✓ |
| Procesamiento | `2064:82` | `auth/screens/processing_screen.dart` | ✓ |
| Pop 10 — Login Google | `2234:1296` | `auth/widgets/auth_popup_dialogs.dart` | ✓ (stub OAuth — F10) |
| Pop 11 — Login Facebook | `2234:1421` | `auth/widgets/auth_popup_dialogs.dart` | ✓ (stub OAuth — F10) |
| 04 — Dashboard | `237:354` | `manager/screens/dashboard_screen.dart` | ✓ |
| 05 — Pedidos | `237:526` | `manager/screens/orders_screen.dart` | ✓ |
| 06 — KPIs & Analytics | `237:695` | `manager/screens/kpis_screen.dart` | ✓ |
| 07 — Perfil | `237:860` | `manager/screens/profile_screen.dart` | ✓ |
| 08 — Configuración | `237:1022` | `manager/screens/settings_screen.dart` | ✓ |
| Notificaciones | `237:1191` | `manager/screens/notificaciones_screen.dart` | ✓ |
| 07-01 — Equipo | `2256:3079` | `manager/screens/equipo_screen.dart` | ✓ |
| 07-02 — Invitar Empleado | `2256:3245` | `manager/screens/invitar_empleado_screen.dart` | ✓ |
| 07-04 — Invitación Enviada | `2256:3617` | `manager/widgets/invitacion_enviada_modal.dart` | ✓ |
| 07-03 — Perfil Empleado | `2256:3425` | `manager/screens/perfil_empleado_screen.dart` | ✓ |
| 07-02-01 — Inventario | `2256:2242` | `manager/screens/inventario_screen.dart` | ✓ |
| 07-02-02 — Agregar/Editar Producto | `2256:2465` | `manager/screens/agregar_editar_producto_screen.dart` | ✓ |
| 07-02 — Ajustar Stock (popup) | `2256:3029` | `manager/widgets/ajustar_stock_modal.dart` | ✓ |
| 07-0-3-01 — Agente IA Plantillas | `2256:2652` | `manager/screens/agentes_ia_screen.dart` | ✓ (F7) |
| 07-0-3-02 — Agente IA Contexto | `2256:2861` | `manager/screens/agente_ia_contexto_screen.dart` | ✓ (F7) |
| POP-BASICCONFIGIA | `2234:1107` | `manager/widgets/configurar_agente_modal.dart` | ✓ |
| Pop 01 — Editar Correo | `2234:336` | `editar_perfil_modals.dart:6` `showEditarCorreo` | ✓ no anotado (F9) |
| Pop 02 — Editar Teléfono | `2234:460` | `editar_perfil_modals.dart:30` `showEditarTelefono` | ✓ no anotado (F9) |
| Pop 03 — Editar Ubicación | `2234:536` | `editar_perfil_modals.dart:64` | ✓ |
| Pop 04 — Editar Negocio | `2234:624` | `editar_perfil_modals.dart:89,804` | ✓ |
| Pop 05 — WhatsApp Business | `2234:703` | `editar_perfil_modals.dart:99,389` | ✓ |
| Pop 06 — Cambiar Contraseña | `2234:887` | `editar_perfil_modals.dart:54,538` | ✓ |
| Kitchen 01 — Cola Pedidos | `2256:3717` | `kitchen/screens/cola_pedidos_screen.dart` | ✓ |
| Kitchen 02 — Preparación | `2269:1660` | `kitchen/screens/preparacion_screen.dart` | ✓ |
| Kitchen 03 — Listos | `2269:1410` | `kitchen/screens/pedidos_listos_screen.dart` | ✓ |
| Kitchen 04 — Perfil Cocinero | `2256:5256` | `kitchen/screens/perfil_cocinero_screen.dart` | ✓ |
| Kitchen Landing/Login/Reg | `2287:261/199/128` | (compartido con Manager) | ✓ (F8) |
| Delivery 01 — Pedidos | `2256:4338` | `delivery/screens/pedidos_para_entregar_screen.dart` | ✓ |
| Delivery 02 — Detalle | `2256:4521` | `delivery/screens/detalle_entrega_screen.dart` | ✓ |
| Delivery 03 — En Ruta | `2256:4668` | `delivery/screens/en_ruta_screen.dart` | ✓ |
| Delivery 04 — Entrega Confirmada | `2256:4751` | `delivery/widgets/entrega_confirmada_modal.dart` | ✓ |
| Delivery 05 — Mi Día/Perfil | `2256:4833` | `delivery/screens/perfil_repartidor_screen.dart` | ✓ |
| Delivery Landing/Login | `2287:770/708` | (compartido con Manager) | ✓ (F8) |
| Componentes form (Correo-Input, Contraseña-input, etc.) | `39:26 / 61:84 / 2199:55 / 2209:97 / 2287:340 …` | `core/widgets/custom_text_field.dart` (sólo 1 widget reusable — F11) | ⚠ parcial |

**Cobertura agregada**: 30/30 pantallas Figma con contraparte en código. **No hay screens en Figma sin contraparte. No hay screens en código sin Figma.** El gap principal NO es alcance — es **fidelidad de implementación** (812 hex literales, 0 tokens, 0 sincronización de Inter font, ícono lock/eye/check duplicados como widgets en vez de instanciar componentes Figma).

### 10.3 Hallazgo F11 (nuevo): componentes reusables en Figma no son aprovechados

Figma define **al menos 13 componentes reusables** (variantes Property 1=Default/Variant2) que en código fueron implementados ad-hoc en cada screen:

| Componente Figma | Frames con variantes | Equivalente en código |
|---|---|---|
| `Correo-Input` | `39:26` | inline en `login_screen.dart` + `register_screen.dart` |
| `Contraseña-input` | `61:84` | inline (con toggle `Mostrar-contraseña 2091:94`) |
| `Nombre-negocio-input` | `2199:55` | inline en `register_screen.dart` |
| `nombre-input` / `apellido-input` | `2209:97` / `2209:117` | inline |
| `numero-cliente-input` | `2209:136` | inline |
| `confirmar-codigo` | `2129:69` (×2) | `recover_password_screen.dart` |
| `boton-verde` | `62:261` | inline (botón gradient) en N screens |
| `Parpadeo` (cursor blink) | `39:39` | no implementado (la app usa cursor nativo) |

→ Existe **solo un widget reutilizable** (`core/widgets/custom_text_field.dart`). Los demás campos están reimplementados en cada pantalla. Esto explica buena parte de los 19 god widgets >400 LOC.

**Recomendación (REQ-13 a agregar)**: crear `core/widgets/` con `PrimaryButton`, `EmailInput`, `PasswordInput`, `BusinessInput`, `CodeInput`. Cada uno mapea 1:1 a su componente Figma. Reducirá ~30% LOC en screens auth/register.

### 10.4 Recomendaciones nuevas derivadas de Figma

| # | Acción | Prioridad | Justificación |
|---|---|---|---|
| R11 | **Decidir branding definitivo** (WhatsApp vs Telegram) y alinear código + Figma | CRÍTICA | F3. Imposible comercializar con copy/icono WhatsApp y backend Telegram. |
| R12 | **Crear Variables Collection en Figma** con los tokens hardcoded del CSS | ALTA | F2. Habilita sincronización automática con `app_colors.dart` (script de generación). |
| R13 | **Componentizar inputs/buttons** en `core/widgets/` siguiendo F11 | ALTA | F11. Cierra deuda de 19 god widgets y duplicación. |
| R14 | **Anotar Pop 01/02 con node IDs Figma** en `editar_perfil_modals.dart:6,30` | BAJA | F9. Cierra trazabilidad. |
| R15 | **Validar OAuth Google/Facebook**: implementar real o eliminar botones de los modales | MEDIA | F10. Hoy es teatro UI sin lógica. |
| R16 | **Adoptar Material 3 Design Kit** (o SDS) en Figma como base | BAJA | F1. Reduce trabajo de mantener tokens manuales; obtiene a11y / states gratis. |
| R17 | **Validar profundidad real de `agente_ia_*` screens** | ALTA | F7. ¿Llaman API real LLM o son stubs? Si real → revisar costos / secrets management / vendor lock. |

### 10.5 Estado tras Fase 4

- **Pantallas con contraparte en código**: 30/30 ✓
- **Tokens sincronizados Figma → Dart**: 0 / ~25 (gap total)
- **Componentes Figma instanciados como widgets reusables**: 1 / ~13 (gap 92%)
- **Dark mode**: no diseñado, no implementado (sin gap)
- **Branding**: WhatsApp en Figma, Telegram en código → **gap CRÍTICO sin resolver**
- **Variables Collection Figma**: vacía

Validaciones V1–V7 (sección 9.3) siguen pendientes — la inspección Figma no las resuelve, pero F5 da evidencia parcial para V3 (rol Cocinero está formalmente diseñado, no improvisado).

---

## 11. Validaciones de código (sesión 2026-05-11, post-Figma)

> Validaciones ejecutadas directamente sobre `lib/` para confirmar/refutar los hallazgos críticos del audit + sección 10. No requieren input de owner.

### 11.1 V-F7 — Agente IA: **TEATRO UI confirmado** (gap CRÍTICO)

Inspección de `lib/features/manager/screens/agentes_ia_screen.dart` (374 LOC):

| Aspecto | Figma | Código | Veredicto |
|---|---|---|---|
| Modelos LLM ofrecidos | 4 (GPT-4o Mini, GPT-4o, Claude Haiku, Gemini) | **1 sólo**: "DeepSeek · Bot de Telegram" (lista hardcoded línea 19-21) | ❌ regresión |
| Plantillas | 4 (Tomador Pedidos, Atención Cliente, Ventas, **Chef Virtual**) | 4 (Tomador Pedidos, Asesor Ventas, Seguimiento Entrega, Atención Cliente) — **"Chef Virtual" ausente**, otras renombradas | ❌ desincronizado |
| Activación de plantilla | (UI muestra "ACTIVO" toggle) | `setState(() { p['activo'] = false; ... plantilla['activo'] = true; })` línea 305-313 — mutación local de Map, **0 llamadas a backend** | ❌ teatro |
| "Conectada / ACTIVO" indicator | toggle real | Reusa `OrderProvider.estaConectado` (estado del polling de pedidos, no de un agente IA) | ❌ proxy falso |
| "interacciones hoy" | métrica real | `orderProvider.pedidos.length` línea 94 — **cuenta pedidos, no interacciones LLM** | ❌ métrica falsa |
| LLM SDK / API key | (no aplica) | **0 packages** en `pubspec.yaml`: no `openai`, no `anthropic`, no `google_generative_ai`, no `dio`. Sólo `http: ^1.2.2` genérico. | ❌ sin infra |

**Conclusión**: `agentes_ia_screen.dart` + `agente_ia_contexto_screen.dart` + `configurar_agente_modal.dart` son **1013 LOC de UI con cero integración real**. Cierra R17 con respuesta concreta: **el agente IA NO existe**, sólo su pantalla.

**Riesgo añadido**: Figma promete "31K+ Negocios, 52% Adopción IA". Marketing miente si demo se basa en este código.

### 11.2 V-F10 — OAuth Google/Facebook: **TEATRO UI confirmado**

Inspección de `lib/features/auth/widgets/auth_popup_dialogs.dart` (576 LOC):

```dart
// auth_popup_dialogs.dart:142-148
Text('Carlos Mendoza', …),
Text('carlos.mendoza@gmail.com', …),  // ← cuenta HARDCODED
// línea 260-262: botón "Autorizar con Google"
onPressed: () {
  Navigator.pop(context);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()));
},
```

- Cuenta "Carlos Mendoza · carlos.mendoza@gmail.com" hardcoded.
- "Autorizar con Google" → `Navigator.pushReplacement(ProcessingScreen)`. **No llama Google Sign-In API.**
- `pubspec.yaml` no incluye `google_sign_in`, `flutter_facebook_auth`, `firebase_auth`, `firebase_core`.

**Conclusión**: F10 confirmado al 100%. Los modales de OAuth son demo visual. **Acción R15**: eliminar botones o implementar real (alta: usuario percibirá UX rota al primer intento).

### 11.3 V-QW1 — Secret hardcoded: **EN HEAD + EN HISTORY**

```
$ git log --all --oneline -S '83c58120'
5aa4e39 feat(inventory): hacer el inventario dinámico, editar productos, borrar mock y descontar stock automáticamente
ace9b69 chore: estabilizar mvp local antes de integrar frontend
1061525 feat(pedidos): integrar bot telegram con deepseek, fastapi y flutter
```

- Secret `83c58120a0a140ade0282b37ff64731f3fdd3f7dc306be3151ec62e967b43f43` (64 hex chars = SHA256 / API token).
- Introducido en `1061525` (commit Telegram + DeepSeek + FastAPI). Refactorizado en `5aa4e39`.
- Presente actualmente en `lib/main.dart:39,47`.
- **Repo aún privado** según `pubspec.yaml:5` (`publish_to: 'none'`), pero igual debe rotarse antes de cualquier push público.

**Acción QW1 (revisada)**:
1. Rotar secreto en backend FastAPI.
2. Mover a `--dart-define` o `flutter_dotenv` (agregar package).
3. Reescribir history con `git filter-repo --replace-text` antes de hacer público.
4. Crear `.env.example` documentando variables.

### 11.4 V-Polling — HTTP plano en localhost (confirmado)

```
lib/data/providers/order_provider.dart:34   _intervaloPoll = Duration(seconds: 5)
lib/data/providers/order_provider.dart:146  Timer.periodic(_intervaloPoll, sincronizar)
lib/data/providers/inventory_provider.dart:38 Timer.periodic(Duration(seconds: 5), _fetchDelServidor)
lib/main.dart:38,46  baseUrl: 'http://localhost:5050'  ← HTTP, no HTTPS
```

- 2 timers de 5s independientes (12 req/min cada uno = 24 req/min al backend cuando app abierta).
- 3 calls HTTP en `order_provider.dart` con `timeout(4s)`. Sin retry/backoff exponencial.
- Sin auth header (revisar si secreto va por header o query — leer `_fetchDelServidor`).

**Riesgo**: en producción Android (sin `cleartextTrafficPermitted=true`), HTTP plano será rechazado por la plataforma desde API 28+. iOS bloquea ATS por default. **Bloqueador deployment**.

### 11.5 V-F11 — Componentización: **24 inputs duplicados** (cuantificado)

```
$ grep -rn "TextField\(\|TextFormField" lib/features → 24 ocurrencias en 11 archivos
$ grep -rln "CustomTextField" lib → 2 archivos (1 import + 1 uso real)
$ grep -rn "LinearGradient(.*primary|0xFF25D366" lib/features → 23 ocurrencias en 16 archivos
```

- `CustomTextField` (`lib/core/widgets/custom_text_field.dart`) es importado en `login_screen.dart`. **Otros 10 archivos importan TextField/TextFormField directamente sin usarlo**.
- Botón primary verde con gradient WhatsApp: **23 implementaciones inline en 16 archivos**.

**Magnitud**: si se completara R13 (PrimaryButton + EmailInput + PasswordInput + CodeInput + BusinessInput), se reducirían ~47 sites duplicados → ~5 widgets. Estimación impacto: -800 a -1200 LOC en screens auth/register/perfil/manager.

### 11.6 Resumen veredictos sección 11

| Hallazgo | Estado tras validación | Acción asociada |
|---|---|---|
| F7 — Agente IA real | ❌ TEATRO (1013 LOC sin integración LLM) | R17 → upgrade a CRÍTICA |
| F10 — OAuth real | ❌ TEATRO (sin packages, cuenta hardcoded) | R15 → ALTA |
| QW1 — Secret rotado | ❌ en HEAD + 3 commits | rotar + dotenv + filter-repo |
| F12 — Polling HTTPS/secure | ❌ HTTP plano, localhost, 5s sin backoff | bloqueador deploy mobile |
| F11 — Componentes reusables | ❌ 24 inputs + 23 botones duplicados | R13 → confirmado scope |

**Implicación tablero de riesgos**: 4 de 5 validaciones empeoran la calificación previa. El proyecto está **más lejos** de producción de lo que el audit original sugería: no sólo el documento de formulación está desactualizado — la app también muestra features que no existen (Agente IA, OAuth multi-cuenta, multi-modelo LLM).

---

## Anexos

### A. Comandos útiles para revalidar hallazgos

```powershell
# LOC total efectiva
Get-ChildItem -Path lib -Recurse -Include *.dart | Get-Content | Where-Object { $_ -notmatch '^\s*$' -and $_ -notmatch '^\s*//' } | Measure-Object -Line

# God widgets (archivos > 400 líneas)
Get-ChildItem -Path lib -Recurse -Include *.dart | ForEach-Object { [PSCustomObject]@{ Lines = (Get-Content $_).Count; File = $_.FullName } } | Where-Object { $_.Lines -gt 400 } | Sort-Object Lines -Descending

# Colores literales
(Select-String -Path lib\**\*.dart -Pattern 'Color\(0xFF' -AllMatches).Matches.Count

# Detectar secret restante en repo
git grep '83c58120'
```

### B. Cambios de archivos en esta sesión

- **Creado** (sesión 1, audit base): `docs/ARCHITECTURE_REVIEW.md` (este documento, secciones 1–9 + anexos).
- **Actualizado** (sesión 2, 2026-05-11 Fase 4 Figma): Sección 9.1 marcada COMPLETADA + agregada **Sección 10** (Auditoría Figma) con 11 hallazgos (F1–F11) y 7 recomendaciones nuevas (R11–R17).
- **Actualizado** (sesión 2, 2026-05-11 validaciones código): agregada **Sección 11** con 5 validaciones (V-F7, V-F10, V-QW1, V-Polling, V-F11) que confirman teatro UI en Agente IA + OAuth, secret aún en history, y cuantifican duplicación de componentes.
- **Artefactos auxiliares** (gitignorados — viven en `.codeviz/`):
  - `.codeviz/figma_metadata.xml` — XML de 65 frames del file Figma (573 KB).
  - `.codeviz/figma_shots/*.png` — 7 screenshots de pantallas clave para evidencia visual.
- **Sin modificaciones de código** (auditoría de solo-lectura).

### C. Referencias clave del código

| Tema | Archivo:Línea |
|---|---|
| Secret hardcoded | `lib/main.dart:39,47` |
| Passwords plaintext | `lib/data/services/auth_service.dart:32-46,86-87` |
| Telegram (no WhatsApp) | `lib/data/models/order_model.dart:138`, `lib/data/providers/inventory_provider.dart:12-14` |
| Login leak credenciales | `lib/features/auth/screens/login_screen.dart:61` |
| Branding WhatsApp | `lib/features/auth/screens/login_screen.dart:148`, `lib/core/constants/app_colors.dart:5` |
| Polling 5s | `lib/data/providers/order_provider.dart:34`, `lib/data/providers/inventory_provider.dart:38` |
| Optimistic write sin rollback | `lib/data/providers/order_provider.dart:243-248` |
| Trazabilidad Figma | `lib/features/manager/widgets/editar_perfil_modals.dart:54,64,89,99` |
| Auth singleton + ChangeNotifier | `lib/data/services/auth_service.dart:7-9` |
| HTTP brincando repo | `lib/data/providers/order_provider.dart:151-215` vs `lib/data/repositories/order_repository.dart` |

---

**Fin del documento.**
