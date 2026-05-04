#!/bin/bash

echo -e "\033[1;36mConfigurando entorno de desarrollo...\033[0m"

SERVICES_DIR="services"

# Comprobar si existe el entorno virtual, si no, crearlo e instalar dependencias
if [ ! -d "$SERVICES_DIR/.venv" ]; then
    echo -e "\033[1;33mCreando entorno virtual en $SERVICES_DIR/.venv...\033[0m"
    python -m venv "$SERVICES_DIR/.venv"
    echo -e "\033[1;33mInstalando dependencias de Python...\033[0m"
    "$SERVICES_DIR/.venv/Scripts/pip" install -r "$SERVICES_DIR/requirements_bot.txt"
fi

# Función para limpiar los procesos en segundo plano al salir
cleanup() {
    echo ""
    echo -e "\033[1;33mApagando servicios en segundo plano...\033[0m"
    kill $API_PID 2>/dev/null
    kill $BOT_PID 2>/dev/null
    echo -e "\033[1;36m¡Entorno detenido correctamente!\033[0m"
    exit
}

# Atrapar Ctrl+C (SIGINT) o la terminación del script para ejecutar cleanup
trap cleanup SIGINT SIGTERM EXIT

echo -e "\033[1;32mIniciando API de Pedidos (FastAPI)...\033[0m"
(cd "$SERVICES_DIR" && "./.venv/Scripts/python" src/api_pedidos.py) &
API_PID=$!

echo -e "\033[1;32mIniciando Bot de Telegram...\033[0m"
(cd "$SERVICES_DIR" && "./.venv/Scripts/python" src/bot_telegram.py) &
BOT_PID=$!

echo -e "\033[1;35mIniciando Flutter Server...\033[0m"
flutter run -d web-server
