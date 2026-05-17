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
