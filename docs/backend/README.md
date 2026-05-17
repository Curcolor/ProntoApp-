# backend/

Cambios services backend Python/FastAPI, schema Firebase Data Connect, persistencia Cloud SQL.

## Mapeo repositorio

Backend vive en `C:\WorkSpace-Vs-Code\ProntoApp--Back`. Esta carpeta documenta los cambios que tocan ese repo desde el orquestador en este repo (Flutter).

## Categorías

- **dataconnect/** — schema SDL, operations, migrations SQL.
- **services/** — un .md por servicio (orders, inventory, ai-agent, employees, etc) con persistencia, endpoints, eventos.
- **infrastructure/** — Kafka, Redis, S3, Secret Manager, deploy.

## Convención

Cuando Codex implementa un cambio backend, debe entregar `docs/backend/<servicio>-<feature>.md` con:
- Descripción del cambio.
- Endpoints/eventos modificados.
- Dependencias añadidas.
- Tests escritos.
- Gaps identificados.
