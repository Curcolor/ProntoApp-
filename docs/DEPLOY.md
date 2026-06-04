# Despliegue de ProntoApp (Cloud Run + Cloud SQL)

Backend FastAPI en **Cloud Run**, base de datos **Cloud SQL Postgres**
(provisionada por Firebase Data Connect), app Flutter apuntando al API por
`--dart-define`. El proyecto Firebase/GCP es `test-firestore-c77ab`.

## 0. Variables de entorno

No hay `.env` en el repo (está en `.gitignore`). En local exporta las variables o
usa un `.env` propio; en Cloud Run van por `--set-env-vars` / Secret Manager.

| Variable | Descripción | Dev (local) | Prod (Cloud Run) |
|---|---|---|---|
| `DATABASE_URL` | Conexión SQLAlchemy a Postgres | `postgresql+psycopg2://prontoapp:prontoapp@localhost:5433/prontoapp` | `postgresql+psycopg2://prontoapp:CLAVE@/prontoapp?host=/cloudsql/test-firestore-c77ab:us-central1:INSTANCE` |
| `TELEGRAM_WEBHOOK_SECRET` | Secreto del header `x-secret` (lo comparten API, bot y app) | (vacío) | `<secreto rotado>` |
| `TELEGRAM_BOT_TOKEN` | Token del bot de Telegram | `<token>` | `<token>` |
| `TEST_DATABASE_URL` | Solo para correr los tests | `postgresql+psycopg2://prontoapp:prontoapp@localhost:5433/prontoapp_test` | — |

## 1. Prerrequisitos

- `gcloud` CLI autenticado: `gcloud auth login && gcloud config set project test-firestore-c77ab`.
- `firebase` CLI: `firebase login` (ya hecho).
- **Billing habilitado** en el proyecto GCP (Cloud SQL y Cloud Run lo requieren).
- Habilitar APIs:
  ```
  gcloud services enable run.googleapis.com sqladmin.googleapis.com \
    artifactregistry.googleapis.com cloudbuild.googleapis.com
  ```

## 2. Provisionar Cloud SQL + aplicar el esquema (Data Connect)

1. Editar `dataconnect/dataconnect.yaml`: poner `location` real (ej. `us-central1`)
   y un `cloudSql.instanceId` real (ej. `prontoapp-prod`).
2. Desplegar el esquema (crea la instancia Cloud SQL y aplica `schema.gql`):
   ```
   firebase deploy --only dataconnect --project test-firestore-c77ab
   ```
3. Anotar el nombre de conexión de la instancia:
   `test-firestore-c77ab:us-central1:prontoapp-prod` (PROJECT:REGION:INSTANCE).
4. Crear el usuario/clave de la DB si Data Connect no lo hizo (Consola Cloud SQL →
   Users) y la base `prontoapp`.

## 3. Seed de producción

Con el **Cloud SQL Auth Proxy** corriendo localmente apuntando a la instancia:
```
./cloud-sql-proxy test-firestore-c77ab:us-central1:prontoapp-prod &
cd services
export DATABASE_URL=postgresql+psycopg2://prontoapp:CLAVE@localhost:5432/prontoapp
.venv/Scripts/python.exe -m src.seed
```
Crea el negocio + los 3 usuarios default (`gerente@prontoa.com` / `password123`,
etc.). **Cambia esas contraseñas en producción.**

## 4. Construir y publicar la imagen

```
gcloud artifacts repositories create prontoapp \
  --repository-format=docker --location=us-central1
gcloud builds submit services/ \
  --tag us-central1-docker.pkg.dev/test-firestore-c77ab/prontoapp/api:latest
```

## 5. Desplegar la API en Cloud Run

```
gcloud run deploy prontoapp-api \
  --image us-central1-docker.pkg.dev/test-firestore-c77ab/prontoapp/api:latest \
  --region us-central1 \
  --add-cloudsql-instances test-firestore-c77ab:us-central1:prontoapp-prod \
  --set-env-vars "DATABASE_URL=postgresql+psycopg2://prontoapp:CLAVE@/prontoapp?host=/cloudsql/test-firestore-c77ab:us-central1:prontoapp-prod,TELEGRAM_WEBHOOK_SECRET=<secreto>,TELEGRAM_BOT_TOKEN=<token>" \
  --allow-unauthenticated
```
Anotar la URL pública (`https://prontoapp-api-XXXX.run.app`).

## 6. Desplegar el bot (2º servicio)

Misma imagen, comando del bot, always-on:
```
gcloud run deploy prontoapp-bot \
  --image us-central1-docker.pkg.dev/test-firestore-c77ab/prontoapp/api:latest \
  --region us-central1 \
  --command python --args=-m,src.bot_telegram \
  --no-cpu-throttling --min-instances 1 \
  --set-env-vars "FASTAPI_URL=https://prontoapp-api-XXXX.run.app,TELEGRAM_WEBHOOK_SECRET=<secreto>,TELEGRAM_BOT_TOKEN=<token>,DEEPSEEK_API_KEY=<key>"
```

## 7. Build de Flutter para producción

```
flutter build apk --release \
  --dart-define=API_BASE_URL=https://prontoapp-api-XXXX.run.app \
  --dart-define=API_SECRET=<secreto>
```
(Para web: `flutter build web --dart-define=...`.)

## 8. Verificación

- `curl https://prontoapp-api-XXXX.run.app/health` → `{"ok": true, ...}`.
- En la app: login con un usuario, ver inventario/pedidos.
- `curl` sin header `x-secret` a un endpoint protegido → `403`.

## 9. 🔐 Rotación de API_SECRET (IMPORTANTE)

El secreto actual está en el historial de git (`lib/main.dart`) → trátalo como
**comprometido**. Antes de producción, rótalo:

1. Generar uno nuevo: `openssl rand -hex 32`.
2. Setearlo en los **tres** lugares (deben coincidir exactamente):
   - **API** (Cloud Run):
     `gcloud run services update prontoapp-api --region us-central1 --update-env-vars TELEGRAM_WEBHOOK_SECRET=<nuevo>`
   - **Bot** (Cloud Run):
     `gcloud run services update prontoapp-bot --region us-central1 --update-env-vars TELEGRAM_WEBHOOK_SECRET=<nuevo>`
   - **App** (Flutter): rebuild con `--dart-define=API_SECRET=<nuevo>` y redistribuir
     el APK/web.
3. Verificar: un request con el secreto viejo ahora da `403`; con el nuevo, `200`.
4. Mejora futura: mover el secreto a **Secret Manager**
   (`gcloud secrets create … && gcloud run … --set-secrets TELEGRAM_WEBHOOK_SECRET=…`)
   para no tenerlo en env-vars en claro.

## Notas

- HTTPS lo termina Cloud Run automáticamente (no requiere config).
- CORS está en `*` (app móvil con auth por header; sin cookies). Restringir si se
  añade un origen web conocido.
- Costos: Cloud Run escala a cero; Cloud SQL cobra por instancia encendida
  (considerar la más chica o apagarla cuando no se use).
