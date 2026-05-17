# Plan ejecución — Fases 0 a 7

**Origen:** sesión 2026-05-16 — schema V2 deployed.
**Estilo:** seguro, incremental, validable, multi-agente.

---

## Fase 0 — Snapshot (HOY, 15 min) [Claude]

1. Commit backend `ProntoApp--Back`:
   ```
   feat(dataconnect): reformular schema V2 unificado + migrations + docs

   - Consolida 5 archivos .gql en schema.gql unico
   - Anade Pago, DireccionCliente, IntegracionMensajeria
   - Reformula bloque IA: PlantillaIa mejorada, SesionAgente, MensajeAgente, EjecucionAgente, DocumentoConocimiento, HerramientaIa
   - Separa CanalOperacion/ActorOperacion (antes OrigenOperacion mezclado)
   - EstadoPedido canon V2 + legacy deprecado
   - Estado pago separado de estado pedido
   - Snapshots inmutables direccion en Pedido
   - Trigger stock snapshot via migration 001
   - pgvector + index HNSW via migration 002 (vector(1536))
   - Operations alineadas: queries.gql renames + nuevas (ObtenerIntegracionesMensajeria)
   - schemaValidation: STRICT
   - Cloud SQL drop+migrate ejecutado limpio
   ```

2. Commit frontend `ProntoApp-`:
   - Solo `.firebase/` añadido a `.gitignore`.
   - Plus docs/sesiones/HANDOFF + PLAN.

3. Tags: `git tag schema-v2-deployed` en ambos repos.

**Salida:** historial limpio, rollback posible.

---

## Fase 1 — SDK regen + smoke (30 min) [Claude]

1. `cd C:/WorkSpace-Vs-Code/ProntoApp--Back && firebase dataconnect:sdk:generate`
2. Verificar `lib/generated/prontoapp_dataconnect` se regenera correcto.
3. `cd C:/WorkSpace-Vs-Code/ProntoApp- && flutter pub get`
4. `flutter analyze` — espera errores en providers usando campos viejos. Snapshot output a `docs/frontend-mobile/ANALYZE_POST_SCHEMA_V2.md` (no arreglar aún).
5. `flutter build apk --debug --no-shrink` (opcional, valida pipeline build).

**Salida:** SDK V2 listo, gaps Flutter identificados.

---

## Fase 2 — Seed plantillas + herramientas IA (1 h) [Claude]

1. SQL `dataconnect/migrations/003_seed_plantillas_globales.sql`:
   - `INGESTA_PEDIDO` (Gemini Flash) — parse mensaje cliente, llama `buscar_producto` + `crear_pedido`.
   - `ATENCION_CLIENTE` (Gemini Flash + RAG) — responde dudas usando `buscar_conocimiento`.
   - `RECOMENDACION_PRODUCTO` (Gemini Pro) — sugiere top productos por contexto.
   - `RESUMEN_CONVERSACION` (Gemini Flash) — rolling summary para sesiones largas.

2. SQL `004_seed_herramientas.sql`:
   - `buscar_producto(negocio_id, query, top_k)` → schema input.
   - `buscar_conocimiento(negocio_id, query, tipos[], top_k)` → RAG.
   - `crear_pedido(negocio_id, cliente_id, items[], direccion?)` → HTTP service-orders.
   - `consultar_pedido(codigo_pedido)` → status.
   - `cambiar_estado_pedido(pedido_id, estado_nuevo, motivo?)` → HTTP service-orders (requiere `requiereConfirmacion=true`).

3. Aplicar via firebase shell.

**Salida:** plantillas + tools registradas, runtime puede arrancar.

---

## Fase 3 — ADRs (1-2 h) [Claude]

**Archivos a crear:**

- `ProntoApp--Back/docs/ADRs/0012-agente-ia-langgraph-litellm.md`
  - Contexto: necesidad agente multi-vendor multi-tenant.
  - Decisión: LangGraph + LiteLLM + Pydantic v2 + PostgresSaver + LangSmith.
  - Alternativas consideradas: Pydantic AI, CrewAI, OpenAI Agents SDK, Google ADK.
  - Consecuencias: lock-in moderado LangGraph, abstracción vendor vía LiteLLM mitiga.

- `ProntoApp--Back/docs/ADRs/0013-multi-canal-mensajeria.md`
  - Contexto: WhatsApp + Telegram desde V1.
  - Decisión: `IntegracionMensajeria` polimórfica + Secret refs.
  - Webhooks por canal en `service-ai-agent/interface/webhooks/`.

- `ProntoApp--Back/docs/ADRs/0014-rag-embeddings-google-gemini.md`
  - Contexto: necesitamos RAG por negocio sin costo OpenAI.
  - Decisión: Google `gemini-embedding-001` con dim=1536, pgvector + HNSW, re-embed event-driven.
  - Alternativas: OpenAI (costo), Voyage (mejor calidad pero $$), local sentence-transformers (latencia + ops overhead).
  - Riesgos: cuota gratuita 1M tok/día limitada → fallback LiteLLM a otro vendor si exhaust.

- `ProntoApp-/docs/arquitectura/0001-flutter-firebase-auth-sdk-sqlconnect.md`
  - Cómo Flutter pasa de localhost+X-Secret a Firebase Auth + SDK SQL Connect + FastAPI ID-token.

**Salida:** decisiones documentadas, auditables.

---

## Fase 4 — Scaffold service-ai-agent (2-3 días) [Codex paralelo + Claude review]

### Sub-fase 4.1 — Estructura base [Codex tarea 1]

Delegar Codex con prompt:
```
Crea estructura Python hexagonal para services/service-ai-agent en
C:\WorkSpace-Vs-Code\ProntoApp--Back\services\service-ai-agent.

Sigue patrón de otros services del repo (revisa services/service-orders y
service-inventory existentes para conventions).

Stack:
- Python 3.12, FastAPI async, uvicorn
- langgraph>=0.2, litellm>=1.50, pydantic>=2.0
- pg8000 (Cloud SQL Postgres)
- google-genai (para embeddings gemini-embedding-001)
- opentelemetry-api/sdk, opentelemetry-instrumentation-fastapi
- pytest, pytest-asyncio, respx

Estructura:
src/agent/
  domain/{graphs,tools,services,models}/
  infrastructure/{llm,embeddings,repos,checkpointer,messaging}/
  interface/{webhooks,http}/
  observability/

Genera:
- pyproject.toml deps
- Dockerfile (base python:3.12-slim, multi-stage)
- main.py FastAPI app + healthcheck + OTel init
- src/agent/infrastructure/llm/litellm_client.py — wrapper LiteLLM con load de PlantillaIa desde DB
- src/agent/infrastructure/embeddings/gemini_embedder.py — usa google-genai con outputDimensionality=1536
- src/agent/infrastructure/repos/conocimiento_repo.py — query pgvector top-k cosine via pg8000
- src/agent/infrastructure/checkpointer.py — LangGraph PostgresSaver init
- conftest.py pytest fixtures
- README.md explicando estructura y cómo levantar local

NO implementes graphs aún. Solo skeleton + LLM/embedder/repo bases con stubs y tests unitarios pasando.

Reporta a docs/backend/service-ai-agent-SCAFFOLD.md con: estructura creada, deps elegidas, decisiones, gaps identificados, próximos pasos.
```

### Sub-fase 4.2 — RAG tool + graph atención cliente [Codex tarea 2, depende 4.1]

```
Implementa primer flujo end-to-end en service-ai-agent:

1. Tool buscar_conocimiento(negocio_id, query, tipos=['MENU','FAQ','POLITICA','NEGOCIO'], top_k=6):
   - Embed query con gemini_embedder.
   - Query documentos_conocimiento con pgvector cosine, filtrado por negocio_id.
   - Devuelve lista [{id, tipo, titulo, contenido, similitud}].

2. Endpoint POST /v1/conocimiento/reindexar/{negocio_id}:
   - Lee todos los productos activos de negocio_id (via SQL Connect HTTP API o pg directo).
   - Para cada: genera embedding(nombre + descripcion + categoria.nombre + precio).
   - Upsert en documentos_conocimiento tipo='MENU'.

3. LangGraph 'atencion_cliente':
   Nodos: cargar_sesion → recuperar_contexto (RAG) → componer_prompt → llm_responder → persistir_mensaje.
   Estado: AgentState(sesion_id, negocio_id, mensaje_usuario, contexto_recuperado, respuesta).

4. Endpoint POST /v1/sesiones/{sesion_id}/mensajes:
   - Crea o reusa SesionAgente.
   - Invoca graph atencion_cliente.
   - Persiste MensajeAgente (usuario + asistente) y EjecucionAgente (tokens, costo).

5. Tests integración con LLM mockeado (respx + litellm mock_response).

Documenta en docs/agente-ia/RAG_PIPELINE.md y docs/agente-ia/GRAPH_ATENCION_CLIENTE.md.
```

### Sub-fase 4.3 — Ingesta pedido + webhooks [Codex tarea 3]
Graph `ingesta_pedido` con tool `crear_pedido` (HTTP a service-orders), webhook Telegram + WhatsApp Cloud.

**Claude review:** code review cada PR Codex antes merge.

---

## Fase 5 — Persistencia services backend (1-2 días) [Codex paralelo]

```
Implementa adapters Cloud SQL en service-orders y service-inventory.

Para service-orders:
- src/orders/infrastructure/repos/pedido_repo.py: CRUD + transition con UPDATE atomic.
- src/orders/infrastructure/outbox/outbox_publisher.py: inserta EventoOutbox en misma transacción.
- src/orders/interface/http/pedidos.py: implementa POST /v1/pedidos, POST /v1/pedidos/{id}/estado contra Cloud SQL.
- Usa pg8000 con connection pool.
- Schema separado por tenant via negocio_id WHERE filter en cada query.
- Tests integration con testcontainers postgres.

Para service-inventory:
- src/inventory/infrastructure/repos/movimiento_stock_repo.py: INSERT append-only (trigger actualiza productos.stock).
- src/inventory/interface/http/inventario.py: implementa POST /v1/productos/{id}/movimientos-stock.

Documenta en docs/backend/service-orders-PERSISTENCIA.md y docs/backend/service-inventory-PERSISTENCIA.md.
```

---

## Fase 6 — Migración Flutter (2-3 días) [Codex tarea grande, Claude review]

### Sub-fase 6.1 — Auditoría detallada [Codex tarea]

```
Audita C:\WorkSpace-Vs-Code\ProntoApp- screen por screen.

Para cada pantalla:
- Verifica widgets renderizan correcto (no theater).
- Identifica datos hardcoded vs reales.
- Lista campos que esperan SDK SQL Connect V2 (nuevo schema).
- Mide LOC + complejidad ciclomática.
- Anota anti-patrones (god widgets, color literals, magic numbers).

Output: docs/frontend-mobile/AUDITORIA_PANTALLAS.md con tabla:
| Pantalla | LOC | Theater% | Acción | Prioridad |

NO refactorices aún. Solo reporta.
```

### Sub-fase 6.2 — Firebase Auth real [Codex tarea]

```
Reemplaza auth fake en ProntoApp-:
- Borra hardcoded users en lib/data/services/auth_service.dart.
- Implementa flujo Firebase Auth (email/password + Google sign-in).
- Tras login: resuelve UsuarioAdmin via SDK SQL Connect (firebaseUid=auth.uid → negocioId + cargo).
- Persiste sesión via firebase_auth (no SharedPreferences).
- AuthGuard en navegación según cargo.

Borra:
- X-Secret hardcoded en lib/main.dart.
- http://localhost:5050 references.
- Plaintext password seeds.

Tests widget AuthScreen flujo happy path.

Documenta en docs/frontend-mobile/FIREBASE_AUTH_REAL.md.
```

### Sub-fase 6.3 — Providers SDK SQL Connect [Codex tarea]

```
Reemplaza providers en lib/data/providers/:
- order_provider.dart: usa ObtenerPedidosKanban del SDK generado.
- inventory_provider.dart: usa ObtenerMenuInventario.
- Polling 5s → stream listener (firebase_data_connect supports subscriptions? Si no, mantener polling pero con retry/backoff).

Comandos críticos (cambiar estado, crear pedido) van a FastAPI service-orders con Firebase ID token.

Documenta en docs/frontend-mobile/PROVIDERS_SQLCONNECT.md.
```

### Sub-fase 6.4 — Vistas configuración faltantes [Codex tarea]

```
Asegura app tenga TODAS las vistas configuración:
- Perfil usuario (editar).
- Negocio (datos, horarios, formato_entrega).
- Categorías + Productos CRUD.
- Plantillas IA UI conectada a SDK SQL Connect (no theater).
- Integraciones mensajería (WhatsApp + Telegram setup).
- Pasos flujo pedido (configurar estados + SLA).
- Pasos invitación equipo.

Genera screens faltantes siguiendo patrón existente pero LIMPIO:
- Sin god widgets (componer).
- Usar AppColors + AppTextStyles consistente.
- Sin color literals.
- Con Semantics para accesibilidad.

Documenta en docs/frontend-mobile/VISTAS_CONFIGURACION.md.
```

### Sub-fase 6.5 — Limpiar deudas [Codex tarea]

```
Refactor:
- 19 god widgets >400 LOC → split en componentes.
- 812 color literals → AppColors constants.
- 23 LinearGradient → ButtonStyles centralizado.
- TextField inline → CustomTextField uniforme.

Genera widgets compartidos en lib/ui/components/.

Documenta en docs/frontend-mobile/REFACTOR_DEUDAS.md.
```

---

## Fase 7 — Hardening (continuo) [mixto]

- Tests pytest service-ai-agent (>80% cobertura domain).
- Tests integration Flutter widgets críticos.
- LangSmith tracing dashboards.
- OTel exporters Cloud Trace.
- Rate limiting per-negocio (Redis token bucket).
- Cost monitoring: query agregado `EjecucionAgente` por día/negocio.
- Re-indexar conocimiento: consumer Kafka `producto.actualizado.v1`.

---

## Patrón orquestación

1. Claude lee handoff + arquitectura → entiende contexto.
2. Claude prepara prompts para Codex (con criterio aceptación + ubicación docs).
3. Claude lanza Codex en paralelo (3-4 simultáneos) usando `codex:rescue` con tareas independientes.
4. Mientras Codex trabaja, Claude:
   - Escribe ADRs.
   - Genera SQL seeds.
   - Hace review de PRs anteriores.
5. Codex reporta → Claude review → merge o re-delegar fix.
6. Cada commit incluye doc actualizado.
7. Al final de sesión: nuevo handoff en `docs/sesiones/HANDOFF_YYYY-MM-DD.md`.
