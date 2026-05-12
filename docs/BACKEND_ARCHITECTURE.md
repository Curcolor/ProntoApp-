# Prontoa! — Arquitectura Backend (Microservicios + Hexagonal)

> **Workspace destino**: `C:\WorkSpace-Vs-Code\ProntoApp--Back` (creado, vacío).
> **Cliente que consume**: `C:\WorkSpace-Vs-Code\ProntoApp-` (Flutter móvil).
> **Fecha**: 2026-05-11 · **Branch**: `main`.
> **Fuentes de diseño**:
> - `docs/diseños-para-version-web-del-sistema/prontoa-arquitecture-Arquitectura.png`
> - `docs/diseños-para-version-web-del-sistema/prontoa-arquitecture-diagrama-despliegue.png`
> - `docs/diseños-para-version-web-del-sistema/Database ER diagram ProntoApp.{png,svg,json}`
> - Contrato HTTP actual del cliente Flutter (`lib/data/providers/*`)

Este documento define **qué microservicios crear, cómo estructurarlos por dentro (arquitectura hexagonal), qué eventos producen/consumen, y cómo el cliente Flutter los va a llamar**. Es el plano de obra antes de generar código.

---

## 1. Principios

- **Microservicios por bounded context**: cada servicio dueño de su BD (no shared DB). Comunicación por API + eventos.
- **Hexagonal (Ports & Adapters)** dentro de cada servicio: dominio puro al centro, adapters (HTTP, DB, Kafka, LLM clients) al borde.
- **Event-driven async** para flujos no críticos (notificaciones, analítica, impresión). REST síncrono para comandos críticos del cliente.
- **Schema-first**: cada API publica su OpenAPI; cada evento Kafka su contrato (AsyncAPI / JSON Schema). Single source of truth en `shared/`.
- **12-factor**: config por env vars, logs a stdout, stateless (estado en PG/Mongo/Redis/S3).
- **Test pyramid**: unit (dominio puro) > integration (adapters) > e2e (api+db con testcontainers).
- **Migraciones versionadas**: Alembic por servicio (PostgreSQL) / Beanie ODM o init scripts (Mongo).

---

## 2. Mapeo Requisitos Funcionales → Servicios

Diagrama original lista 7 microservicios. Mantenemos los 7 + agregamos **gateway** y absorbemos auth dentro de **service-employees** para no sobreingeniar.

| RF | Descripción | Servicio dueño | Servicios consumidores |
|---|---|---|---|
| RF-01 | Gestión Automatizada de Pedidos vía WhatsApp | `service-ai-agent` (intake) + `service-orders` (creación) | analytics, notifications |
| RF-02 | Organización de Pedidos en Flujo Kanban | `service-orders` (estados + transiciones) | notifications, printing |
| RF-03 | Notificaciones Automáticas | `service-notifications` | (consumer de todos) |
| RF-04 | Soporte Multimodal de Interacción (voz, imagen, texto) | `service-ai-agent` (Whisper / Vision) | orders |
| RF-05 | Automatización de Impresión para Despacho | `service-printing` | orders |
| RF-06 | Módulo de Supervisión Humana | `service-review` | orders, employees |
| RF-07 | Panel de KPIs y Analíticas en Tiempo Real | `service-analytics` | (consumer de todos) |
| RF-08 | Flujos de Pedido Temporizados y Modificables | `service-orders` + `service-printing` | notifications |
| (auth) | Login, JWT, roles | `service-employees` | (todos vía middleware) |
| (inv) | Productos, categorías, stock | `service-inventory` | orders (validar stock), ai-agent (menú) |

**Total: 9 servicios** (7 originales + gateway + inventory separado, ya que el ER tiene tabla Productos propia y el cliente Flutter ya consume `/inventario` aparte).

> **Decisión a validar con product**: ¿separamos `service-review` del MVP? El RF-06 (supervisión humana) puede vivir dentro de `service-orders` como módulo si el equipo es pequeño. Recomendación: **iniciar fusionado**, separar cuando el dominio lo justifique.

---

## 3. Layout del workspace `ProntoApp--Back/`

```
ProntoApp--Back/
├── README.md
├── docker-compose.yml                # local stack: PG + Mongo + Redis + Kafka + MinIO + services
├── docker-compose.override.yml       # overrides DEV (hot reload, logs, debugger)
├── .env.example
├── Makefile                          # comandos: up, down, migrate, test, seed, lint
│
├── docs/
│   ├── ARCHITECTURE.md               # copia o link a este doc
│   ├── EVENT_CATALOG.md              # todos los eventos Kafka
│   ├── API_GATEWAY.md                # rutas + auth
│   ├── ADRs/
│   │   ├── 0001-microservicios-vs-monolito.md
│   │   ├── 0002-hexagonal-por-servicio.md
│   │   ├── 0003-kafka-vs-rabbit.md
│   │   ├── 0004-postgresql-por-servicio.md
│   │   ├── 0005-auth-jwt-stateless.md
│   │   └── 0006-llm-multi-vendor.md
│   └── runbooks/                     # operativa (incidentes, deploy)
│
├── shared/                           # libs cross-service (publicadas como wheels internos)
│   ├── auth-middleware/              # FastAPI dep para verificar JWT
│   ├── event-schemas/                # Pydantic models de eventos Kafka
│   ├── domain-types/                 # Value Objects compartidos (Money, OrderState, NegocioId)
│   ├── observability/                # logging estructurado + OpenTelemetry
│   └── http-client-sdk/              # SDK Python para llamar entre servicios
│
├── infra/
│   ├── k8s/                          # manifests / Helm charts
│   │   ├── base/
│   │   └── overlays/{dev,staging,prod}/
│   ├── terraform/                    # AWS infra (RDS, MSK, EKS, ECR, S3, Cognito opt)
│   ├── kafka/
│   │   └── topics.yaml               # configuración declarativa de topics
│   └── grafana/                      # dashboards
│
├── services/
│   ├── api-gateway/                  # Traefik / Kong / FastAPI custom
│   ├── service-employees/            # auth + RBAC + gestión usuarios
│   ├── service-orders/               # pedidos + kanban (RF-01/02/08)
│   ├── service-inventory/            # productos + categorías + stock
│   ├── service-ai-agent/             # WhatsApp + LLM + plantillas (RF-01/04)
│   ├── service-notifications/        # push + WhatsApp out + email (RF-03)
│   ├── service-printing/             # POS + tickets (RF-05/08)
│   ├── service-analytics/            # KPIs + reportes (RF-07)
│   └── service-review/               # supervisión humana (RF-06) — opcional MVP
│
└── tools/
    ├── seed-db/                      # scripts seed datos demo
    ├── load-test/                    # k6 / locust
    └── codegen/                      # OpenAPI → Dart client (para el móvil)
```

---

## 4. Layout hexagonal estándar dentro de cada servicio

Patrón **idéntico** para todos los servicios. Aprenderlo una vez = lo aplicas a los 9.

```
services/service-orders/
├── pyproject.toml                    # Poetry o uv
├── Dockerfile
├── README.md
├── alembic.ini
├── alembic/
│   └── versions/                     # migraciones SQL versionadas
│
├── src/
│   └── orders/                       # package raíz
│       ├── __init__.py
│       ├── main.py                   # FastAPI app + DI wiring
│       │
│       ├── domain/                   # ◆ CORE — sin imports de FastAPI, SQLAlchemy, Kafka
│       │   ├── __init__.py
│       │   ├── entities/             # Aggregates: Pedido, DetallePedido
│       │   │   └── pedido.py
│       │   ├── value_objects/        # Money, EstadoPedido, CodigoPedido, NegocioId
│       │   │   └── money.py
│       │   ├── events/               # Domain events (no Kafka todavía)
│       │   │   ├── pedido_creado.py
│       │   │   └── estado_cambiado.py
│       │   ├── services/             # Domain services (lógica cross-entidad)
│       │   │   └── calculadora_total.py
│       │   ├── exceptions/           # DomainError, EstadoInvalidoError
│       │   │   └── __init__.py
│       │   └── ports/                # INTERFACES (ABC) — adapters las implementan
│       │       ├── repositories/
│       │       │   └── pedido_repository.py   # class PedidoRepository(ABC)
│       │       └── publishers/
│       │           └── event_publisher.py     # class EventPublisher(ABC)
│       │
│       ├── application/              # ◆ USE CASES (driving side)
│       │   ├── __init__.py
│       │   ├── commands/             # acciones (mutaciones)
│       │   │   ├── crear_pedido.py
│       │   │   ├── cambiar_estado.py
│       │   │   └── eliminar_pedido.py
│       │   ├── queries/              # lecturas
│       │   │   ├── obtener_pedidos.py
│       │   │   └── pedidos_por_estado.py
│       │   ├── dtos/                 # input/output (Pydantic)
│       │   │   ├── pedido_input.py
│       │   │   └── pedido_output.py
│       │   └── interfaces/           # ports a nivel app (notificador, etc.)
│       │
│       ├── infrastructure/           # ◆ DRIVEN ADAPTERS (implementan ports)
│       │   ├── __init__.py
│       │   ├── persistence/
│       │   │   ├── models.py         # SQLAlchemy models (TABLAS)
│       │   │   ├── pedido_repository_sqla.py   # implementa PedidoRepository
│       │   │   └── unit_of_work.py
│       │   ├── messaging/
│       │   │   ├── kafka_publisher.py          # implementa EventPublisher
│       │   │   └── consumers/                  # consumers de eventos externos
│       │   │       └── ai_intent_consumer.py
│       │   ├── external/             # clientes de otros servicios
│       │   │   ├── inventory_client.py         # llama a service-inventory
│       │   │   └── notifications_client.py
│       │   ├── llm/                  # solo si el servicio usa LLM (ai-agent)
│       │   ├── config/
│       │   │   └── settings.py       # pydantic-settings
│       │   └── di.py                 # contenedor DI (wiring)
│       │
│       └── interface/                # ◆ DRIVING ADAPTERS (entry points)
│           ├── __init__.py
│           ├── http/
│           │   ├── routes.py         # FastAPI routers
│           │   ├── schemas.py        # Pydantic request/response (HTTP layer)
│           │   ├── deps.py           # FastAPI Depends (auth, db session)
│           │   └── error_handlers.py # mapea DomainError → HTTP status
│           └── events/               # Kafka consumers como driving adapter
│               └── inventory_low_stock_handler.py
│
└── tests/
    ├── unit/                         # domain + application sin IO
    │   ├── test_pedido_entity.py
    │   └── test_crear_pedido_use_case.py
    ├── integration/                  # adapters con testcontainers (PG, Kafka)
    │   ├── test_pedido_repository.py
    │   └── test_kafka_publisher.py
    └── e2e/                          # API completa contra stack local
        └── test_orders_api.py
```

### Reglas de dependencia

```
interface ──▶ application ──▶ domain
infrastructure ──▶ application ──▶ domain
domain NUNCA importa de ningún otro layer.
application NUNCA importa de infrastructure ni interface.
```

Lo que esto te compra:
- Cambiar Postgres → DynamoDB toca **solo** `infrastructure/persistence/`.
- Cambiar Kafka → RabbitMQ toca **solo** `infrastructure/messaging/`.
- Cambiar FastAPI → litestar toca **solo** `interface/http/`.
- Reglas de negocio testean **sin** levantar BD ni broker.

### Stack por servicio (default)

```yaml
runtime: Python 3.12
web: FastAPI 0.115
async: anyio + uvloop
orm: SQLAlchemy 2.x async + Alembic
validation: Pydantic v2 + pydantic-settings
auth: shared/auth-middleware (PyJWT + RS256)
messaging: aiokafka (producer/consumer)
http_client: httpx
testing: pytest + pytest-asyncio + testcontainers-python
linter: ruff + mypy strict (solo domain/application)
deps: uv (más rápido que poetry, mismo lockfile reproducible)
container: python:3.12-slim base, multi-stage, non-root user
```

Excepciones por servicio:
- `service-analytics`: agrega `pandas`/`polars` + `motor` (Mongo async) + `apache-kafka-streams` o `faust-streaming`.
- `service-ai-agent`: agrega `anthropic`, `openai`, `google-genai`, `whisper`, `pillow`.
- `service-notifications`: agrega `firebase-admin` (FCM) + `httpx` (WhatsApp API) + `aiosmtplib` (email).
- `service-printing`: agrega `escpos` (térmicas) o conector POS específico.

---

## 5. Detalle por servicio

### 5.1 `api-gateway`

**Responsabilidad**: punto único de entrada para el cliente Flutter + WhatsApp webhooks.

**Stack**: empezar con **FastAPI custom** (más simple para el equipo), migrar a **Traefik** o **AWS API Gateway** cuando haya tráfico real.

**Funciones**:
- TLS termination.
- JWT decode + verify (delega a `shared/auth-middleware`).
- Inyecta header `X-User-Id`, `X-User-Role`, `X-Negocio-Id` a servicios downstream.
- Rate limit por IP y por user_id (`slowapi`).
- Routing por path:

| Path externo | Servicio interno | Auth |
|---|---|---|
| `POST /auth/login` | `service-employees:/auth/login` | público |
| `POST /auth/refresh` | `service-employees:/auth/refresh` | refresh token |
| `GET /me` | `service-employees:/users/me` | JWT |
| `*/orders/**` | `service-orders` | JWT (rol gerente/cocinero/repartidor) |
| `*/inventory/**` | `service-inventory` | JWT (gerente write, otros read) |
| `*/notifications/**` | `service-notifications` | JWT |
| `*/analytics/**` | `service-analytics` | JWT (gerente) |
| `*/printing/**` | `service-printing` | JWT (gerente/cocinero) |
| `*/employees/**` | `service-employees` | JWT (gerente) |
| `*/ai/templates/**` | `service-ai-agent` | JWT (gerente) |
| `POST /webhooks/whatsapp` | `service-ai-agent:/webhooks/whatsapp` | HMAC firma Meta |

**Endpoint público**: `https://api.prontoa.example.com`.

**Endpoint dev**: `http://localhost:8000`.

---

### 5.2 `service-employees` (auth + usuarios)

**Bounded context**: identidad y autorización.

**Agregados de dominio**:
- `Negocio` (raíz tenant): nombre, dirección, horarios, formato_entrega, numero_whatsapp.
- `UsuarioAdmin`: email, password_hash (bcrypt), cargo (`gerente`/`cocinero`/`repartidor`), id_negocio.
- `Invitacion`: token, email_destino, rol, expira_en.

**Endpoints**:
```
POST   /auth/login                  → { access_token, refresh_token, user }
POST   /auth/refresh
POST   /auth/logout
GET    /users/me
POST   /negocios                    (registro inicial — crea negocio + gerente)
GET    /negocios/{id}
PATCH  /negocios/{id}
GET    /negocios/{id}/users
POST   /negocios/{id}/invitations
POST   /invitations/{token}/accept
PATCH  /users/{id}/role
DELETE /users/{id}
```

**Eventos publica**:
- `employees.user_registered.v1`
- `employees.user_role_changed.v1`
- `employees.negocio_created.v1`

**Persistencia**: PostgreSQL (tablas `negocios`, `usuarios_admin`, `invitaciones`).

**Auth scheme**: JWT RS256 con `kid` (key id) para rotación de llaves. Refresh token con rotación. Bcrypt cost 12.

---

### 5.3 `service-orders`

**Bounded context**: ciclo de vida del pedido (Kanban).

**Agregados**:
- `Pedido` (raíz): codigo_pedido, id_cliente, id_negocio, total, estado, fecha_hora, fecha_actualizacion, id_usuario_asignado.
- `DetallePedido` (entidad dentro): id_producto, cantidad, precio_unitario, descuento.
- `Cliente` (referencia ligera; el dueño puede ser otro servicio futuro).

**Estados** (máquina): `recibido` → `en_preparacion` → `listo` → `en_camino` → `entregado`. Transición ilegal = `DomainError`.

**Endpoints**:
```
GET    /orders                       ?estado=&desde=&hasta=&asignado_a=
GET    /orders/{id}
POST   /orders                       (manual o llamado por service-ai-agent)
PATCH  /orders/{id}/status           { estado }
PATCH  /orders/{id}/assign           { id_usuario }
DELETE /orders/{id}
GET    /orders/kpis/today
```

**Eventos publica**:
- `orders.created.v1`
- `orders.status_changed.v1`
- `orders.assigned.v1`
- `orders.deleted.v1`
- `orders.delayed.v1` (cuando excede SLA configurable)

**Eventos consume**:
- `ai.order_intent_parsed.v1` → crea Pedido
- `inventory.stock_depleted.v1` → marca producto no disponible en pedidos abiertos
- `printing.completed.v1` → marca ticket impreso

**Persistencia**: PostgreSQL (tablas `pedidos`, `detalle_pedido`, `clientes`).

**Redis**: cache de pedidos activos por negocio (TTL 60s) para Kanban responsivo.

---

### 5.4 `service-inventory`

**Bounded context**: catálogo y stock.

**Agregados**:
- `Producto`: nombre, descripcion, codigo, precio, stock, descuento, id_negocio, disponible.
- `Categoria`: nombre, emoji, id_negocio.

**Endpoints**:
```
GET    /inventory/products           ?categoria=&disponible=
GET    /inventory/products/{id}
POST   /inventory/products
PATCH  /inventory/products/{id}
PATCH  /inventory/products/{id}/stock     { delta: int }
DELETE /inventory/products/{id}
GET    /inventory/categories
POST   /inventory/categories
DELETE /inventory/categories/{id}
GET    /inventory/menu                    (snapshot público para AI agent)
```

**Eventos publica**:
- `inventory.product_created.v1`
- `inventory.product_updated.v1`
- `inventory.stock_updated.v1`
- `inventory.stock_low.v1` (cuando stock < umbral)
- `inventory.stock_depleted.v1` (cuando stock = 0)

**Eventos consume**:
- `orders.created.v1` → descuenta stock atómicamente
- `orders.deleted.v1` → reintegra stock si estado ≠ entregado

**Persistencia**: PostgreSQL (tablas `productos`, `categorias`).

---

### 5.5 `service-ai-agent` (RF-01 + RF-04)

**Bounded context**: ingesta de pedidos por canales (WhatsApp/Telegram) + procesamiento LLM.

**Agregados**:
- `PlantillaIA`: codigo, prompt, caso_uso, id_negocio.
- `Conversacion`: id_canal, id_cliente, mensajes[].
- `IntentParsed`: tipo (`pedido`/`consulta`/`reclamo`), payload extraído.

**Endpoints**:
```
POST   /webhooks/whatsapp            (Meta WhatsApp Business Cloud API)
POST   /webhooks/telegram            (alternativa o periodo transición)
GET    /ai/templates                 ?negocio=
POST   /ai/templates
PATCH  /ai/templates/{id}
DELETE /ai/templates/{id}
POST   /ai/templates/{id}/activate
GET    /ai/conversations             ?cliente=&desde=
POST   /ai/test-prompt               (sandbox)
```

**Eventos publica**:
- `ai.message_received.v1`
- `ai.intent_parsed.v1` (consumido por orders para crear pedido)
- `ai.response_sent.v1`
- `ai.transcription_completed.v1` (RF-04 voz → texto)

**Eventos consume**:
- `inventory.product_updated.v1` → refresca menú en contexto LLM
- `orders.status_changed.v1` → notifica al cliente automáticamente por WhatsApp

**LLM**: multi-vendor con feature flag por negocio (default DeepSeek por costo, fallback a Anthropic/OpenAI).

**Multimodal**:
- Audio → Whisper (`openai-whisper` local o API).
- Imágenes → Vision (Claude Vision / GPT-4o).
- Archivos → S3 con presigned URLs.

**Persistencia**: PostgreSQL (`plantillas_ia`, `conversaciones`) + MongoDB (`mensajes` para flexibilidad de schema) + S3 (audio/imágenes).

---

### 5.6 `service-notifications` (RF-03)

**Bounded context**: dispatch de notificaciones a usuarios y clientes.

**Canales**:
- Push móvil (FCM) → app Flutter.
- WhatsApp out (vía Meta API, reusa creds de service-ai-agent).
- Email (SES / SMTP).
- In-app (websocket o SSE) — opcional V2.

**Endpoints**:
```
GET    /notifications                ?leido=&desde=
PATCH  /notifications/{id}/read
POST   /notifications/read-all
POST   /devices                      (registrar FCM token)
DELETE /devices/{token}
GET    /preferences
PATCH  /preferences
```

**Eventos consume** (puro consumer, casi no publica):
- `orders.created.v1` → notifica al equipo del negocio.
- `orders.status_changed.v1` → notifica al cliente final (vía WhatsApp).
- `inventory.stock_low.v1` → notifica al gerente.
- `employees.user_registered.v1` → email bienvenida.

**Eventos publica**:
- `notifications.delivered.v1`
- `notifications.failed.v1`

**Persistencia**: MongoDB (lista de notifs por usuario, schema flexible) + Redis (push token registry, TTL).

---

### 5.7 `service-printing` (RF-05 + RF-08)

**Bounded context**: integración con POS / impresora térmica para tickets.

**Endpoints**:
```
POST   /printing/jobs                { pedido_id, formato }
GET    /printing/jobs/{id}/status
GET    /printers                     (negocio + impresoras registradas)
POST   /printers
DELETE /printers/{id}
POST   /printers/{id}/test
```

**Eventos consume**:
- `orders.status_changed.v1` (cuando pasa a `en_preparacion` → imprime comanda; `listo` → imprime ticket envío).

**Eventos publica**:
- `printing.requested.v1`
- `printing.completed.v1`
- `printing.failed.v1`

**Persistencia**: PostgreSQL (`impresoras`, `print_jobs`) + Redis (cola de jobs).

**Integración**: ESC/POS (térmicas USB/red), o adaptador a SDK POS específico (PrintPlus, Square, etc.). Empieza con un mock que escribe a archivo y publica `completed`.

---

### 5.8 `service-analytics` (RF-07)

**Bounded context**: lectura agregada (CQRS lado read).

Es un **read model puro**. Consume eventos de todos los servicios, materializa vistas optimizadas para KPIs y gráficas del dashboard.

**Endpoints**:
```
GET    /analytics/dashboard          ?desde=&hasta=&negocio=
GET    /analytics/orders/by-day      ?desde=&hasta=
GET    /analytics/revenue            ?periodo=hoy|semana|mes
GET    /analytics/top-products
GET    /analytics/avg-prep-time
GET    /analytics/conversion         (mensajes IA → pedidos)
GET    /analytics/employees/{id}/performance
```

**Eventos consume**:
- `orders.created.v1`, `orders.status_changed.v1`, `orders.deleted.v1`
- `inventory.stock_updated.v1`
- `ai.intent_parsed.v1`, `ai.response_sent.v1`
- `employees.user_registered.v1`

**Eventos publica**: ninguno (solo lee).

**Persistencia**: **MongoDB** (vistas materializadas) + **Redis** (cache de KPIs hot, TTL 30s).

**Procesamiento**: consumer Kafka con `faust-streaming` o un consumer plano que actualiza Mongo. Para tiempo real, opcional `Materialize` / `RisingWave` en V2.

---

### 5.9 `service-review` (RF-06) — opcional MVP

**Bounded context**: cola de pedidos que requieren intervención humana (IA dudó, cliente reclama).

Si el equipo es pequeño: **incluir como módulo dentro de `service-orders`** (paquete `review/` interno). Separar a servicio cuando haya >2 devs dedicados.

**Cuando exista**:
```
GET    /review/queue                 ?negocio=&prioridad=
GET    /review/queue/{id}
POST   /review/queue/{id}/resolve    { decision, nota }
```

Consume `ai.intent_uncertain.v1` + `orders.delayed.v1`. Publica `review.resolved.v1`.

---

## 6. Catálogo de eventos Kafka

Topics nombrados `<dominio>.<evento>.v<version>`. Schemas en `shared/event-schemas/` como Pydantic models.

| Topic | Productor | Consumidores | Payload mínimo |
|---|---|---|---|
| `orders.created.v1` | service-orders | notifications, analytics, inventory, ai-agent, printing | `{order_id, negocio_id, cliente_id, total, items[], canal, ts}` |
| `orders.status_changed.v1` | service-orders | notifications, analytics, printing, ai-agent | `{order_id, from, to, by_user_id, ts}` |
| `orders.assigned.v1` | service-orders | notifications, analytics | `{order_id, user_id, ts}` |
| `orders.deleted.v1` | service-orders | analytics, inventory | `{order_id, reason, ts}` |
| `orders.delayed.v1` | service-orders | review, notifications | `{order_id, expected_ts, ts}` |
| `inventory.product_created.v1` | service-inventory | ai-agent (refresh menú) | `{product_id, negocio_id, …}` |
| `inventory.product_updated.v1` | service-inventory | ai-agent | `{product_id, …}` |
| `inventory.stock_updated.v1` | service-inventory | analytics | `{product_id, before, after, ts}` |
| `inventory.stock_low.v1` | service-inventory | notifications | `{product_id, stock, umbral, ts}` |
| `inventory.stock_depleted.v1` | service-inventory | orders, notifications | `{product_id, ts}` |
| `ai.message_received.v1` | service-ai-agent | analytics | `{conversation_id, canal, cliente_id, ts}` |
| `ai.intent_parsed.v1` | service-ai-agent | orders, analytics | `{conversation_id, intent, payload}` |
| `ai.intent_uncertain.v1` | service-ai-agent | review | `{conversation_id, confianza, ts}` |
| `ai.response_sent.v1` | service-ai-agent | analytics | `{conversation_id, ts}` |
| `ai.transcription_completed.v1` | service-ai-agent | (interno) | `{audio_url, texto, idioma}` |
| `printing.requested.v1` | service-printing | analytics | `{job_id, order_id, ts}` |
| `printing.completed.v1` | service-printing | orders, analytics | `{job_id, ts}` |
| `printing.failed.v1` | service-printing | notifications | `{job_id, error, ts}` |
| `employees.user_registered.v1` | service-employees | notifications, analytics | `{user_id, negocio_id, rol, ts}` |
| `employees.user_role_changed.v1` | service-employees | (todos validan permisos) | `{user_id, old, new, ts}` |
| `notifications.delivered.v1` | service-notifications | analytics | `{notif_id, canal, ts}` |
| `notifications.failed.v1` | service-notifications | analytics | `{notif_id, canal, error, ts}` |

**Convenciones**:
- Idempotency: cada evento lleva `event_id` UUID v7 + `producer_id`. Consumers desduplican.
- Outbox pattern: cada servicio escribe el evento en su DB en la misma transacción que el cambio de estado; un worker lo publica a Kafka.
- Versionado: cuando cambias schema breaking, sube `.v2` y mantén `.v1` hasta que todos los consumers migren.
- Particionado por `negocio_id` para preservar orden por tenant.

---

## 7. Persistencia detallada

| Servicio | Tecnología | Justificación |
|---|---|---|
| api-gateway | (sin DB) | stateless, usa Redis solo para rate limit |
| service-employees | **PostgreSQL** | relacional puro, integridad fuerte |
| service-orders | **PostgreSQL** | transacciones ACID en cambio de estado |
| service-inventory | **PostgreSQL** | stock atómico, FK a categorías |
| service-ai-agent | **PostgreSQL** (plantillas) + **MongoDB** (mensajes) + **S3** (audio/img) | schema mixto; mensajes flexibles |
| service-notifications | **MongoDB** + **Redis** | high write, query por user, push tokens en Redis |
| service-printing | **PostgreSQL** + **Redis** (cola) | jobs duraderos, cola transitoria |
| service-analytics | **MongoDB** + **Redis** (hot KPI) | vistas materializadas, agregaciones flexibles |
| service-review | (depende, comparte con orders al inicio) | — |

**Importante**: cada servicio tiene **su propia BD** (instancia o schema separado). NO compartir tablas entre servicios — eso mata microservicios.

**ER original** (`Database ER diagram ProntoApp.png`) se reparte así:
- `Negocios`, `Usuarios_Admin` → service-employees.
- `Clientes`, `Pedidos`, `Detalle_Pedido` → service-orders.
- `Productos` → service-inventory.
- `Plantillas_IA` → service-ai-agent.

---

## 8. Migración del cliente Flutter

El cliente actual llama a `http://localhost:5050` con 2 endpoints (`/pedidos`, `/inventario`) y header `X-Secret`. Nuevo contrato:

### 8.1 Cambios obligatorios en `lib/`

| Hoy | Nuevo |
|---|---|
| `http://localhost:5050` hardcoded en `main.dart:38,46` | `dotenv.env['API_BASE_URL']` → `http://localhost:8000` (gateway dev) |
| Header `X-Secret: <token>` | Header `Authorization: Bearer <jwt>` |
| `GET /pedidos` | `GET /orders` |
| `PATCH /pedidos/{id}/estado` | `PATCH /orders/{id}/status` |
| `DELETE /pedidos/{id}` | `DELETE /orders/{id}` |
| `GET /inventario` (devuelve `{categorias, productos}`) | `GET /inventory/categories` + `GET /inventory/products` (2 llamadas o un endpoint agregado `/inventory/menu`) |
| `PUT /inventario` bulk | `POST /inventory/products`, `PATCH /inventory/products/{id}`, `PATCH /inventory/products/{id}/stock` (granular) |
| `AuthService` fake con SharedPreferences plaintext | `AuthService` real: `POST /auth/login` → JWT, guardar en `flutter_secure_storage` |
| Sin notificaciones push | Registrar FCM token: `POST /devices` |
| Polling 5s en order/inventory | Mantener polling V1; V2 reemplazar por SSE o WebSocket del gateway, o push FCM |
| Sin Agente IA real | Llamar `GET /ai/templates`, `POST /ai/templates`, etc. |
| Sin analytics real | KPIs leerán de `GET /analytics/dashboard` |

### 8.2 Generación de cliente Dart

Cada servicio publica OpenAPI en `/openapi.json`. En `ProntoApp--Back/tools/codegen/` poner script que:
1. Levanta los servicios en CI.
2. Descarga OpenAPI de cada uno.
3. Genera clientes Dart con `openapi-generator-cli` → `lib/api/<servicio>_client/`.
4. Commit auto en `ProntoApp-` por PR.

Esto elimina mantener manualmente Pydantic ↔ Dart fromJson/toJson.

### 8.3 Plan por fases (móvil)

| Fase | Cambio en Flutter | Bloquea |
|---|---|---|
| M1 | Migrar `main.dart` a `dotenv` + apuntar a `localhost:8000` | nada |
| M2 | Reemplazar `AuthService` por cliente JWT real | tener `service-employees` deployado |
| M3 | Migrar `OrderProvider` a `/orders` (mantener interface) | `service-orders` |
| M4 | Migrar `InventoryProvider` a `/inventory/*` | `service-inventory` |
| M5 | Activar push FCM + `service-notifications` | M3, M4 |
| M6 | Integrar Agente IA real (reemplazar UI teatro) | `service-ai-agent` |
| M7 | Dashboard KPIs desde analytics | `service-analytics` |

---

## 9. Roadmap implementación backend

**P0 — Walking Skeleton (semana 1-2)**:
- Workspace + Docker Compose + Makefile.
- `shared/` libs (auth-middleware, event-schemas, observability).
- `api-gateway` minimal (FastAPI con reverse proxy a uno).
- `service-employees` con login/JWT + 1 endpoint `/users/me`.
- Migración Flutter M1 + M2.
- CI básico (lint + test) GitHub Actions.

**P1 — Core MVP (semana 3-5)**:
- `service-orders` end-to-end + outbox + 1er consumer Kafka.
- `service-inventory` end-to-end.
- Flutter M3 + M4.
- Tests integración con testcontainers.

**P2 — Notificaciones + Impresión (semana 6-7)**:
- `service-notifications` con FCM.
- `service-printing` con mock que escribe a archivo.
- Flutter M5.

**P3 — IA real (semana 8-10)**:
- `service-ai-agent` con LLM multi-vendor + WhatsApp Business webhook.
- Migrar de Telegram a WhatsApp (o mantener ambos, vía feature flag).
- Flutter M6.

**P4 — Analytics + observabilidad (semana 11-12)**:
- `service-analytics` con Mongo.
- OpenTelemetry traces + Grafana dashboards.
- Flutter M7.

**P5 — Hardening (semana 13-14)**:
- Rate limiting fino.
- Backup automatizado.
- DR runbook.
- Load testing (k6).
- Deploy real a K8s/EKS.

---

## 10. ADRs requeridos antes de empezar a codificar

Crear en `ProntoApp--Back/docs/ADRs/`. Sirven como contrato del equipo.

1. **0001-microservicios-vs-monolito-modular**: por qué microservicios desde día 1 (justificación: cliente Flutter ya hablará con múltiples servicios y RFs son claramente bounded contexts) — o, alternativa: empezar monolito modular y extraer cuando duela.
2. **0002-hexagonal-por-servicio**: ports & adapters como estándar interno; reglas de dependencia.
3. **0003-python-fastapi-stack**: Python 3.12 + FastAPI + SQLAlchemy 2 async como default.
4. **0004-kafka-vs-rabbit**: por qué Kafka (replay, particionado por tenant, ecosistema streams).
5. **0005-auth-jwt-rs256-stateless**: JWT con clave asimétrica + key rotation; sin sesiones server-side.
6. **0006-llm-multi-vendor**: estrategia para 4 modelos (DeepSeek default, Claude/GPT/Gemini fallback), feature flag por negocio.
7. **0007-canal-whatsapp-vs-telegram**: decisión definitiva (bloqueada por respuesta de producto; ver `docs/CODEX_HANDOFF.md §6.1.1`).
8. **0008-outbox-pattern**: para garantía at-least-once con transacciones DB + Kafka.
9. **0009-bd-por-servicio**: una BD por servicio, prohibido shared DB.
10. **0010-codegen-openapi-dart**: cliente Flutter generado desde OpenAPI, no escrito a mano.

---

## 11. Preguntas que necesitas resolver con el owner antes de scaffolding

| # | Pregunta | Impacto |
|---|---|---|
| Q1 | ¿WhatsApp Business API (Meta) o Telegram bot? | Bloquea `service-ai-agent` completo |
| Q2 | ¿Cloud target: AWS / GCP / Azure / self-hosted? | Cambia `infra/terraform/` + servicios gestionados (RDS, MSK, S3 vs equivalentes) |
| Q3 | ¿Tenemos presupuesto para 4 LLMs o sólo 1 al inicio? | Simplifica `service-ai-agent` (1 cliente vs strategy pattern) |
| Q4 | ¿El doc de formulación se reescribe ahora o después de tener MVP? | Si ahora: invertir antes de codificar |
| Q5 | ¿Soporte multitenant real (varios negocios en una instancia) o single-tenant (un deploy por negocio)? | Cambia diseño de aislamiento (schema vs row level vs cluster per tenant) |
| Q6 | ¿Hay un POS objetivo (marca/modelo)? | Define adapter en `service-printing` |
| Q7 | ¿Quién es el equipo (cuántos devs, qué expertise)? | Si <3 devs: empezar monolito modular y extraer servicios después |
| Q8 | ¿Plazo MVP? | Si <3 meses: cortar `service-review`, `service-printing` real, multimodal voz/imagen |

---

## 12. Próximo paso inmediato

Tres opciones, **elegir una**:

**A) Scaffolding completo automático**: yo creo en `ProntoApp--Back/` el árbol de carpetas, plantillas vacías por servicio, Docker Compose, Makefile, README, ADRs vacíos. Cero código de negocio. Punto de partida en ~30 min.

**B) Scaffolding de UN servicio piloto** (`service-employees` recomendado, porque desbloquea auth para todos los demás). Lo dejo funcional con login + JWT + testcontainers. Resto se queda en doc. ~2 horas.

**C) Quedarse en doc**: este archivo + ADRs vacíos. Codifica el equipo cuando hayan respondido Q1-Q8.

**Recomendación**: **A**, luego responder Q1-Q8, luego **B** sobre service-employees, después el resto en orden P0→P5 del §9.

---

## Apéndice — Mapeo rápido de carpetas

| Concepto hexagonal | Carpeta concreta dentro de `services/<svc>/src/<svc>/` |
|---|---|
| Entidades + value objects | `domain/entities/`, `domain/value_objects/` |
| Reglas de negocio puras | `domain/services/` |
| Interfaces (ports) | `domain/ports/` |
| Casos de uso | `application/commands/`, `application/queries/` |
| Adaptadores de salida (DB, Kafka, HTTP out) | `infrastructure/persistence/`, `infrastructure/messaging/`, `infrastructure/external/` |
| Adaptadores de entrada (HTTP in, Kafka consumers) | `interface/http/`, `interface/events/` |
| Configuración + DI wiring | `infrastructure/config/`, `infrastructure/di.py` + `main.py` |
| Tests | `tests/unit/`, `tests/integration/`, `tests/e2e/` |

Cualquier archivo que importe `fastapi`, `sqlalchemy`, `aiokafka`, `httpx`, `redis` vive en `infrastructure/` o `interface/`. Si lo encuentras en `domain/` o `application/`, **bug arquitectural**.
