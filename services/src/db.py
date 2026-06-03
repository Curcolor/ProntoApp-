"""Conexión a Postgres para FastAPI (CRUD, sin DDL en prod)."""
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker

Base = declarative_base()


def _database_url() -> str:
    url = os.getenv("DATABASE_URL")
    if not url:
        raise RuntimeError("DATABASE_URL no está configurada")
    return url


def make_engine(url: str | None = None):
    return create_engine(url or _database_url(), pool_pre_ping=True, future=True)


# Engine/sesión por defecto para la app (prod/dev).
engine = make_engine() if os.getenv("DATABASE_URL") else None
SessionLocal = sessionmaker(bind=engine, autoflush=False, expire_on_commit=False)
