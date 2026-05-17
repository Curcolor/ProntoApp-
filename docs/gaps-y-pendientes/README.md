# gaps-y-pendientes/

Backlog técnico vivo. Único lugar para deudas/blockers/riesgos. No usar TODOs en código.

## Archivos

- `BACKLOG.md` — lista priorizada (P0/P1/P2/P3) con estimación.
- `BLOCKERS.md` — bloqueos activos (esperando decisión/auth/billing/etc).
- `RIESGOS.md` — riesgos arquitectura/producto + mitigación.
- `DEUDA_TECNICA.md` — refactor pendientes.

## Estado actual (heredado)

Items P0 críticos identificados en auditoría previa (`docs/ARCHITECTURE_REVIEW.md`):

- ✗ Secret hardcoded en `lib/main.dart:39,47` + 3 commits — **rotar + filter-repo**.
- ✗ Auth fake (3 users plaintext SharedPreferences).
- ✗ HTTP plano localhost (Android/iOS lo bloquean en release).
- ✗ AndroidManifest sin INTERNET permission.
- ✗ Credenciales leak en login_screen hint.
- ✗ WhatsApp vs Telegram (resuelto: ambos V1).
- ✗ Agente IA theater 1013 LOC (resuelto: scaffold real Fase 4).

A migrar a `BACKLOG.md` con prioridades.
