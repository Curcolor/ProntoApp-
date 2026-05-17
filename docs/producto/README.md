# producto/

Visión, alcance, casos de uso, requisitos funcionales/no-funcionales.

## Documentos esperados

- `VISION.md` — quién usa, qué problema resuelve, por qué pagaría.
- `CU_CASOS_USO.md` — CU-01 a CU-NN con actor, precondición, flujo, postcondición.
- `RF_REQUISITOS_FUNCIONALES.md` — RF-01 a RF-NN.
- `RNF_REQUISITOS_NO_FUNCIONALES.md` — performance, seguridad, accesibilidad.
- `ROADMAP.md` — fases V1 → V2 → V3.
- `PERSONAS.md` — Gerente, Cocinero, Repartidor, Cliente, IA agent.

## Fuente original

`docs/formulacion-proyecto.md` en raíz — visión académica original. Migrar progresivamente a estos archivos.

## Decisiones producto clave

- Multi-tenant MiPyme food (panadería/restaurante/café/comercio).
- 3 roles internos: gerente, cocinero, repartidor.
- Clientes externos vía WhatsApp + Telegram.
- IA: ingesta pedido + atención cliente + recomendación.
- MVP target: 1 negocio piloto, luego onboarding multi.
