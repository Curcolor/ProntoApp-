"""Generación de IDs de dominio (prefijo + UUID corto)."""
import uuid


def nuevo_id(prefijo: str) -> str:
    return f"{prefijo}-{str(uuid.uuid4())[:8].upper()}"
