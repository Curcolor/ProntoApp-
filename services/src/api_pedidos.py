"""Servidor FastAPI para ProntoApp. Persiste en Postgres vía SQLAlchemy."""
from typing import Optional
from dotenv import load_dotenv
from fastapi import FastAPI, Header
from fastapi.middleware.cors import CORSMiddleware

from .infrastructure.web.deps import get_db, requerir_tenant
from .infrastructure.web.routers import inventario as inventario_router
from .infrastructure.web.routers import pedidos as pedidos_router
from .infrastructure.web.routers import auth as auth_router
from .infrastructure.web.routers import usuarios as usuarios_router
from .infrastructure.web.routers import negocio as negocio_router
from .infrastructure.web.routers import plantilla as plantilla_router

load_dotenv()

app = FastAPI(title="ProntoApp API", version="2.0.0")
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"],
)
app.include_router(inventario_router.router)
app.include_router(pedidos_router.router)
app.include_router(auth_router.router)
app.include_router(usuarios_router.router)
app.include_router(negocio_router.router)
app.include_router(plantilla_router.router)


def get_negocio_id(x_negocio_id: Optional[str] = Header(default=None)) -> str:
    # Conservada solo por compatibilidad de imports/tests; ya no la usan los endpoints.
    return x_negocio_id or "main"


# ─── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/health")
def health_check():
    from datetime import datetime
    return {"ok": True, "timestamp": datetime.now().isoformat()}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
