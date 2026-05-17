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
