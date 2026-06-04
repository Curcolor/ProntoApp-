"""Errores de dominio. Los adaptadores IN (routers) los traducen a HTTP."""


class DomainError(Exception):
    """Base de los errores de dominio."""


class EmailDuplicadoError(DomainError):
    """El email del usuario ya está registrado."""


class CategoriaConProductosError(DomainError):
    """Se intentó borrar una categoría que aún tiene productos."""


class NoEncontradoError(DomainError):
    """No se encontró la entidad pedida en el negocio."""
