# ADR 0001 (Flutter): Migración auth fake + HTTP localhost → Firebase Auth + SDK SQL Connect

**Status:** Aceptado
**Fecha:** 2026-05-16
**Decidido por:** Junior (owner) + sesión Claude Code orquestadora 2026-05-16
**Supersede:** ninguno (ADR inaugural del repo Flutter)
**Relacionado:** [ADR back 0011 firebase-sql-connect-postgres](../../../ProntoApp--Back/docs/ADRs/0011-firebase-sql-connect-postgres.md), [ADR back 0012 agente-ia-langgraph-litellm](../../../ProntoApp--Back/docs/ADRs/0012-agente-ia-langgraph-litellm.md), [ADR back 0013 multi-canal-mensajeria](../../../ProntoApp--Back/docs/ADRs/0013-multi-canal-mensajeria.md)

## Contexto

La app Flutter actual presenta los siguientes anti-patrones críticos identificados en `docs/ARCHITECTURE_REVIEW.md`:

1. **Auth fake:** `lib/data/services/auth_service.dart` tiene usuarios hardcoded con passwords plaintext (gerente/cocinero/repartidor). No hay verificación criptográfica, no hay token, no hay sesión persistente real.
2. **Acoplamiento HTTP a localhost:** `lib/main.dart` define `http://localhost:5050` + cabecera `X-Secret` hardcoded como contrato con un backend que ya no existirá tras la migración a Firebase Data Connect + FastAPI.
3. **Secret hardcoded:** el valor de `X-Secret` está en código, visible en cualquier APK reverse-engineered.
4. **Sin observabilidad de identidad:** no se puede saber qué usuario hizo qué desde el backend (no hay UID, no hay claim).
5. **No multi-tenant real:** la pantalla actual asume "un usuario, un negocio" sin resolver `UsuarioAdmin.negocioId`.

Adicionalmente, los providers HTTP (`order_provider.dart`, `inventory_provider.dart`) hacen polling a `localhost:5050/pedidos` cada 5s — un patrón que no funciona en mobile producción (CORS, batería, conectividad) y que el SDK Data Connect ya supera con consultas tipadas.

## Decisión

Migrar la app Flutter a tres capas claras:

### 1. Autenticación: Firebase Auth como única fuente de identidad

- Borrar `auth_service.dart` con users hardcoded.
- Implementar flujo Firebase Auth con:
  - Email + password.
  - Google Sign-In (opcional V2).
- Tras `signInWithEmailAndPassword`, resolver el perfil de aplicación consultando `UsuarioAdmin` por `firebaseUid = FirebaseAuth.instance.currentUser.uid` mediante el SDK Data Connect (operación `ObtenerUsuarioAdminPorFirebaseUid`).
- Persistir sesión via `firebase_auth` (storage nativo). NO usar `SharedPreferences` para credenciales.
- `AuthGuard` en navegación: redirige según `UsuarioAdmin.cargo` (PROPIETARIO/GERENTE/COCINERO/REPARTIDOR/SUPERVISOR).

### 2. Lectura: Firebase Data Connect SDK Dart generado

- Reemplazar todos los providers que hacen `http.get('http://localhost:5050/...')` por queries del SDK generado en `lib/generated/prontoapp_dataconnect/`.
- Operaciones clave:
  - `ObtenerPedidosKanban(negocioId)` para `order_provider.dart`.
  - `ObtenerMenuInventario(negocioId)` para `inventory_provider.dart`.
  - `ObtenerDashboardNegocioV2(negocioId)` para dashboard.
  - `ObtenerPlantillasIa(negocioId)` para pantalla agente IA.
  - `ObtenerIntegracionesMensajeria(negocioId)` para configuración WhatsApp/Telegram.
- Polling 5s → mantener inicialmente con `Timer.periodic` + retry exponencial cap 30s, hasta que Data Connect Dart soporte subscriptions nativas (no disponible al 2026-05).

### 3. Escritura: comandos críticos vía FastAPI con Firebase ID Token

- Operaciones de **negocio** (no CRUD plano) van a `service-orders` / `service-inventory` / `service-ai-agent` por HTTP REST:
  - `POST /v1/pedidos/{id}/estado` cambiar estado pedido (transiciones validadas).
  - `POST /v1/pedidos` crear pedido manual.
  - `POST /v1/productos/{id}/movimientos-stock` ajustar stock.
  - `POST /v1/integraciones/wa/...` setup WhatsApp.
- Autenticación: header `Authorization: Bearer <Firebase ID Token>` obtenido via `FirebaseAuth.instance.currentUser.getIdToken()`.
- El gateway / cada service verifica el token con Firebase Admin SDK y resuelve `UsuarioAdmin` por `firebase_uid`.

### Eliminaciones obligatorias

| Item | Archivo | Acción |
|---|---|---|
| `http://localhost:5050` | `lib/main.dart`, providers HTTP | borrar todas las referencias |
| `X-Secret` header hardcoded | `lib/main.dart` | borrar; no se reemplaza por otro secret en app |
| Users plaintext seed | `lib/data/services/auth_service.dart` | borrar archivo o reescribir a Firebase Auth wrapper |
| Polling 5s sin backoff | providers | mantener 5s pero con retry exponencial + cap |

## Alternativas consideradas

| Alternativa | Por qué se descartó |
|---|---|
| **Auth con backend propio (JWT FastAPI)** | Duplica infra. Firebase Auth ya está, es free hasta 50k MAU, integra Google/Email/Phone gratis. |
| **Mantener `X-Secret` hasta migrar** | El secret está visible en APK; cualquier atacante con `apktool` lo extrae. Riesgo de seguridad inaceptable. |
| **Saltar Data Connect y leer todo por FastAPI** | Pierde SDK tipado generado, pierde row-level security `@auth` declarativo, vuelve a re-implementar paginación y filtros en cada query. |
| **No usar Firebase Auth, solo Google Sign-In directo** | Funciona, pero perdemos email/password (gerentes mayores) y no integra con backend de manera estándar. |

## Consecuencias

**Positivas:**
- Identidad criptográfica verificable end-to-end (ID Token firmado).
- Multi-tenant resuelto: `firebase_uid → UsuarioAdmin.negocioId → @auth(expr)` en cada query Data Connect.
- Cero secrets en el APK.
- Sesión persistente sobrevive reboot, sin código nuestro.
- MFA / 2FA / password reset / email verification gratis del lado Firebase.
- Backend FastAPI no maneja contraseñas (one less liability).

**Negativas / riesgos:**
- Firebase Auth requiere conectividad para login inicial. Mitigación: una vez logged-in, el ID Token se cachea ~1h y se renueva automáticamente.
- Lock-in a Firebase Auth. Mitigación: el contrato hacia el backend es ID Token JWT estándar — migrar a Auth0/Cognito/propio no requeriría tocar backend, solo intercambiar el cliente.
- Sin internet la app pierde funcionalidad de escritura (no puede llamar FastAPI). Mitigación V2: queue local de comandos + sync cuando vuelva conexión.
- Migrar providers a SDK genera breakage en pantallas que esperan los shapes viejos. Esto se cubre en Fase 6.3 del plan.

## Plan de migración (alineado con Fase 6 del plan ejecución)

| Sub-fase | Tarea | Doc |
|---|---|---|
| 6.1 | Auditoría pantalla por pantalla | `docs/frontend-mobile/AUDITORIA_PANTALLAS.md` |
| 6.2 | Firebase Auth real + borrar fake | `docs/frontend-mobile/FIREBASE_AUTH_REAL.md` |
| 6.3 | Providers → SDK SQL Connect | `docs/frontend-mobile/PROVIDERS_SQLCONNECT.md` |
| 6.4 | Vistas configuración faltantes | `docs/frontend-mobile/VISTAS_CONFIGURACION.md` |
| 6.5 | Refactor god widgets + AppColors | `docs/frontend-mobile/REFACTOR_DEUDAS.md` |

## Validación

Criterios al cerrar Fase 6:

```dart
// 1. No queda ningún http://localhost en el código
$ grep -r 'localhost:5050' lib/ test/
// espera: 0 matches

// 2. No queda X-Secret en el código
$ grep -r 'X-Secret' lib/ test/
// espera: 0 matches

// 3. AuthGuard activo en main()
$ grep -r 'FirebaseAuth.instance.currentUser' lib/main.dart
// espera: >= 1 match

// 4. Provider order usa SDK
$ grep -r 'ObtenerPedidosKanban' lib/data/providers/order_provider.dart
// espera: >= 1 match

// 5. Smoke test: login con cuenta dev y dashboard carga datos reales
flutter test integration_test/login_dashboard_test.dart
```

## Referencias

- Firebase Auth Flutter: <https://firebase.google.com/docs/auth/flutter/start>
- Data Connect SDK Dart: `lib/generated/prontoapp_dataconnect/README.md`
- Plan ejecución Fase 6: `docs/sesiones/PLAN_EJECUCION_FASES_0-7.md`
- Auditoría heredada: `docs/ARCHITECTURE_REVIEW.md`
