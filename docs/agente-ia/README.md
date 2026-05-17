# agente-ia/

Diseño e implementación del agente IA: LangGraph, plantillas/prompts, herramientas, RAG/embeddings.

## Stack

- **LangGraph** — orquestación stateful, PostgresSaver checkpointer.
- **LiteLLM** — abstracción multi-vendor (Google primero por capa gratuita, fallback Anthropic/OpenAI).
- **Google `gemini-embedding-001`** — embeddings RAG (1536-dim configurable).
- **pgvector + HNSW** — búsqueda vectorial en `documentos_conocimiento`.
- **Pydantic v2** — schemas tools.
- **OpenTelemetry + LangSmith** — tracing.

## Documentos esperados

- `RAG_PIPELINE.md` — ingest + query end-to-end.
- `GRAPH_INGESTA_PEDIDO.md` — nodos, estado, tools.
- `GRAPH_ATENCION_CLIENTE.md` — RAG + responder.
- `GRAPH_RECOMENDACION_PRODUCTO.md`.
- `PROMPTS.md` — catálogo plantillas con criterio versionado.
- `HERRAMIENTAS.md` — registro tools con schemas Pydantic.
- `COSTOS.md` — estimación y monitoreo `EjecucionAgente`.
- `WEBHOOKS.md` — flujo Telegram + WhatsApp Cloud + WebChat.

## Recursos referencia

- Schema tablas IA: `ProntoApp--Back/dataconnect/schema/schema.gql` sección "AGENTE IA".
- ADR 0012: `ProntoApp--Back/docs/ADRs/0012-agente-ia-langgraph-litellm.md`.
- ADR 0014: `ProntoApp--Back/docs/ADRs/0014-rag-embeddings-google-gemini.md`.
