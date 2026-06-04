#!/usr/bin/env bash
# Levanta TODO el stack local con un solo comando:
#   Postgres (docker, 5433) + API FastAPI (5050) + Bot Telegram (si hay token) + Flutter web.
#
# Requisitos: docker, python 3.11+, flutter en el PATH.
# Primera vez: copia services/.env.example -> services/.env (lo hace solo) y ajusta secretos.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICES="$ROOT/services"

# Python del venv (Git Bash en Windows -> Scripts/; Linux/mac -> bin/).
venv_py() {
  if [ -x "$SERVICES/.venv/Scripts/python.exe" ]; then echo "$SERVICES/.venv/Scripts/python.exe";
  else echo "$SERVICES/.venv/bin/python"; fi
}

c() { printf "\033[1;36m==> %s\033[0m\n" "$1"; }

# 1. Postgres local (docker)
c "Levantando Postgres (docker-compose)..."
docker compose -f "$SERVICES/docker-compose.yml" up -d
c "Esperando a que Postgres acepte conexiones..."
until docker exec prontoapp-movil-db pg_isready -U prontoapp -d prontoapp >/dev/null 2>&1; do sleep 1; done

# 2. venv + dependencias (API + bot)
if [ ! -d "$SERVICES/.venv" ]; then
  c "Creando entorno virtual e instalando dependencias..."
  python -m venv "$SERVICES/.venv"
  PY="$(venv_py)"
  "$PY" -m pip install --upgrade pip
  "$PY" -m pip install -r "$SERVICES/requirements_api.txt" -r "$SERVICES/requirements_bot.txt"
fi
PY="$(venv_py)"

# 3. .env (crear desde plantilla si falta) y cargarlo
if [ ! -f "$SERVICES/.env" ]; then
  c "services/.env no existe: lo creo desde la plantilla. Ajusta los secretos del bot si lo necesitas."
  cp "$SERVICES/.env.example" "$SERVICES/.env"
fi
set -a; . "$SERVICES/.env"; set +a

# 4. Seed (solo si la DB está vacía)
if ( cd "$SERVICES" && "$PY" -c "from src.db import SessionLocal; from src.models import Usuario; import sys; sys.exit(0 if SessionLocal().query(Usuario).first() is None else 1)" ); then
  c "Sembrando datos de ejemplo..."
  ( cd "$SERVICES" && "$PY" -m src.seed )
else
  c "La DB ya tiene datos: omito el seed."
fi

# Limpieza de procesos en segundo plano al salir
PIDS=()
cleanup() {
  trap - INT TERM EXIT
  c "Apagando servicios..."
  for p in "${PIDS[@]:-}"; do kill "$p" 2>/dev/null || true; done
  exit 0
}
trap cleanup INT TERM EXIT

# 5. API FastAPI (5050)
c "API FastAPI -> http://localhost:5050"
( cd "$SERVICES" && "$PY" -m uvicorn src.api_pedidos:app --host 0.0.0.0 --port 5050 --reload ) &
PIDS+=($!)

# 6. Bot Telegram (solo si hay token)
if [ -n "${TELEGRAM_BOT_TOKEN:-}" ]; then
  c "Bot de Telegram..."
  ( cd "$SERVICES" && "$PY" -m src.bot_telegram ) &
  PIDS+=($!)
else
  c "Sin TELEGRAM_BOT_TOKEN -> omito el bot (la API y la app igual funcionan)."
fi

# 7. Flutter web (bloquea hasta que salgas con 'q'/Ctrl-C -> dispara cleanup)
c "Flutter web (la app apunta a la API local)..."
flutter run -d web-server \
  --dart-define=API_BASE_URL=http://localhost:5050 \
  --dart-define=API_SECRET="${TELEGRAM_WEBHOOK_SECRET:-}"

cleanup
