# docs/ — Organización

Documentación del proyecto **ProntoApp** organizada por contexto. Cada subcarpeta tiene un README explicando su propósito.

## Estructura

```
docs/
├── sesiones/             # Handoffs entre sesiones de trabajo, bitácora, prompts de continuación
├── arquitectura/         # ADRs de Flutter, decisiones técnicas globales, diagramas C4/ERD
├── backend/              # Cambios services (orders, inventory, ai-agent, etc), schema dataconnect, persistencia
├── frontend-mobile/      # Decisiones Flutter, widgets, navegación, providers, auditorías
├── agente-ia/            # Graphs LangGraph, plantillas/prompts, herramientas, RAG/embeddings
├── producto/             # Visión, alcance, casos de uso (CU), requisitos funcionales/no-funcionales (RF/RNF)
└── gaps-y-pendientes/    # Backlog técnico, deudas, blockers, riesgos
```

## Reglas

1. **Cada cambio significativo se documenta** en la subcarpeta correspondiente.
2. **Decisiones cerradas** → ADR en `arquitectura/` o `backend/`, con número incremental.
3. **Sesiones de trabajo largas** generan handoff en `sesiones/HANDOFF_YYYY-MM-DD_TITULO.md`.
4. **Cada agente Codex delegado** entrega artefactos + doc en subcarpeta relevante.
5. **Gaps/pendientes** vivos en `gaps-y-pendientes/`, no en código TODO disperso.

## Entrada actual

- **Última sesión:** `sesiones/HANDOFF_2026-05-16_SCHEMA_V2_DEPLOYED.md`
- **Plan ejecución:** `sesiones/PLAN_EJECUCION_FASES_0-7.md`

## Heredado (raíz docs/)

Estos archivos vienen de auditorías agénticas previas y deben permanecer en raíz por compat:
- `ARCHITECTURE_REVIEW.md` — auditoría Flutter completa.
- `BACKEND_ARCHITECTURE.md` — diseño backend hexagonal.
- `CODEX_HANDOFF.md` — contexto de Codex anterior.
- `formulacion-proyecto.md` — visión producto original.

A migrar progresivamente a subcarpetas.
