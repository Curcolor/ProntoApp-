"""Servidor FastAPI para ProntoApp. Persiste en Postgres vía SQLAlchemy."""
import os
from typing import Optional
from dotenv import load_dotenv
from fastapi import Depends, FastAPI, Header, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sqlalchemy.orm import Session

from . import auth, crud
from .infrastructure.web.deps import get_db, requerir_tenant
from .infrastructure.web.routers import inventario as inventario_router
from .infrastructure.web.routers import pedidos as pedidos_router

load_dotenv()

app = FastAPI(title="ProntoApp API", version="2.0.0")
app.add_middleware(
    CORSMiddleware, allow_origins=["*"], allow_methods=["*"], allow_headers=["*"],
)
app.include_router(inventario_router.router)
app.include_router(pedidos_router.router)


def get_negocio_id(x_negocio_id: Optional[str] = Header(default=None)) -> str:
    # Conservada solo por compatibilidad de imports/tests; ya no la usan los endpoints.
    return x_negocio_id or "main"


# ─── Endpoints ────────────────────────────────────────────────────────────────

@app.get("/health")
def health_check():
    from datetime import datetime
    return {"ok": True, "timestamp": datetime.now().isoformat()}


class LoginIn(BaseModel):
    email: str
    password: str


@app.post("/auth/login")
def auth_login(body: LoginIn, db: Session = Depends(get_db)):
    user = crud.login(db, body.email, body.password)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Credenciales inválidas")
    return {**user, "token": auth.crear_token(user)}


class RegistroIn(BaseModel):
    nombre: str
    email: str
    password: str
    businessName: str
    telefono: Optional[str] = None


@app.post("/registro", status_code=status.HTTP_201_CREATED)
def registro_endpoint(body: RegistroIn, db: Session = Depends(get_db)):
    try:
        user = crud.registrar(db, body.model_dump())
    except crud.EmailDuplicadoError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El email ya está registrado")
    return {**user, "token": auth.crear_token(user)}


@app.get("/negocio")
def obtener_negocio(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.leer_negocio(db, negocio_id)


class UsuarioIn(BaseModel):
    nombre: str
    email: str
    password: str
    rol: str
    telefono: Optional[str] = None


@app.post("/usuarios", status_code=status.HTTP_201_CREATED)
def crear_usuario_endpoint(body: UsuarioIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    try:
        return crud.crear_usuario(db, body.model_dump(), negocio_id)
    except crud.EmailDuplicadoError:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="El email ya está registrado")


@app.get("/usuarios")
def listar_usuarios_endpoint(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    return crud.listar_usuarios(db, negocio_id)


class NegocioIn(BaseModel):
    tipoNegocio: Optional[str] = None
    nombre: Optional[str] = None
    direccion: Optional[str] = None
    horaApertura: Optional[str] = None
    horaCierre: Optional[str] = None
    formatoEntrega: Optional[str] = None
    terminosEntrega: Optional[str] = None
    numeroWhatsapp: Optional[str] = None


class UsuarioPatch(BaseModel):
    nombre: Optional[str] = None
    telefono: Optional[str] = None
    rol: Optional[str] = None


@app.put("/negocio")
def actualizar_negocio_endpoint(body: NegocioIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_negocio(db, datos, negocio_id)


@app.patch("/usuarios/{usuario_id}")
def actualizar_usuario_endpoint(usuario_id: str, body: UsuarioPatch, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    actualizado = crud.actualizar_usuario(db, usuario_id, datos, negocio_id)
    if actualizado is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")
    return actualizado


@app.delete("/usuarios/{usuario_id}", status_code=status.HTTP_204_NO_CONTENT)
def eliminar_usuario_endpoint(usuario_id: str, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    if not crud.eliminar_usuario(db, usuario_id, negocio_id):
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail=f"Usuario {usuario_id} no encontrado")


class PlantillaIaIn(BaseModel):
    prompt: Optional[str] = None
    contexto: Optional[str] = None


@app.get("/plantilla-ia")
def obtener_plantilla_ia(db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    p = crud.leer_plantilla_ia(db, negocio_id)
    if p is None:
        return {"id": "main", "prompt": "", "contexto": "[]"}
    return p


@app.put("/plantilla-ia")
def actualizar_plantilla_ia_endpoint(body: PlantillaIaIn, db: Session = Depends(get_db), negocio_id: str = Depends(requerir_tenant)):
    datos = {k: v for k, v in body.model_dump().items() if v is not None}
    return crud.actualizar_plantilla_ia(db, datos, negocio_id)


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("api_pedidos:app", host="0.0.0.0", port=5050, reload=True)
