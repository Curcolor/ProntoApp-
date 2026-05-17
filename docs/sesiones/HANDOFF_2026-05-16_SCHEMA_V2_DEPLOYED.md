# Handoff — Sesión 2026-05-16 → Próxima sesión

**Estado:** Schema Firebase Data Connect V2 desplegado en Cloud SQL. Listo para orquestar trabajo multi-agente (Claude Code + Codex CLI) en backend + Flutter en paralelo.

---

## 1. Prompt para abrir nueva sesión (copiar literal)

> Soy Junior. Continuamos ProntoApp — sistema móvil Flutter Android + backend FastAPI microservicios + Firebase Data Connect sobre Cloud SQL Postgres, multi-tenant para MiPyme food (panaderías/restaurantes/cafés).
>
> **Lo último ejecutado (sesión anterior, 2026-05-16):** Schema V2 reformulado y desplegado. Lee primero `docs/sesiones/HANDOFF_2026-05-16_SCHEMA_V2_DEPLOYED.md` para contexto completo. Luego lee en este orden:
> 1. `C:\WorkSpace-Vs-Code\ProntoApp--Back\docs\SCHEMA_V2_REFORMULADO.md` (qué cambió y por qué)
> 2. `C:\WorkSpace-Vs-Code\ProntoApp--Back\dataconnect\schema\schema.gql` (schema unificado actual)
> 3. `C:\WorkSpace-Vs-Code\ProntoApp-\docs\ARCHITECTURE_REVIEW.md` (auditoría Flutter)
> 4. `C:\WorkSpace-Vs-Code\ProntoApp-\docs\BACKEND_ARCHITECTURE.md`
> 5. `C:\WorkSpace-Vs-Code\ProntoApp--Back\docs\ARCHITECTURE.md`
> 6. `C:\WorkSpace-Vs-Code\ProntoApp--Back\docs\ADRs\0011-firebase-sql-connect-postgres.md`
>
> **Decisiones cerradas (no re-debatir):**
> - Multi-canal V1: WhatsApp Cloud + Telegram simultáneo. Tabla `IntegracionMensajeria` polimórfica.
> - `EstadoPedido` canon V2 + legacy deprecado (LISTO/EN_CAMINO/PAGADO retenidos compat, no usar en transiciones nuevas).
> - Framework agente IA: **LangGraph + LiteLLM** + Pydantic v2 + LangSmith/OTel.
> - Stock: snapshot en `Producto.stock` mantenido por trigger Postgres, source-of-truth = `MovimientoStock`.
> - **Embeddings: Google `gemini-embedding-001` con `outputDimensionality=1536`** (capa gratuita, sin OpenAI por ahora). Schema `documentos_conocimiento.embedding vector(1536)` + index HNSW listos.
> - RAG: pgvector. Re-embed vía Kafka event-driven (`producto.actualizado.v1`).
> - Schema separado backend `ProntoApp--Back` / mobile `ProntoApp-`.
>
> **Cloud:**
> - Proyecto Firebase: `test-firestore-c77ab`
> - Servicio SQL Connect: `test-firestore-c77ab-2-service` (us-east4)
> - Cloud SQL: `test-firestore-c77ab-instance` / DB `test-firestore-c77ab-2-database`
> - Cuenta: solano200801@gmail.com
> - Billing: NO habilitada → sin Secret Manager por ahora.
> - Password postgres rotada, guardada externamente (no en repo).
>
> **Plan ordenado a ejecutar:**
> Lee `docs/sesiones/PLAN_EJECUCION_FASES_0-7.md` para detalle. Resumen:
> - Fase 0: commits estado actual (HOY).
> - Fase 1: regen SDK Dart + smoke compile.
> - Fase 2: seed plantillas IA + herramientas.
> - Fase 3: ADRs 0012 LangGraph, 0013 multi-canal, 0014 RAG.
> - Fase 4: scaffold `service-ai-agent` (LangGraph + LiteLLM + Google embeddings).
> - Fase 5: persistencia `service-orders` + `service-inventory` Cloud SQL.
> - Fase 6: migración Flutter providers → SDK SQL Connect + FastAPI con Firebase ID token.
> - Fase 7: hardening, tests, observabilidad.
>
> **Orquestación multi-agente requerida:**
> Tengo cuota Codex disponible. Quiero que **delegues tareas paralelas via Codex CLI plugin** (`codex:rescue` / `codex:codex-rescue`) para acelerar. Tú orquestas, Codex ejecuta sub-tareas paralelas: una rama backend, otra Flutter, otra docs. Cada agente reporta a ti, tú integras.
>
> **Trabajo Flutter requerido:**
> App actual con anti-patrones (theater UI, auth fake, providers HTTP localhost, 19 god widgets, secret hardcoded, sin tests, 812 color literals). Hay que:
> - Reemplazar auth fake por Firebase Auth real.
> - Borrar `localhost:5050` + `X-Secret` hardcoded.
> - Reemplazar polling HTTP por SDK SQL Connect generado.
> - Verificar widgets se rendericen correctos (no theater).
> - Asegurar app tenga TODAS las vistas configuración (perfil, agente IA, integraciones mensajería, inventario, plantillas).
> - Funcionalidad explorable end-to-end alineada a servicios backend.
>
> **Documentación obligatoria:**
> Cada cambio/decisión/error/gap documentar en `docs/` con esta estructura:
> ```
> docs/
> ├── sesiones/             # handoffs entre sesiones + bitácora
> ├── arquitectura/         # ADRs, decisiones técnicas, diagramas
> ├── backend/              # cambios services + dataconnect schema
> ├── frontend-mobile/      # decisiones Flutter, widgets, navegación
> ├── agente-ia/            # graphs LangGraph, prompts, tools, RAG
> ├── producto/             # visión, alcance, CU, RF/RNF
> └── gaps-y-pendientes/    # backlog técnico, deudas, blockers
> ```
> Cada agente Codex que delegues debe entregar su pieza con doc actualizado en la carpeta correspondiente.
>
> **Empieza por:** confirmar lectura de docs, luego Fase 0 (commits) + Fase 1 (SDK regen) en paralelo. Después delega Codex para arrancar Fase 4 backend + Fase 6 frontend mientras tú escribes ADRs Fase 3.
>
> **Modo autónomo `/goal`:** Quiero que actives `/goal` para mantener trabajo entre turnos sin que yo te empuje cada paso. Condición sugerida (pégala literal en `/goal`):
>
> ```
> /goal Fases 0-7 del plan en docs/sesiones/PLAN_EJECUCION_FASES_0-7.md ejecutadas y documentadas. Criterio: (1) commits Fase 0 hechos en ambos repos con tag schema-v2-deployed; (2) SDK Dart regenerado y flutter analyze report grabado en docs/frontend-mobile/ANALYZE_POST_SCHEMA_V2.md; (3) seeds plantillas+herramientas aplicados Fase 2; (4) ADRs 0012/0013/0014 escritos; (5) service-ai-agent scaffold con RAG endpoint /v1/conocimiento/reindexar y graph atencion_cliente funcionando contra mocks; (6) adapters Cloud SQL service-orders/service-inventory con tests integration verdes; (7) Flutter auth Firebase real + providers SDK SQL Connect + vistas configuracion garantizadas + refactor god widgets; (8) tests pytest service-ai-agent >80% domain cobertura. Para cada feature que NO pueda probarse por falta de config externa (billing GCP, WhatsApp WABA, Telegram bot token, Kafka cluster, etc), documentar en docs/gaps-y-pendientes/CONFIG_PENDIENTE.md con: que falta, donde configurarlo, comando/UI para hacerlo, costo estimado, prioridad. Delega tareas paralelas a Codex via codex:rescue cuando sea aceleracion segura. Cada turno deja registro en docs/sesiones/BITACORA_2026-05.md. Stop si: condicion completa, o 60 turnos consumidos, o blocker irrecuperable que requiera decision humana (documentar blocker en docs/gaps-y-pendientes/BLOCKERS.md y detener).
> ```
>
> **Reglas operativas durante el loop:**
> 1. Antes de cada feature nueva, verifica si puedes probarla end-to-end. Si NO puedes (falta auth externa, falta servicio, sin billing, sin sandbox WABA, etc) → documenta en `docs/gaps-y-pendientes/CONFIG_PENDIENTE.md` y sigue con la siguiente.
> 2. Cualquier cambio destructivo (drop schema, force push, borrar archivos sin Read previo) → detente y pregunta.
> 3. Cada commit incluye doc actualizado en subcarpeta correspondiente.
> 4. Auto mode ON para minimizar prompts permission (yo lo activo al abrir sesión).
> 5. Si un Codex delegado falla 2 veces seguidas, no insistas — documenta en `docs/gaps-y-pendientes/BLOCKERS.md` y continua tarea siguiente.
> 6. Cada 10 turnos, dump status corto a `docs/sesiones/BITACORA_2026-05.md`.

---

## 2. Estado infraestructura desplegada

| Componente | Estado | Ubicación |
|---|---|---|
| Schema V2 SDL | ✅ Desplegado | `dataconnect/schema/schema.gql` único |
| Operations | ✅ Alineadas | `dataconnect/prontoapp/queries.gql`, `mutations.gql` |
| Cloud SQL tablas | ✅ Recreadas (drop+migrate) | `test-firestore-c77ab-2-database` schema `public` |
| Trigger stock snapshot | ✅ Aplicado | function `fn_movimientos_stock_actualiza_snapshot` + trigger `trg_movimientos_stock_aiu` |
| pgvector extension | ✅ Habilitada | `vector(1536)` en `documentos_conocimiento.embedding` |
| Index HNSW | ✅ Creado | `idx_documentos_conocimiento_embedding` cosine_ops |
| `schemaValidation` | STRICT | `dataconnect.yaml` |
| SDK Dart Flutter | ⏳ Sin regenerar | `lib/generated/prontoapp_dataconnect` desactualizado |
| `service-ai-agent` | ❌ No existe | crear |
| Plantillas IA seed | ❌ Sin data | seed pendiente Fase 2 |

---

## 3. Decisiones cerradas (lock)

### 3.1 Multi-canal mensajería V1
WhatsApp Cloud API + Telegram Bot soportados desde el inicio. `IntegracionMensajeria` polimórfica con `canal: CanalMensajeria` (WHATSAPP_CLOUD/WHATSAPP_BUSINESS/TELEGRAM_BOT/WEBCHAT), credenciales referenciadas via `credencialSecretRef` (string ref, NO secreto en BD).

### 3.2 EstadoPedido V2
Canon: `RECIBIDO → EN_PREPARACION → LISTO_DESPACHO → ENVIADO → ENTREGADO → CERRADO`, transversales `CANCELADO`, `REQUIERE_REVISION`. Legacy `LISTO`, `EN_CAMINO`, `PAGADO` retenidos solo para compat física.

### 3.3 Agente IA
Stack: **LangGraph** (orquestación stateful + checkpointer Postgres) + **LiteLLM** (abstracción multi-vendor) + Pydantic v2 + OpenTelemetry trace + LangSmith debug.

Tablas: `PlantillaIa` (multi-vendor, versionada), `HerramientaIa` (registro tools), `SesionAgente` (state + checkpointRef), `MensajeAgente` (tool-calling), `EjecucionAgente` (tokens/costo/trace/nodoGraph), `DocumentoConocimiento` (RAG pgvector).

### 3.4 Embeddings — Google (capa gratuita)
- Modelo: `gemini-embedding-001`.
- `outputDimensionality: 1536` (configurable, matchea schema).
- Tasa: 1500 RPM, 1M tokens/día gratis. Suficiente MVP.
- Vía LiteLLM: `model="gemini/gemini-embedding-001"`.
- Fallback futuro: si necesidades crecen, swap a Voyage o OpenAI sin tocar schema.

### 3.5 Stock
Snapshot `Producto.stock` mantenido por trigger Postgres desde `MovimientoStock` (source-of-truth, append-only).

---

## 4. Estructura RAG decidida

**Ingest pipeline (event-driven):**
```
service-inventory: producto creado/editado
  → outbox event `producto.actualizado.v1`
  → Kafka topic
  → service-ai-agent consumer
  → embedding(producto) via Google gemini-embedding-001 (1536-dim)
  → upsert documentos_conocimiento (tipo='MENU', id_negocio, contenido=nombre+desc+precio+categoria, embedding)
```

**Query pipeline:**
```
mensaje cliente
  → embed(pregunta) (cache 5min Redis)
  → SELECT ... FROM documentos_conocimiento
     WHERE id_negocio = X AND activo = true AND tipo = ANY([...])
     ORDER BY embedding <=> $vec LIMIT 6
  → inject contexto en prompt LangGraph
  → LiteLLM call
  → registrar EjecucionAgente (tokens, costo, latencia, trazaId)
```

**Tipos documento_conocimiento:**
- `MENU` (1 por producto)
- `FAQ` (preguntas frecuentes)
- `POLITICA` (horarios, envíos, devoluciones)
- `NEGOCIO` (contacto, dirección, formato_entrega)
- `RECETA` (chef virtual, futuro)

**Chunking:** un producto/FAQ por documento (granular, no necesita split). Para políticas largas: split 300-500 tokens.

---

## 5. Plan de orquestación multi-agente

### Roles
- **Claude Code (yo, sesión nueva):** orquestador, ADRs, decisiones arquitectura, integración, code review de Codex.
- **Codex rescue (delegado):** sub-tareas paralelas (scaffolding, refactor Flutter, generación módulos).

### Tareas paralelizables (delegar Codex)
1. **Backend:** scaffold `service-ai-agent` (estructura hexagonal, deps, FastAPI bootstrap, LangGraph + LiteLLM wiring).
2. **Backend:** adapters Cloud SQL para `service-orders` + `service-inventory`.
3. **Flutter:** auditoría detallada widgets pantalla por pantalla + reporte gaps.
4. **Flutter:** reemplazar auth fake por Firebase Auth real.
5. **Flutter:** refactor 19 god widgets → composición.
6. **Flutter:** eliminar `X-Secret` + `localhost:5050` + secret hardcoded.
7. **Flutter:** generar componentes faltantes (configuración integraciones mensajería, plantillas IA UI real, etc).
8. **Docs:** seed inicial cada subcarpeta `docs/` (templates).

### Tareas secuenciales (Claude only)
1. ADRs 0012, 0013, 0014.
2. Schema migration plantillas IA seed.
3. Decisiones de scope en conflicto.
4. Review integration.

---

## 6. Pendientes inmediatos próxima sesión

1. ⏳ **Commits estado actual** (backend + frontend `.firebase/` ignore).
2. ⏳ `firebase dataconnect:sdk:generate` → SDK Dart regenerado.
3. ⏳ Smoke `flutter analyze` (esperar errores → no arreglar aún).
4. ⏳ Estructura `docs/` con READMEs por subcarpeta.
5. ⏳ Lanzar Codex paralelo: scaffold service-ai-agent.
6. ⏳ Lanzar Codex paralelo: auditoría Flutter widgets.
7. ⏳ Escribir ADRs 0012/0013/0014.

---

## 7. Decisiones pendientes a resolver siguiente sesión

- ¿Webhook WhatsApp Cloud API verificado? Falta `phone_number_id` real + WABA setup.
- ¿Tipo MVP: 1 negocio piloto antes multi-tenant real?
- ¿Service-to-service auth: JWT firmados o Workload Identity GCP?
- ¿Re-indexar conocimiento: full nightly + incremental event, o solo event?
- ¿Borrar `Conversacion`/`MensajeConversacion` legacy ya?

---

## 8. Archivos clave referencia

**Schema/DB:**
- `dataconnect/schema/schema.gql`
- `dataconnect/migrations/000_reset_public_schema.sql`
- `dataconnect/migrations/001_stock_snapshot_trigger.sql`
- `dataconnect/migrations/002_pgvector_conocimiento.sql`
- `dataconnect/dataconnect.yaml` (schemaValidation=STRICT)

**Operations:**
- `dataconnect/prontoapp/queries.gql`
- `dataconnect/prontoapp/mutations.gql` (críticas retired)
- `dataconnect/prontoapp/connector.yaml`

**Docs decisiones:**
- `docs/SCHEMA_V2_REFORMULADO.md`
- `docs/DECISIONES_ESQUEMA_SQL_CONNECT.md` (heredado)
- `docs/SQL_CONNECT_RESET_DIFF_2026-05-15.md` (heredado)
- `docs/ADRs/0011-firebase-sql-connect-postgres.md`

**Frontend audit (heredados, leer):**
- `ProntoApp-/docs/ARCHITECTURE_REVIEW.md`
- `ProntoApp-/docs/BACKEND_ARCHITECTURE.md`
- `ProntoApp-/docs/CODEX_HANDOFF.md`
- `ProntoApp-/docs/formulacion-proyecto.md`
