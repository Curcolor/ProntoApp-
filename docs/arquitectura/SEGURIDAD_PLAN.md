# Plan de seguridad ProntoApp

**Versión:** V1 (sin billing GCP) → V2 (con billing).
**Estado HOY:** mezcla insegura — secret hardcoded en cliente, plaintext passwords en SharedPreferences, sin Firebase Auth real.

---

## Principios

1. **Cliente móvil = público.** Cualquier APK firmado se decompila. NUNCA secrets en Flutter.
2. **Backend es la frontera de confianza.** Validación, autorización, secrets, lógica crítica = server-side.
3. **Cero shared secrets entre cliente y backend.** Auth vía Firebase ID token JWT firmado (clave pública verificable).
4. **Secrets server-side via Secret Manager (V2) o env vars + IAM (V1).**

---

## Inventario secrets

### ❌ Cliente Flutter NUNCA debe tener:

- Passwords DB (Postgres, Redis, etc).
- API keys LLM providers (Gemini, Anthropic, OpenAI).
- WhatsApp Business / Telegram bot tokens.
- Service-to-service secrets compartidos.
- Webhook signing secrets.
- Firebase Admin SDK service account JSON.

### ✅ Cliente Flutter SÍ puede tener:

- Firebase config (`google-services.json`, `firebase_options.dart`) — **público por diseño**, protegido por Auth rules + Data Connect `@check`.
- URLs públicas backend (Cloud Run dominio).
- Feature flags no sensibles.

---

## Modelo auth correcto

```
┌──────────┐                          ┌────────────────┐
│ Flutter  │                          │ FastAPI service│
│          │                          │                │
│ Firebase │ ──── ID token JWT ────►  │ verify_id_token│
│   Auth   │      Bearer <token>      │   (firebase    │
│          │                          │    admin)      │
└──────────┘                          └────────────────┘
                                             │
                                             ▼
                                      ┌──────────────┐
                                      │ UsuarioAdmin │
                                      │ buscar por   │
                                      │ firebase_uid │
                                      └──────────────┘
                                             │
                                             ▼
                                      RBAC por cargo + negocio_id
```

**Cero shared secret.** Backend confía en ID token (firmado por Firebase con clave privada de Google, verificable con JWKS público).

---

## Dónde viven secrets server-side

### V1 — sin billing GCP (estado actual)

| Secret | Ubicación |
|---|---|
| Postgres password | Local password manager. **Migrar a Cloud SQL IAM auth (gratis)**. |
| Google AI key (Gemini) | `.env` local + Cloud Run env var |
| WhatsApp tokens | `.env` local + Cloud Run env var |
| Telegram bot tokens | `.env` local + Cloud Run env var |
| Webhook signing | `.env` local + Cloud Run env var |
| Firebase Admin SDK | Service Account JSON en GCS bucket con IAM restrictivo |

### V2 — con billing habilitado

| Secret | Ubicación |
|---|---|
| Cloud SQL access | Workload Identity (sin password) |
| API keys LLM | Secret Manager + ref desde Cloud Run |
| WhatsApp/Telegram | Secret Manager, ref vía `IntegracionMensajeria.credencialSecretRef` |
| Webhook signing | Secret Manager |
| Firebase Admin SDK | Workload Identity (sin JSON file) |

---

## Cloud SQL IAM authentication (V1, gratis)

**Setup (una vez):**

```bash
# Habilitar IAM auth en instance
gcloud sql instances patch test-firestore-c77ab-instance \
  --database-flags=cloudsql.iam_authentication=on

# Crear usuario IAM (service account de Cloud Run)
gcloud sql users create ai-agent-sa@test-firestore-c77ab.iam.gserviceaccount.com \
  --instance=test-firestore-c77ab-instance \
  --type=cloud_iam_service_account

# Grant role public schema
gcloud sql connect test-firestore-c77ab-instance --user=postgres
# en psql:
GRANT firebasewriter_test-firestore-c77ab-2-database_public TO "ai-agent-sa@test-firestore-c77ab.iam.gserviceaccount.com";
```

**Conexión desde Cloud Run (sin password):**

```python
# pg8000 + cloud-sql-python-connector
from google.cloud.sql.connector import Connector, IPTypes
import pg8000

def get_conn():
    connector = Connector()
    return connector.connect(
        "test-firestore-c77ab:us-east4:test-firestore-c77ab-instance",
        "pg8000",
        user="ai-agent-sa@test-firestore-c77ab.iam.gserviceaccount.com",
        db="test-firestore-c77ab-2-database",
        enable_iam_auth=True,
        ip_type=IPTypes.PUBLIC,
    )
```

**Local dev:** Cloud SQL Auth Proxy con tu user IAM:

```bash
cloud-sql-proxy --auto-iam-authn test-firestore-c77ab:us-east4:test-firestore-c77ab-instance
# Conectar como solano200801@gmail.com sin password
psql "host=127.0.0.1 dbname=test-firestore-c77ab-2-database user=solano200801@gmail.com"
```

---

## Acciones inmediatas (prioridad)

### P0 — HOY

1. **Borrar literal `X-Secret`** en `lib/main.dart:41,50` y referencias. Romperá builds — OK, parche temporal: comentar llamadas backend hasta Fase 6.2.
2. **Borrar plaintext passwords** en `lib/data/services/auth_service.dart` (seeds `password123`). Auth fake va a borrarse en F6.2 completa.
3. **Rotar password Cloud SQL** después de aplicar seeds 003+004. Guardar en password manager externo.
4. **Habilitar Cloud SQL IAM auth** en instance (comando arriba). Permite migrar backend a sin-password.
5. **`.gitignore`** asegurar que `.env` esté listado en backend repo.

### P1 — esta semana

6. **Implementar Firebase Auth real** Flutter (F6.2 del plan).
7. **Backend `service-ai-agent`:** usar `firebase_admin` para verify_id_token en webhooks/HTTP.
8. **App Check Firebase** (gratis) para atestación de app — filtra bots/scrapers.
9. **CORS estricto** en FastAPI Cloud Run — solo dominios conocidos.
10. **Rate limiting** per-negocio en backend (Redis token bucket).

### P2 — antes producción

11. Habilitar billing GCP → migrar a Secret Manager.
12. Workload Identity para todo Cloud Run.
13. Cloud Armor / WAF si exposición pública.
14. Audit logs Cloud SQL + Firebase Auth.
15. `git filter-repo` historial para purgar el secret hardcoded de commits viejos.

---

## Validación

Para considerar V1 "seguro":

- [ ] Decompilar APK con `apktool d app-release.apk` y `grep -r "secret\|password\|token" smali/` no devuelve nada útil.
- [ ] `gitleaks detect` en ambos repos pasa limpio.
- [ ] Todos los endpoints backend exigen `Authorization: Bearer <token>` válido.
- [ ] Cloud SQL no acepta password auth (solo IAM) para usuarios no admin.
- [ ] `.env` files no están en git history (`git log --all --full-history -- '*.env'` vacío).

---

## Referencias

- Firebase Auth ID token verification: https://firebase.google.com/docs/auth/admin/verify-id-tokens
- Cloud SQL IAM authentication: https://cloud.google.com/sql/docs/postgres/iam-authentication
- Firebase App Check: https://firebase.google.com/docs/app-check
- Secret Manager pricing: https://cloud.google.com/secret-manager/pricing (~$0.06/secret/mes)
- OWASP Mobile Top 10: https://owasp.org/www-project-mobile-top-10/
