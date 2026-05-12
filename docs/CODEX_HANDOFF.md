# ProntoApp — Codex Handoff

> **Audiencia**: agente Codex (OpenAI) que tomará el proyecto a continuación.
> **Fecha de corte**: 2026-05-11 · **Branch**: `main` · **Commit base**: `cfbc342`
> **Auditor previo**: Claude Opus 4.7 (sesiones 1+2, ver `docs/ARCHITECTURE_REVIEW.md` para detalle).
> **Tipo**: contexto operativo + plan prescriptivo. **No es marketing**, es ground truth.

Este documento existe para que Codex pueda empezar a trabajar sin re-derivar contexto. Léelo antes de tocar código.

---

## 0. TL;DR (60 segundos)

- **Qué es Prontoa!**: app Flutter (Android+iOS+Web) para 3 roles internos de un restaurante (gerente / cocinero / repartidor) que recibe pedidos vía un canal de mensajería + agente IA, los procesa y entrega.
- **Estado real**: ~17.500 LOC Dart, **30 pantallas funcionales**, cobertura visual Figma↔código 30/30, pero **NO desplegable a producción**. Hay 5 bloqueadores hard antes de release.
- **Documento de formulación mintió**: stack es Flutter, no HTML/JS+React. Canal en el código es **Telegram**, Figma promete **WhatsApp**. Decidir cuál antes de cualquier deploy.
- **Hallazgos críticos**: Agente IA es teatro UI (sin SDK LLM), OAuth Google/Facebook es teatro, secret hardcoded en repo, HTTP plano sin permisos Android, auth con passwords plaintext.
- **Trabajo bien hecho**: estructura feature-first sólida, OrderProvider/InventoryProvider con polling+cache decente, fidelidad visual alta.
- **Próximos pasos**: ver §6 (priorizado P0/P1/P2).

---

## 1. Arquitectura — qué hay realmente

### 1.1 Stack

```yaml
Dart SDK: ^3.11.3
Flutter: usa Material 3 (useMaterial3: true en main.dart:74)
Plataformas: Android + iOS + Web
Estado: provider 6.1.5 + ChangeNotifier (mezclado con setState local)
Storage local: shared_preferences 2.5.5 (passwords y sesión en CLARO)
HTTP: http 1.2.2 (sin retry/backoff)
Fonts: google_fonts 8.0.2 (carga Inter on-demand)
Icons: font_awesome_flutter 11.0.0 + 4 SVGs locales (assets/icons/)
Lints: flutter_lints 6.0.0 (default, sin custom)
```

**Packages AUSENTES que la app necesitará pronto**:
- `flutter_secure_storage` (rotar shared_preferences sensible)
- `flutter_dotenv` (mover secret)
- `intl` (formato fechas y moneda — hoy todo manual)
- `google_sign_in` + `flutter_facebook_auth` o `firebase_auth` (OAuth real)
- `cached_network_image` (cuando se sirvan imágenes reales)
- `freezed` + `json_serializable` (los 4 modelos hacen fromJson/toJson a mano)
- `go_router` (rutas con guardias por rol)
- `sentry_flutter` o `firebase_crashlytics` (telemetría)
- `firebase_messaging` (push notifications — hoy las notifs viven en memoria sin persistir)

### 1.2 Layout del repo

```
lib/
├── main.dart                    # bootstrap MultiProvider + MaterialApp
├── app/routes.dart              # 7 rutas estáticas + role-based home
├── core/
│   ├── constants/app_colors.dart   # 27 named colors (paleta WhatsApp + Slate + AI violet + status)
│   └── widgets/custom_text_field.dart   # ← único widget reusable, usado SÓLO en login_screen
├── data/
│   ├── models/
│   │   ├── order_model.dart       (OrderModel + EstadoPedido + TipoPedido)
│   │   ├── product_model.dart
│   │   ├── category_model.dart
│   │   └── user_model.dart        (UserModel + RoleType: gerente/cocinero/repartidor)
│   ├── providers/
│   │   ├── order_provider.dart       (286 LOC, polling 5s, fallback cache)
│   │   ├── inventory_provider.dart   (143 LOC, polling 5s, PUT en cada update)
│   │   └── notification_provider.dart (97 LOC, IN-MEMORY no persiste)
│   ├── repositories/
│   │   ├── order_repository.dart      (cache SharedPreferences)
│   │   └── inventory_repository.dart  (cache + CRUD local)
│   └── services/
│       └── auth_service.dart      (singleton, fake auth, 3 usuarios seed password123)
└── features/
    ├── auth/      5 screens + 2 widgets (landing/login/register/recover/processing + popups)
    ├── kitchen/   5 screens (main + cola + preparación + listos + perfil)
    ├── delivery/  5 screens + 1 widget (main + pedidos + detalle + en_ruta + perfil + modal entrega)
    └── manager/   15 screens + 4 widgets (dashboard, orders, kpis, inventario, equipo, perfil, settings, agente IA, etc.)

assets/icons/  # 4 SVGs: candado, google-color, Icono_prontoaGrande, IconoCorreo
android/app/src/main/AndroidManifest.xml  # ⚠ SIN permisos INTERNET, SIN cleartextTraffic
ios/Runner/Info.plist                      # ⚠ SIN NSAppTransportSecurity
test/widget_test.dart                      # boilerplate Flutter, cobertura 0%
.github/                                    # ❌ NO existe (sin CI/CD)
.env / .env.example                         # ❌ NO existen (secret va hardcoded)
docs/
├── ARCHITECTURE_REVIEW.md  # ← lectura obligada (680 LOC, 11 secciones + anexos)
├── CODEX_HANDOFF.md         # ← este documento
└── formulacion-proyecto.md  # ⚠ DESACTUALIZADO 4 puntos críticos (ver §2)
.codeviz/
├── figma_metadata.xml       # 65 frames Figma serializados (573 KB)
└── figma_shots/             # 7 screenshots de pantallas clave
```

### 1.3 Contrato backend (FastAPI — repo separado, no auditado)

| Método | Endpoint | Header secret | Body | Comportamiento si falla |
|---|---|---|---|---|
| GET | `/pedidos` | `X-Secret: <token>` | — | fallback a SharedPreferences cache |
| PATCH | `/pedidos/{id}/estado` | `X-Secret` + `Content-Type` | `{"estado": "<claveApi>"}` | **update optimista** (cambia local aunque server rechace) |
| DELETE | `/pedidos/{id}` | `X-Secret` | — | delete local-only si server falla |
| GET | `/inventario` | `x-secret: <token>` (⚠ minúsculas) | — | mantiene cache local |
| PUT | `/inventario` | `x-secret` + `Content-Type` | `{categorias:[…], productos:[…]}` | silent fail |

**Estados pedido** (`EstadoPedido` enum):
- `recibido` → `enPreparacion` → `listo` → `enCamino` → `entregado`
- Hay método `.siguiente` que avanza estado linealmente.

**Bug pendiente**: header `X-Secret` vs `x-secret` inconsistente. HTTP es case-insensitive por spec; backend con middleware estricto puede romper.

**Base URL actual**: `http://localhost:5050` (hardcoded en `main.dart:38,46`).

### 1.4 Diagrama flujo notificaciones

```
OrderProvider (timer 5s) → GET /pedidos
  ↓ detecta nuevos IDs estado=recibido
  ↓ ejecuta callback onNewNotification (inyectado vía ChangeNotifierProxyProvider)
NotificationProvider.addNotification → lista in-memory
  ↓ UI Consumer
notificaciones_screen.dart muestra lista
```

Notificaciones se pierden al reiniciar la app (no persisten en SharedPreferences). No hay FCM/push.

---

## 2. Lo que hay que REFORMULAR (gap doc ↔ realidad)

`docs/formulacion-proyecto.md` (~17K líneas) describe un producto que NO coincide con el código actual. Antes de continuar features, alinear:

| Aspecto | Formulación dice | Realidad código | Decisión requerida |
|---|---|---|---|
| **Stack front** | HTML5+JS panel web + React | Flutter móvil (Android/iOS/Web) | reescribir §2.2.2 del doc |
| **Canal mensajería** | WhatsApp Business API (Meta) | Telegram bot (`order_model.dart:138` "tg:12345678") | **decisión de producto** (R11) — bloqueador |
| **Branding visual** | "WhatsApp" en todo el doc | App usa logo WhatsApp + paleta verde WhatsApp pero backend Telegram | si gana Telegram → cambiar logo + paleta + copy |
| **Roles** | 3 actores: Admin / Cliente WhatsApp / Repartidor | 3 roles: Gerente / **Cocinero (NUEVO)** / Repartidor — Cliente excluido (correcto, cliente es externo vía bot) | actualizar §3 actores |
| **Infra** | n8n + Kafka + Redis + S3 + K8s | Sólo `http://localhost:5050` FastAPI mencionado | confirmar si infra existe en backend repo o doc miente |
| **Auth** | RNF-02 "autenticación con roles y encriptación" | Passwords plaintext en `SharedPreferences`, sin hash, sin JWT | implementar JWT real (R-AUTH) |
| **Agente IA** | No mencionado en formulación | 1013 LOC de UI sin backend LLM, Figma diseña 4 modelos | scope creep — formalizar o eliminar |
| **Financiero** | TIR 14.17%, VPN +29M COP, 27 semanas, perfiles DevOps + dev React | Stack distinto → recalcular con costos Flutter + 3 vendors LLM (si Agente IA es real) | Finanzas |

**Acción reformulación**: producir `docs/formulacion-proyecto-v2.md` (o reemplazar el actual) **después** de las decisiones de §6 P0.

---

## 3. Lo que FALTA AGREGAR (features sin implementar)

### 3.1 Funcionales

| ID | Feature | Estado actual | Lo que falta |
|---|---|---|---|
| MISS-01 | Agente IA real (LLM integration) | UI sin backend (1013 LOC teatro) | SDK LLM (anthropic / openai / google_generative_ai), env vars con API keys, llamadas reales desde `agentes_ia_screen.dart`, métricas reales en `OrderProvider.estaConectado` → `AgenteIaProvider.estaConectado` |
| MISS-02 | OAuth Google + Facebook real | Cuenta hardcoded "Carlos Mendoza" en `auth_popup_dialogs.dart` | `google_sign_in` o `firebase_auth`, eliminar mock account |
| MISS-03 | Persistencia notifications | In-memory en `NotificationProvider` | mover a SharedPreferences o backend (`/notifications`) + FCM push |
| MISS-04 | Recuperar contraseña real | UI funcional pero `recover_password_screen.dart` no llama a backend | endpoint `POST /auth/recover-password` + flujo email/SMS |
| MISS-05 | Settings persistencia | 8 toggles en `settings_screen.dart` sólo en memoria (line 17 dice "Mock state for toggles") | SharedPreferences keyed `prontoapp_settings_*` |
| MISS-06 | Multi-sesión WhatsApp Business | Figma lo muestra (Pop 05) con QR reconexión + "3 sesiones activas" | si gana WhatsApp: integrar Meta Business API |
| MISS-07 | Onboarding por rol | Figma tiene Landing-KITCHEN y Landing-DELIVERY diferenciados; código usa landing_page único | preguntar a product si onboarding es por rol |
| MISS-08 | Push notifications | 0 implementación | `firebase_messaging` + setup APNs/FCM |
| MISS-09 | Tests | `widget_test.dart` boilerplate, 0% coverage | unit (models, providers) + widget (componentes core) + integration (login→dashboard) |

### 3.2 No funcionales (DevOps / Operación)

| ID | Item | Falta |
|---|---|---|
| NFR-01 | CI/CD | Crear `.github/workflows/{flutter-ci,android-release,ios-release}.yml` |
| NFR-02 | Crashlytics / Sentry | Capturar errores en `runApp` y providers |
| NFR-03 | Analytics | Eventos de negocio (pedido aceptado, plantilla activada, etc.) |
| NFR-04 | Localización i18n | Hoy todo en español hardcoded; `intl` + `arb` files |
| NFR-05 | A11y | 0 `Semantics`, 0 testing con TalkBack/VoiceOver |
| NFR-06 | Modo dark | Figma no lo diseñó. Decisión: descartar o agregar |
| NFR-07 | Code Connect Figma | Mapear componentes Figma↔widgets (ver `.claude/skills/figma-code-connect`) |

---

## 4. Lo que FALTA CONFIGURAR (build + infra)

### 4.1 Android

`android/app/src/main/AndroidManifest.xml` actualmente NO declara permisos. Agregar:

```xml
<!-- DENTRO de <manifest> ANTES de <application> -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- DENTRO de <application> -->
<!-- Sólo para DEV: permite http://localhost. En prod usar HTTPS y borrar esto -->
android:usesCleartextTraffic="true"
<!-- O preferible: network_security_config para limitar a dominios DEV -->
android:networkSecurityConfig="@xml/network_security_config"
```

Sin INTERNET → release build crashea al primer `http.get`. Sin cleartext → Android 9+ (API 28+) bloquea `http://`.

### 4.2 iOS

`ios/Runner/Info.plist` NO tiene `NSAppTransportSecurity`. ATS bloquea HTTP plano desde iOS 9. Agregar SÓLO para DEV:

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsLocalNetworking</key>
  <true/>
  <!-- O para permitir cualquier HTTP (NO usar en prod): -->
  <!-- <key>NSAllowsArbitraryLoads</key><true/> -->
</dict>
```

### 4.3 Variables de entorno

Hoy `lib/main.dart:38,39,46,47` tiene `baseUrl` + `secreto` hardcoded. Crear:

```
.env.example          # commitable, sin valores reales
.env                  # gitignored, valores locales
.env.production       # CI inyecta
```

Agregar `flutter_dotenv` a `pubspec.yaml`, cargar en `main()`, y usar `dotenv.env['BASE_URL']` + `dotenv.env['API_SECRET']`.

Alternativa más simple: `--dart-define` (no requiere package, va en build flags).

### 4.4 CI/CD (no existe)

Mínimo viable: `.github/workflows/flutter-ci.yml`:
- `flutter pub get`
- `flutter analyze`
- `flutter test`
- Build APK debug

Bonus: release con `fastlane` / Codemagic / Github Actions matrix Android+iOS.

### 4.5 Backend FastAPI (repo separado)

**No auditado** — fuera del alcance de esta sesión. Validaciones pendientes (asks al owner):
- ¿Existe `Dockerfile`? ¿K8s? ¿está deployado?
- ¿El secreto `83c58120…` se valida en backend? ¿con qué middleware?
- ¿Endpoints `/pedidos` y `/inventario` están detrás de auth real o sólo del secret estático?
- ¿Bot Telegram con DeepSeek (commit `1061525`) está vivo? ¿Token rotado?
- Si gana WhatsApp Business: ¿Meta API ya está integrada?

---

## 5. Lo que está MAL (bugs y deuda confirmada)

### 5.1 Bloqueadores de producción (P0)

| ID | Bug | Archivo:Línea | Acción |
|---|---|---|---|
| BUG-01 | Secret API en repo | `lib/main.dart:39,47` (también en commits `1061525`, `ace9b69`, `5aa4e39`) | rotar en backend + `flutter_dotenv` + `git filter-repo --replace-text` antes de hacer público |
| BUG-02 | Passwords plaintext | `auth_service.dart:32,39,46,87,124` (SharedPreferences key `prontoapp_users`) | hash bcrypt/argon2 local **o** mover auth a backend con JWT |
| BUG-03 | HTTP plano sin permisos Android | `AndroidManifest.xml` + `Info.plist` | ver §4.1, §4.2 |
| BUG-04 | Auth 100% local | `auth_service.dart` simula login con `Future.delayed(1s)` | JWT contra backend, refresh tokens, biométrico opcional |
| BUG-05 | Credenciales filtradas en UI | `login_screen.dart:61` muestra `gerente@prontoa.com / password123` en placeholder o subtitle (revisar) | remover hint con creds |

### 5.2 Funcionales y consistencia (P1)

| ID | Bug | Archivo:Línea | Detalle |
|---|---|---|---|
| BUG-06 | Update optimista en PATCH falla silenciosamente | `order_provider.dart:243-248` | si server rechaza, cliente igual cambia estado → desync. Decidir: cola de reintentos o mensaje al usuario. |
| BUG-07 | Header case inconsistente | `order_provider.dart:278` (`X-Secret`) vs `inventory_provider.dart:47,109` (`x-secret`) | normalizar a `X-API-Key` o `Authorization: Bearer …` |
| BUG-08 | Detección de cambios débil en inventario | `inventory_provider.dart:60-70` | sólo compara length+stock+isAvailable, no detecta rename/precio. Usar hash o ETag. |
| BUG-09 | Notifications no persisten | `notification_provider.dart` in-memory | mover a SharedPreferences o backend |
| BUG-10 | Polling 5s × 2 = 24 req/min | `order_provider.dart:34` + `inventory_provider.dart:38` | considerar WebSocket / SSE / FCM en lugar de polling agresivo |
| BUG-11 | Timeout 4s sin retry | `order_provider.dart:158,235,261` | red lenta → falla a cache. Agregar retry con backoff exponencial |
| BUG-12 | Datos hardcoded de demo | "Panadería El Trigo Dorado" en 5 archivos, "Mi Panadería" en `dashboard_screen.dart:69`, "Pedro Naranjo" en perfiles | parametrizar con datos del usuario logueado |
| BUG-13 | Settings no persisten | `settings_screen.dart:17` (comentario `// Mock state for toggles`) | shared_prefs o backend |
| BUG-14 | Branding mixto | `app_colors.dart` paleta WhatsApp + `order_model.dart:138` Telegram | decidir y alinear (R11) |

### 5.3 Calidad interna (P2)

| ID | Deuda | Métrica | Acción |
|---|---|---|---|
| DEBT-01 | God widgets | 19 archivos > 400 LOC (top: `editar_perfil_modals.dart` 1065 LOC) | extraer a sub-widgets |
| DEBT-02 | 24 TextField inline | en 11 archivos, `CustomTextField` usado en 1 sólo | crear `core/widgets/{EmailInput,PasswordInput,CodeInput,…}` |
| DEBT-03 | 23 LinearGradient verde duplicados | en 16 archivos | crear `core/widgets/PrimaryButton` |
| DEBT-04 | 812 colores literales `Color(0xFF…)` | en lib/features | reemplazar por `AppColors.*` |
| DEBT-05 | fromJson/toJson manuales | 4 modelos | adoptar `freezed` + `json_serializable` |
| DEBT-06 | Provider+setState mezclado | varias screens | refactor consistente (provider only) o migrar a Riverpod |
| DEBT-07 | 0% tests | sólo widget_test boilerplate | ver §3.1 MISS-09 |
| DEBT-08 | 0 a11y semantics | global | wrap widgets en `Semantics(label: …)` |
| DEBT-09 | Lints default | `analysis_options.yaml` sólo include flutter_lints | activar `prefer_const_constructors`, `prefer_single_quotes`, `avoid_print`, `require_trailing_commas` |
| DEBT-10 | No `const` agresivo | muchos widgets podrían `const` | run dart fix |

---

## 6. PRÓXIMOS PASOS (priorizado para Codex)

### 6.1 P0 — bloqueadores antes de cualquier deploy

**Estimación total**: 1.5–2.5 semanas dev.

1. **DECISIÓN DE PRODUCTO** (humano, no Codex): **¿WhatsApp o Telegram?** Bloquea todo. Si WhatsApp → comprar Meta Business API + integrarla; si Telegram → cambiar logo `assets/icons/Icono_prontoaGrande.svg`, paleta `app_colors.dart`, copy "Automatiza tus pedidos de WhatsApp" en `landing_page.dart`, screens Figma. **NO empezar P0.2 hasta esto.**

2. **Rotar secret + dotenv**:
   - Branch `chore/secrets-cleanup`.
   - Crear `.env.example`, `.env` (gitignored), agregar `flutter_dotenv: ^5.1.0` a pubspec.
   - Cambiar `main.dart:38-47` para leer de `dotenv.env`.
   - Rotar valor del secret en backend (coordinar con equipo backend).
   - `git filter-repo --replace-text expressions.txt` para limpiar history (sólo si el repo será público).

3. **Permisos Android + ATS iOS**: ver §4.1 y §4.2. Sin esto la app no corre en release.

4. **Auth JWT real**:
   - Borrar 3 usuarios seed con `password123`.
   - Reemplazar `AuthService.login()` con POST `/auth/login` → recibir JWT + refresh.
   - Guardar token en `flutter_secure_storage` (no SharedPreferences).
   - Agregar interceptor en HTTP para `Authorization: Bearer <jwt>`.
   - Remover hint de credenciales en `login_screen.dart:61` (si existe).

5. **Eliminar teatro o implementar real**:
   - **OAuth Google/Facebook** (R15): elegir → integrar `google_sign_in`/`flutter_facebook_auth` o eliminar botones de los modales. No es aceptable mostrar UI que no funciona.
   - **Agente IA** (R17): decidir si la feature es real para el MVP. Si SÍ → integrar SDK LLM + env keys + telemetría; si NO → ocultar tab "Agente IA" del bottom nav del manager.

### 6.2 P1 — funcional consistente

**Estimación**: 1–1.5 semanas dev.

6. **HTTP layer robusto**:
   - Crear `core/network/api_client.dart` con `dio` o `http` + interceptors.
   - Header normalizado: `Authorization: Bearer …` para JWT, `X-API-Key` para secret de servicio.
   - Retry con backoff exponencial (3 intentos).
   - Timeout configurable por env.
   - Convertir `OrderProvider` e `InventoryProvider` a usar `ApiClient`.

7. **Componentización core/widgets**:
   - `PrimaryButton` (gradient WhatsApp + sólido + estados loading/disabled).
   - `EmailInput`, `PasswordInput` (con visibility toggle), `CodeInput`, `BusinessInput`.
   - `MetricCard` (las 4 cards del dashboard).
   - `OrderCard` (la card de pedido del dashboard/orders).
   - Refactorizar al menos `login_screen.dart`, `register_screen.dart`, `dashboard_screen.dart`, `editar_perfil_modals.dart` (top god widgets).
   - Resultado esperado: -800 a -1200 LOC totales.

8. **Persistencia de configuración + notificaciones**:
   - Settings: 8 toggles → SharedPreferences keys `settings.notifications.newOrders`, etc.
   - Notifications: SharedPreferences key `prontoapp_notifications` con TTL 30 días.

9. **Resolver BUGS 06–14** (ver §5.2).

### 6.3 P2 — calidad + escalabilidad

**Estimación**: 2–3 semanas dev.

10. **Tests**:
    - Unit: 80% de `models/` + `providers/` + `repositories/`.
    - Widget: cada widget de `core/widgets/`.
    - Integration: golden path (login gerente → dashboard → aceptar pedido → cambiar estado).

11. **Migración a freezed + json_serializable** (DEBT-05).

12. **Lints estrictos** + dart fix global (DEBT-09, DEBT-10).

13. **Modo dark** (NFR-06) — sólo si producto lo pide.

14. **i18n** (NFR-04) — para Latam si se expande.

15. **Telemetría** (NFR-02, NFR-03): Sentry + Mixpanel/Amplitude.

16. **Variables Collection en Figma** (R12): pasar los CSS custom properties a Figma Variables formales + script para generar `app_colors.dart` automáticamente. Habilita design-system real.

### 6.4 ADRs a escribir (en `docs/adr/`)

Antes de P1, registrar decisiones:

- `0001-flutter-multi-platform.md` — por qué Flutter y no React.
- `0002-canal-mensajeria.md` — WhatsApp vs Telegram con análisis costos.
- `0003-rol-cocinero.md` — formalización del rol no documentado.
- `0004-auth-jwt-backend.md` — esquema JWT, expiry, refresh.
- `0005-state-management.md` — Provider vs Riverpod vs BLoC.
- `0006-agente-ia-scope.md` — qué LLMs, qué cobertura MVP.
- `0007-network-stack.md` — http vs dio, interceptors, retry.

---

## 7. Validaciones EXTERNAS que NO puedes hacer solo

Estas requieren input humano (owner / equipo backend / producto / finanzas). Plantéalas como bloqueadores antes de empezar trabajo dependiente.

| ID | Pregunta | A quién | Bloquea |
|---|---|---|---|
| V1 | ¿El backend FastAPI vive en repo separado? ¿Tiene n8n/Kafka/Redis/S3 según doc? | Backend lead | toda integración |
| V2 | ¿La decisión Telegram vs WhatsApp es definitiva? | Producto / fundador | P0.1 |
| V3 | ¿El rol Cocinero fue aprobado por stakeholders? | Producto | docs/formulación-v2 |
| V4 | ¿Se publica target web/ de Flutter? | Tech lead | secrets management |
| V5 | ¿El doc de formulación necesita re-aprobación académica/comercial? | Owner / tutor | tiempos |
| V6 | ¿WhatsApp Business API comprada? Costos vs Telegram | Finanzas | viabilidad |
| V7 | ¿POS objetivo concreto para RNF-06 o genérico? | Producto | inventario futuro |
| V8 | ¿Agente IA debe ser real en MVP o se elimina del scope? | Producto | P0.5 |
| V9 | ¿Onboarding por rol diferenciado o landing único? | Producto / diseño | MISS-07 |
| V10 | ¿El repo será público en algún momento? | Tech lead | rotación history secret |

---

## 8. Comandos útiles para Codex

```powershell
# Setup local
flutter pub get
flutter run                                       # debug en device conectado
flutter build apk --debug                         # APK debug
flutter analyze                                   # lints

# Revalidar hallazgos
Get-Content lib\main.dart | Select-String '83c58120'        # secret presente?
(Select-String -Path lib\**\*.dart -Pattern 'Color\(0xFF' -AllMatches).Matches.Count   # colores literales
git log --all --oneline -S '83c58120'                       # commits que tocan el secret
git grep -n "TextField\|TextFormField" lib/features         # inputs inline

# Si haces refactor de gran escala
dart fix --apply                                  # auto-fix lints
flutter format lib/                               # formato consistente
```

---

## 9. Referencias rápidas

- Audit completo: `docs/ARCHITECTURE_REVIEW.md` (secciones 1–11 + anexos).
- Figma file: `https://www.figma.com/design/fPFAUoRJyEbEXrQfHg1JNp/ProntoApp-`
- Frames Figma serializados: `.codeviz/figma_metadata.xml` (65 frames).
- Screenshots Figma: `.codeviz/figma_shots/` (7 PNG).
- Commits clave:
  - `cfbc342` — base de esta auditoría.
  - `5aa4e39` — añadió secret (commit más reciente que lo toca).
  - `1061525` — integración Telegram + DeepSeek + FastAPI (origen del secret).
  - `07e3b12` — README añadido.
- Modelos: `lib/data/models/{order,product,category,user}_model.dart`.
- Entry point: `lib/main.dart`.
- Routes: `lib/app/routes.dart`.

---

## 10. Reglas de trabajo para Codex

1. **Lee `ARCHITECTURE_REVIEW.md` antes de tocar código**. Es el contexto largo; este handoff es el resumen prescriptivo.
2. **No empieces P0.2 antes de tener la decisión de §6.1.1 (canal)**.
3. **Cualquier cambio en `lib/main.dart` o en auth toca seguridad** — hacer en branch dedicado, pedir review humano.
4. **No reescribas el doc de formulación sin aprobación**: está vinculado a evaluación académica/comercial (ver V5).
5. **Si un hallazgo se vuelve obsoleto** (porque corregiste un bug o feature), actualiza este doc — vive con el proyecto.
6. **Commits**: respetar el patrón existente (`feat(scope): descripción en español`). Ver `docs/ARCHITECTURE_REVIEW.md` anexo A.
7. **Cuando Figma diga algo distinto al código**: el código es ground truth de qué hay; Figma es ground truth de qué se espera. Decide caso por caso, no asumas que uno está bien.
8. **No agregues features que el usuario no pidió**. Hay 14 BUGs y 9 MISSes documentados; quédate ahí.

---

**Fin del handoff**. Cualquier inconsistencia entre este doc y la realidad del repo es bug del doc — repórtalo y corrige.
