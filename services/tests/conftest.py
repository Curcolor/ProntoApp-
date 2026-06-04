import os

# Tests deterministas: neutraliza cualquier TELEGRAM_WEBHOOK_SECRET del entorno o
# del .env raíz ANTES de que api_pedidos haga load_dotenv() / lea SECRETO, para
# que las peticiones de test sin header x-secret no reciban 403.
os.environ["TELEGRAM_WEBHOOK_SECRET"] = ""
# JWT determinista para tests (auth.crear_token / decodificar_token).
os.environ["JWT_SECRET"] = "clave-de-pruebas-jwt-hs256-0123456789"

import pytest
from sqlalchemy.orm import sessionmaker
from src.db import Base, make_engine
import src.models  # noqa: F401  (registra las tablas en Base.metadata)


@pytest.fixture(scope="session")
def engine():
    url = os.environ["TEST_DATABASE_URL"]
    eng = make_engine(url)
    Base.metadata.drop_all(eng)
    Base.metadata.create_all(eng)
    yield eng
    Base.metadata.drop_all(eng)


@pytest.fixture()
def db(engine):
    """Sesión por test con rollback al final.

    `join_transaction_mode="create_savepoint"` hace que los `commit()` del código
    bajo prueba (crud) usen SAVEPOINTs en vez de cerrar la transacción externa,
    de modo que el rollback final aísle realmente cada test."""
    connection = engine.connect()
    trans = connection.begin()
    Session = sessionmaker(
        bind=connection, expire_on_commit=False,
        join_transaction_mode="create_savepoint",
    )
    session = Session()
    yield session
    session.close()
    trans.rollback()
    connection.close()
