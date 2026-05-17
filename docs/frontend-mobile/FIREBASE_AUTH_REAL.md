# Firebase Auth real — F6.2 (parcial)

**Estado:** Wrapper + perfil service + AuthGuard implementados y `flutter analyze` limpio.
**Pendiente:** integración en `main.dart` + borrado de `auth_service.dart` legacy + borrado del secret hardcoded — requiere acción de Junior (rotar secret + autorizar borrar). Documentado en `docs/arquitectura/SEGURIDAD_PLAN.md`.

---

## Lo que se hizo en este turno

### Backend (queries SDL)

- Añadida query `ObtenerMiPerfilUsuarioAdmin` a `dataconnect/prontoapp/queries.gql` (commit backend).
  - Filtro `firebaseUid: { eq_expr: "auth.uid" }` → el servidor resuelve el usuario del ID token automáticamente.
  - Devuelve UNA fila activa (orderBy creadoEn ASC) o lista vacía si el firebaseUid no tiene `UsuarioAdmin` asociado (caso primer login pendiente onboarding).
  - Embebe `negocio { id, nombre, tipoNegocio, formatoEntrega, zonaHoraria, monedaIso }` para evitar segundo round-trip.

### Frontend (Flutter)

- `lib/data/services/firebase_auth_service.dart` — wrapper `FirebaseAuth` como `ChangeNotifier`:
  - `iniciarSesionEmail(email, password)` → `AuthResultado` (sealed: `AuthExito | AuthError`).
  - `registrarEmail(email, password, nombreVisible?)`.
  - `enviarReset(email)`.
  - `cerrarSesion()`.
  - `obtenerIdToken({forzarRefresh})` — devuelve el JWT firmado por Firebase para `Authorization: Bearer <token>` al backend.
  - Reactivo a `authStateChanges()` (sobrevive reboot, refresh automático del token).
- `lib/data/services/perfil_usuario_admin_service.dart` — wrapper SDK Data Connect:
  - `obtenerMiPerfil() -> PerfilUsuarioAdmin?`.
  - Normaliza el resultado a un DTO inmutable con `id, nombre, email, cargo, negocioId, negocioNombre, tipoNegocio, formatoEntrega, zonaHoraria, monedaIso`.
- `lib/features/auth/widgets/auth_guard.dart`:
  - Guard widget que verifica (1) Firebase Auth inicializado + logueado, (2) `UsuarioAdmin` resuelto, (3) cargo permitido.
  - Pantallas fallback: cargando, login requerido, onboarding pendiente, no autorizado.
  - Composable: `AuthGuard(cargosPermitidos: [RolAdmin.GERENTE, RolAdmin.PROPIETARIO], builder: (perfil) => ManagerMainScreen(perfil: perfil))`.

---

## Lo que NO se hizo (y por qué)

1. **No tocar `lib/main.dart`** — contiene el secret hardcoded (`83c58120...43`) cuyo borrado Junior pidió esperar hasta tener Firebase Auth completo y backend listo. Borrarlo HOY rompe los providers existentes que dependen del backend HTTP localhost.
2. **No borrar `lib/data/services/auth_service.dart`** (fake plaintext) — sigue siendo usado por providers actuales. Se borra cuando F6.3 migre providers a SDK Data Connect.
3. **No migrar providers** — F6.3 hace eso. F6.2 solo prepara la capa auth.

---

## Próximos pasos (F6.2 → F6.3)

1. **Junior:** rotar secret backend (instrucciones `SEGURIDAD_PLAN.md`).
2. **Junior:** habilitar Email/Password en Firebase Console (gap CONFIG_PENDIENTE).
3. **Sesión siguiente / Codex:** 
   - Reemplazar `MultiProvider` en `main.dart`:
     - Remover `AuthService()` viejo.
     - Inyectar `FirebaseAuthService()` + `PerfilUsuarioAdminService(connector)`.
     - Quitar `baseUrl: 'http://localhost:5050'` y `secreto: '...'`.
   - Modificar `lib/app/routes.dart` para wrappear pantallas con `AuthGuard`.
   - Reemplazar pantalla login para usar `FirebaseAuthService.iniciarSesionEmail`.
   - Borrar `auth_service.dart` + `user_model.dart` legacy.
4. **F7:** App Check Firebase (atestación) + tests integration login flow.

---

## Validación local

```bash
cd C:/WorkSpace-Vs-Code/ProntoApp-
flutter analyze lib/data/services/firebase_auth_service.dart \
                lib/data/services/perfil_usuario_admin_service.dart \
                lib/features/auth/widgets/auth_guard.dart
# Expected: "No issues found!"
```

---

## Riesgos / decisiones

- **`PerfilUsuarioAdmin.cargo` es `EnumValue<RolAdmin>`** (no `RolAdmin` directo) — el SDK Data Connect envuelve enums en una `sealed class Known<T> | Unknown(stringValue)` para soportar valores futuros sin romper el cliente. El comparador en `AuthGuard` usa `c.name == perfil.cargo.stringValue` por esta razón.
- **`obtenerMiPerfil()` devuelve `null` si no hay UsuarioAdmin** — UI debe mostrar onboarding o invitación pendiente.
- **No hay Google Sign-In** en V1 — solo email/password (decisión MVP).
- **No hay 2FA / phone auth** — V2.

---

## Referencias

- ADR Flutter 0001: `docs/arquitectura/0001-flutter-firebase-auth-sdk-sqlconnect.md`
- Plan seguridad: `docs/arquitectura/SEGURIDAD_PLAN.md`
- Query nueva backend: `ProntoApp--Back/dataconnect/prontoapp/queries.gql` (`ObtenerMiPerfilUsuarioAdmin`)
- Auditoría pantallas: `docs/frontend-mobile/AUDITORIA_PANTALLAS.md`
