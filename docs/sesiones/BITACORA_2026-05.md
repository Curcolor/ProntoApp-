# Bitácora mayo 2026

Entradas cortas por día/hito. El agente en `/goal` mode debe agregar entrada cada ~10 turnos o al completar fase.

## Plantilla

```markdown
### YYYY-MM-DD HH:MM — [TITULO]

- **Hecho:** qué se completó.
- **Fase:** del plan (0-7).
- **Bloqueos nuevos:** referencia a entrada en BLOCKERS.md o CONFIG_PENDIENTE.md.
- **Próximo turno:** qué sigue.
- **Métricas:** turnos consumidos, tokens, costo aproximado.
```

---

## Entradas

### 2026-05-16 — Inicio handoff schema V2

- **Hecho:** Schema V2 reformulado, desplegado en Cloud SQL, trigger stock + pgvector aplicados. Estructura docs/ creada con READMEs. Handoff + PLAN + CONFIG_PENDIENTE + BLOCKERS escritos. Decisión embeddings: Google `gemini-embedding-001` dim=1536.
- **Fase:** Pre-fase 0 (preparación).
- **Bloqueos nuevos:** CONFIG_PENDIENTE.md poblado con 7 entradas iniciales (Secret Manager, WABA, Telegram bot, Google AI key, Cloud Run, Kafka/PubSub, Firebase Auth providers).
- **Próximo turno:** sesión nueva inicia con prompt en HANDOFF_2026-05-16, activa `/goal`, ejecuta Fase 0 commits.
- **Métricas:** sesión actual aprox 70% context, cerrar acá.

### 2026-05-16 — Sesión orquestación: Fases 0+1+2+3 cerradas

- **Hecho:**
  - F0: 4 commits hechos (back `8c2d31c` + tag schema-v2-deployed; front `748cb63` SDK regen, `4d37f5e` docs+gitignore + tag schema-v2-deployed).
  - F1: `flutter pub get` ok, `flutter analyze` → 0 errors / 7 warnings / 130 info. Snapshot a `docs/frontend-mobile/ANALYZE_POST_SCHEMA_V2.md` (commit `8181ed4`).
  - F2: SQL seeds 003 (4 plantillas globales) + 004 (5 herramientas globales) escritas y commiteadas (`d9c0e1e`). Aplicación a Cloud SQL pendiente Junior (no tengo password).
  - F3: ADRs 0012 (LangGraph+LiteLLM), 0013 (multi-canal WA+TG), 0014 (RAG gemini+pgvector) en back (`29345f5`), ADR 0001 Flutter Firebase Auth+SDK (`62d7b6d`) en front.
  - Memoria persistente del proyecto poblada (8 memorias bajo `~/.claude/projects/.../memory/`).
- **Fase:** 0, 1, 2 (parcial — aplicación pending), 3.
- **Codex paralelos lanzados:** F4.1 scaffold service-ai-agent (`a71eda05`); F6.1 auditoría Flutter (`adab5c0e`). Background.
- **Bloqueos nuevos:** CONFIG_PENDIENTE entrada nueva — "Aplicar seeds 003+004 manualmente".
- **Próximo turno:** esperar Codex outputs → revisar → commitear si pasan review → arrancar F4.2 (RAG tool + graph) + F5 (persistencia services).
- **Métricas:** ~13 turnos consumidos en este episodio; 7 tasks pipeline (4 completed, 1 pending app manual, 2 codex in-progress).

### 2026-05-16 — F4.1 + F6.1 cerradas + 🚨 hallazgo crítico seguridad

- **Hecho:**
  - F4.1: Codex entregó parcial (pyproject + Dockerfile + README + settings + main). Claude completó scaffolding hexagonal: domain (models + 4 ports + AgentContext), infrastructure (litellm + gemini + 2 repos pg + checkpointer + OTel), tests unit. **14 tests pytest verdes en 2.7s.** Docs `docs/backend/service-ai-agent-SCAFFOLD.md` + `docs/agente-ia/SERVICE_AI_AGENT_OVERVIEW.md`. Fix bug BOM en pyproject.toml + mapping correcto enum ProveedorLlm→prefijo LiteLLM (GOOGLE→gemini no google). Commit `b08b5b9` (30 archivos +1212/-77).
  - F6.1: Codex 2do intento falló por cuota agotada hasta 21:50. Claude hizo auditoría manual con script `tools_audit_screens.py` reproducible — 29 pantallas auditadas, doc `docs/frontend-mobile/AUDITORIA_PANTALLAS.md` con tabla maestra + 17 god widgets identificados + análisis estilo + vistas faltantes + estimación 120-165h. Commit `4ab6bc5`.
- **Fase:** 4.1 + 6.1.
- **🚨 HALLAZGO SEGURIDAD P0:** secret API hardcoded en `lib/main.dart:41,50` (`83c58120a0a140ade0282b37ff64731f3fdd3f7dc306be3151ec62e967b43f43`). Extraíble con apktool. **Junior debe rotarlo HOY** y autorizar borrado del literal. Acción complementaria: borrar `lib/data/services/auth_service.dart` plaintext seeds (`password123`).
- **Bloqueos nuevos:** Codex cuota agotada hasta 21:50 hora Bogotá — F4.2 + F4.3 + F5 los hago Claude solo o esperar reset.
- **Próximo turno:** F4.2 (RAG tool `buscar_conocimiento` + endpoint reindex + graph atencion_cliente) por Claude. F5 luego.
- **Métricas:** ~22 turnos; 7/7 tasks pipeline completadas; 8 commits hechos esta sesión.

### 2026-05-17 — F4.2 cerrada + F6.2 parcial + Codex paralelo F4.3 + F5

- **Hecho:**
  - F4.2 completo: tool buscar_conocimiento + ReindexarConocimiento use case + graph atencion_cliente (run_in_memory + build_graph), use case ResponderMensaje, repos pg (producto_lookup + sesion), endpoints POST /v1/conocimiento/reindexar y /v1/sesiones/{id}/mensajes. **24 tests verdes, 95% cobertura domain+application.** Docs RAG_PIPELINE.md + GRAPH_ATENCION_CLIENTE.md. Commit `9ec56a5` (20 archivos +1676).
  - F6.2 parcial: nueva query `ObtenerMiPerfilUsuarioAdmin` (commit back `34188e1`), SDK Dart regenerado, FirebaseAuthService + PerfilUsuarioAdminService + AuthGuard widget. `flutter analyze` limpio. Doc FIREBASE_AUTH_REAL.md. Commit front `b146cd8` (16 archivos +1102). NO se tocó main.dart todavía (espera rotación secret).
  - Codex F4.3 (webhooks WA+TG + ingesta_pedido) y F5 (persistencia orders+inventory) delegados paralelos background.
- **Fase:** 4.2 ✅, 6.2 parcial, 4.3+5 in-progress Codex.
- **Bloqueos nuevos:** ninguno propio. Pendiente Junior: rotar secret backend + aplicar seeds 003+004.
- **Próximo turno:** review outputs Codex F4.3 + F5 cuando notifiquen; F6.3 (providers SDK SQL Connect) tras ello; F6.4 vistas configuración faltantes (perfil_negocio, integraciones_mensajeria).
- **Métricas:** ~32 turnos acumulados; 8 tasks completadas + 2 in-progress Codex; 13 commits totales.

### 2026-05-17 — F6.3 cerrada + F6.4 cerrada + Codex F4.3/F5 caídos post-resume

- **Hecho:**
  - F6.3: `main.dart` limpio. Inyectados `FirebaseAuthService`,
    `PerfilUsuarioAdminService` (ahora `ChangeNotifier` con cache `perfil`
    para `context.watch`) y `ProntoappConnector`. Secret literal
    `83c58120…43` eliminado de los providers HTTP legacy (quedan con
    baseUrl/secreto vacíos hasta que F6.5 migre providers al SDK Data
    Connect; backend viejo no se reactiva — service-employees fake
    desmontado per decisión Junior).
  - F6.4: 5 pantallas CRUD bajo `lib/features/manager/screens/configuracion/`
    cableadas desde `settings_screen.dart` (nueva sección "NEGOCIO"):
    `perfil_negocio_screen.dart`, `categorias_screen.dart`,
    `integraciones_mensajeria_screen.dart`, `pasos_flujo_pedido_screen.dart`,
    `plantillas_ia_admin_screen.dart`. Cada una consume el SDK Data Connect
    (read query + insert/update + soft delete via `activo=false`). Soft
    delete elegido para preservar integridad referencial.
  - Backend GQL: añadidas mutations CRUD para Negocio, Categoria,
    IntegracionMensajeria, PasoFlujoPedido, PlantillaIa + queries admin
    correspondientes (incluyen inactivos). Permisos PROPIETARIO/GERENTE
    via `@check` server-side; SUPERVISOR sólo en Categoria. Queries
    NUNCA devuelven `credencialSecretRef` ni `webhookSecret`
    (write-only desde UI hacia Secret Manager).
  - Cleanup hardcoded: "Mi Panadería" / "Panadería El Trigo Dorado" fuera
    de 6 archivos (dashboard, inventario, equipo, profile, configurar
    agente modal, editar perfil modal). Reemplazados por
    `perfil.negocioNombre` o defaults vacíos.
  - Commits: backend `6f43c20` (669 LOC GQL); frontend `e330e96`
    (35 archivos +6372/-34 incluyendo SDK regen).
  - `flutter analyze`: zero errors, sólo warnings preexistentes
    (god widgets legacy + line endings).
- **Fase:** 6.3 ✅, 6.4 ✅.
- **Bloqueos nuevos:** Codex agentes F4.3 (`a29dba25…`) y F5
  (`acb7481c…`) muertos post-resume — tareas #9 y #10 quedaron sin
  entrega en repo backend. Cuenta como 1ª caída de cada uno; pendiente
  re-delegar en próximo turno. Si vuelven a caer → BLOCKER + Claude solo.
- **Próximo turno:** A) re-lanzar Codex F4.3 y F5 paralelos; B) F6.5
  tests integration AuthGuard + FirebaseAuthService con
  `firebase_auth_mocks`; C) F7 OTel exporter Cloud Trace en
  service-ai-agent.
- **Métricas:** ~12 turnos en este episodio post-resume; 14 tasks pipeline
  (4 nuevas creadas, 2 completadas en este turno, 2 in-progress Codex
  inválidas); 3 commits totales hoy (1 backend, 1 frontend, 1 bitácora).
- **Acción manual Junior pendiente:**
  - Aplicar seeds 003+004 a Cloud SQL.
  - Habilitar Email/Password en Firebase Console.
  - (Documentado en `CONFIG_PENDIENTE.md`).

### 2026-05-17 — F6.5 tests Auth + F7 OTel/structured logging cerradas

- **Hecho:**
  - F6.5 (Flutter): `firebase_auth_mocks ^0.15.2` + `mocktail ^1.0.4`
    como devDeps. Suite con 9 tests:
    - `test/features/auth/auth_guard_test.dart`: 5 escenarios — sin
      sesión Firebase, usuario logueado sin `UsuarioAdmin` (onboarding),
      cargo permitido (PROPIETARIO), cargo bloqueado (SUPERVISOR contra
      whitelist GERENTE/PROPIETARIO) y error al cargar perfil.
    - `test/data/services/firebase_auth_service_test.dart`: 4 tests
      cubriendo `estaLogueado`, `iniciarSesionEmail`, `cerrarSesion` y
      `obtenerIdToken` con `MockFirebaseAuth`.
    - Bug fixed AuthGuard: loop infinito cuando `obtenerMiPerfil`
      devolvía `null` (el guard reagendaba la carga cada frame). Añadida
      bandera `_cargado` que se levanta una vez completa la carga,
      sea cual sea el resultado.
    - 9/9 verdes (~1.2 s). Commit `c050a31`.
  - F7 (service-ai-agent): observabilidad real.
    - `tracing.py` ahora arma un `TracerProvider` propio con
      `service.name` resource y elige exporter según env:
      Cloud Trace si `OTEL_EXPORTER_GCP_PROJECT`, OTLP gRPC si
      `OTEL_EXPORTER_OTLP_ENDPOINT`, no-op en caso contrario.
      `FastAPIInstrumentor.instrument_app(app)` sigue conectado.
    - Nuevo `logging_setup.py` con `structlog` + processor
      `redactar_secretos` que tapa `Authorization`,
      `credencialSecretRef`, `webhookSecret`, `password`, `secret`,
      `token` (top-level + dict anidado un nivel). Output JSON
      compatible con Cloud Logging (`severity` + `message`).
    - `Settings` añade `otel_service_name`, `otel_gcp_project`,
      `otel_otlp_endpoint`, `log_json` con aliases env.
    - `main.py` arranca con `configure_structured_logging` +
      `OpenTelemetryFastAPIAdapter` parametrizados desde `Settings`.
    - Tests: `test_observability.py` ahora cubre 6 escenarios
      (no-op sin SDK, sin config, OTLP, Cloud Trace,
      redacción auth/credencialSecretRef, JSON renderer). Total
      29 unit tests verdes para el servicio (3.2 s). Commit
      `618786a`, tag `f7-otel-completed-20260517`.
- **Fase:** 6.5 ✅, 7 (parcial — falta App Check + rate limiting + cost
  monitoring, pendientes para F7.x).
- **Bloqueos nuevos:** ninguno propio. Codex F4.3 + F5 siguen pendientes
  de re-delegación (no se relanzaron en este turno para ahorrar tokens;
  se relanzan al inicio del próximo).
- **Próximo turno:** A) re-delegar Codex F4.3 + F5 paralelos; B) si los
  agentes fallan otra vez, marcar BLOCKER y continuar Claude solo
  (webhooks WA/TG + outbox transaccional son security-gated); C) F7.x
  hardening (App Check Firebase, rate limiting, cost monitoring).
- **Métricas:** ~22 turnos acumulados post-resume; 14 tasks pipeline
  (4 completadas hoy: F6.3, F6.4, F6.5, F7), 2 pending Codex; 6 commits
  hoy entre backend y frontend; 3 tags fase (`f6.3-completed-`,
  `f6.4-completed-`, `f7-otel-completed-`).
