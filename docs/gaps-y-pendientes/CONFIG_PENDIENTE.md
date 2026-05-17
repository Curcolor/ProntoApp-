# Configuración pendiente fuera del repo

Features que NO pueden probarse end-to-end hasta configurar algo externo (Firebase consola, GCP billing, proveedores third-party, sandboxes). El agente debe documentar AQUÍ cada vez que detecte uno.

## Plantilla entrada

```markdown
### [TIMESTAMP] — [FEATURE]

- **Bloqueo:** descripción corta del por qué no se puede probar/desplegar.
- **Qué falta configurar:** acción específica externa.
- **Dónde:** URL consola / comando CLI / proveedor.
- **Quién puede hacerlo:** owner (Junior, admin GCP, etc).
- **Costo estimado:** USD/mes o "gratis dentro cuota".
- **Prioridad:** P0 (bloquea MVP) / P1 (bloquea feature opcional) / P2 (nice-to-have).
- **Workaround temporal:** cómo seguimos sin esto (mocks, dummy data, feature flag off).
- **Test que demostraría que funciona:** acceptance criteria.
```

---

## Entradas activas

### 2026-05-16 — Secret Manager GCP

- **Bloqueo:** API Secret Manager deshabilitada en proyecto `test-firestore-c77ab`.
- **Qué falta:** habilitar API + billing GCP.
- **Dónde:** `gcloud services enable secretmanager.googleapis.com --project=test-firestore-c77ab` y habilitar billing en https://console.cloud.google.com/billing.
- **Quién:** Junior (owner cuenta solano200801@gmail.com).
- **Costo:** $0.06 por secret por mes + $0.03 por 10K accesos. Negligible.
- **Prioridad:** P1 — alta para producción, no bloquea dev local.
- **Workaround:** password postgres guardada en password manager externo. WhatsApp tokens en `.env` local (NO commit).
- **Test:** `gcloud secrets versions access latest --secret=cloudsql-postgres-password` devuelve valor.

### 2026-05-16 — WhatsApp Cloud API / WABA

- **Bloqueo:** sin Business Manager Meta, sin `phone_number_id` real, sin `wabaId`, sin permanent access token.
- **Qué falta:**
  1. Crear/usar cuenta Meta Business Manager: https://business.facebook.com/
  2. Crear App tipo Business en https://developers.facebook.com/apps/
  3. Agregar producto WhatsApp Business → obtener test `phone_number_id` y system user token (24h) o permanent.
  4. Verificar número (opcional con test number en sandbox).
- **Quién:** Junior + dueño negocio piloto (necesita doc legal).
- **Costo:** conversaciones gratis primeras 1000/mes/número; luego ~$0.005-$0.08 según tipo y país.
- **Prioridad:** P1 — necesario para flujo ingesta pedido real.
- **Workaround:** Telegram Bot primero (gratis, sin BM Meta). WhatsApp queda detrás feature flag `INTEGRACION_WA_HABILITADA=false`.
- **Test:** webhook recibe mensaje de prueba en `service-ai-agent /webhooks/whatsapp`.

### 2026-05-16 — Telegram Bot Token

- **Bloqueo:** sin bot creado.
- **Qué falta:**
  1. Hablar con `@BotFather` en Telegram → `/newbot` → nombre → username → token.
  2. Guardar token en variable de entorno `TELEGRAM_BOT_TOKEN` (NO commit).
  3. Configurar webhook: `curl "https://api.telegram.org/bot<TOKEN>/setWebhook?url=<URL_PUBLICA>/webhooks/telegram"`.
  4. Necesita URL pública (Cloud Run / ngrok dev).
- **Quién:** Junior.
- **Costo:** $0.
- **Prioridad:** P0 — primera integración mensajería V1.
- **Workaround:** ngrok local para dev.
- **Test:** envías mensaje al bot, llega a `/webhooks/telegram` y crea `SesionAgente`.

### 2026-05-16 — Google AI Studio / Vertex AI API key

- **Bloqueo:** sin API key para `gemini-embedding-001` y `gemini-2.0-flash`.
- **Qué falta:**
  1. Crear API key en https://aistudio.google.com/app/apikey
  2. Guardar como `GOOGLE_API_KEY` env var.
  3. Capa gratuita: 1500 RPM, 1M tok/día embeddings; Gemini Flash gratis dentro cuota.
- **Quién:** Junior.
- **Costo:** $0 dentro cuota. Si excede: $0.025/1K input tokens Flash.
- **Prioridad:** P0 — bloquea agente IA + RAG.
- **Workaround:** dev local con responses mock vía LiteLLM fixtures.
- **Test:** `curl litellm with model=gemini/gemini-embedding-001` devuelve vector 1536-dim.

### 2026-05-16 — Cloud Run / hosting service-ai-agent

- **Bloqueo:** sin URL pública para webhooks WhatsApp/Telegram.
- **Qué falta:**
  1. Habilitar billing GCP.
  2. `gcloud run deploy service-ai-agent --source=services/service-ai-agent --region=us-east4 --allow-unauthenticated` (webhooks deben ser públicos pero verificar firma).
- **Quién:** Junior.
- **Costo:** Cloud Run free tier 2M req/mes, luego $0.40 por millón. ~$0-5/mes dev.
- **Prioridad:** P1 — necesario para webhooks reales. Dev: ngrok.
- **Workaround:** ngrok local + uvicorn.
- **Test:** webhook responde 200 a request de verificación Meta/Telegram.

### 2026-05-16 — Kafka / Pub/Sub para event-driven

- **Bloqueo:** sin broker. Outbox pattern necesita consumidor.
- **Qué falta:** decisión Kafka (Confluent Cloud, MSK) vs Google Pub/Sub.
- **Quién:** Junior (decisión arquitectura).
- **Costo:** Pub/Sub: 10GB/mes gratis. Kafka Confluent: ~$1/hora cluster mínimo.
- **Prioridad:** P2 — eventos pueden simularse con polling outbox table en V1.
- **Workaround:** worker que SELECT outbox WHERE estado=PENDIENTE cada 5s.
- **Test:** evento `producto.actualizado.v1` → re-embed disparado.

### 2026-05-16 — Firebase Auth proveedores

- **Bloqueo:** UI Flutter pide Google/Facebook login pero no hay providers habilitados en Firebase.
- **Qué falta:**
  1. Firebase Console → Authentication → Sign-in method.
  2. Habilitar Email/Password.
  3. Habilitar Google (auto). Facebook (requiere FB app id).
- **Quién:** Junior.
- **Costo:** $0.
- **Prioridad:** P0 — bloquea login real.
- **Workaround:** solo email/password en V1; Google/Facebook deshabilitar UI con feature flag.
- **Test:** `signInWithEmailAndPassword` desde Flutter funciona.

### 2026-05-16 — Firebase Hosting / Cloud Run para FastAPI

- **Bloqueo:** Flutter necesita un endpoint público para `service-orders` (comandos críticos con Firebase ID token).
- **Qué falta:** misma config Cloud Run que ai-agent.
- **Workaround:** dev local con ngrok + Flutter apunta a ngrok URL via dart-define.

### 2026-05-16 — Aplicar seeds plantillas IA + herramientas (migrations 003 + 004)

- **Bloqueo:** seeds 003_seed_plantillas_globales.sql + 004_seed_herramientas.sql escritas pero NO aplicadas a Cloud SQL. Claude no tiene la password de postgres (rotada externa).
- **Qué falta:**
  1. Conectarse a Cloud SQL via `gcloud sql connect test-firestore-c77ab-instance --user=postgres --database=test-firestore-c77ab-2-database` (pide password).
  2. Ejecutar: `\i dataconnect/migrations/003_seed_plantillas_globales.sql` y `\i 004_seed_herramientas.sql`.
  3. Verificar: `SELECT codigo FROM plantillas_ia WHERE id_negocio IS NULL;` debe devolver 4 filas. `SELECT nombre FROM herramientas_ia WHERE id_negocio IS NULL;` debe devolver 5 filas.
- **Quién:** Junior (tiene password).
- **Costo:** $0.
- **Prioridad:** P0 — bloquea Fase 4.2 (service-ai-agent necesita plantilla + herramientas configuradas para arrancar).
- **Workaround:** `service-ai-agent` puede arrancar con plantillas hardcoded de fallback hasta que se apliquen los seeds; pero rompe principio multi-tenant.
- **Test:** `service-ai-agent` carga `global_atencion_cliente_v1` por `codigo` y arranca graph atencion_cliente sin errores.

---

## Entradas resueltas

(mover entradas aquí cuando se completen, con fecha de resolución)
