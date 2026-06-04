# Imagen única para la API y el bot de ProntoApp.
# 3.11 (no 3.13): python-telegram-bot 13.15 importa `imghdr`, removido en 3.13.
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080

WORKDIR /app

# Dependencias de API + bot (la misma imagen sirve a ambos servicios).
COPY requirements_api.txt requirements_bot.txt ./
RUN pip install --no-cache-dir -r requirements_api.txt -r requirements_bot.txt

# Código fuente (src es un paquete con __init__.py).
COPY src ./src

# Usuario no-root.
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080

# Cloud Run inyecta $PORT. `exec` lo hace PID 1 (recibe SIGTERM) y expande $PORT.
CMD ["sh", "-c", "exec uvicorn src.api_pedidos:app --host 0.0.0.0 --port ${PORT:-8080}"]
