"""Adaptador de PasswordHasher: implementa hash/verify con passlib bcrypt."""
from passlib.hash import bcrypt


class BcryptPasswordHasher:
    """Implementa el puerto PasswordHasher usando passlib bcrypt."""

    def hash(self, password: str) -> str:
        return bcrypt.hash(password)

    def verify(self, password: str, hash: str) -> bool:
        return bcrypt.verify(password, hash)
