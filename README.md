# 🚀 ProntoApp - Sistema de Gestión de Pedidos

ProntoApp es una solución integral para la gestión de pedidos en tiempo real, diseñada para conectar negocios (panaderías, restaurantes, etc.) con sus clientes, cocina y personal de reparto.

## 📱 Módulos del Sistema

1.  **Módulo Gerente**: Control de inventario, visualización de KPIs, gestión de equipo y monitoreo de pedidos activos.
2.  **Módulo Cocina**: Cola de pedidos en tiempo real con sistema de "marcado" de ítems para asegurar la precisión en la preparación.
3.  **Módulo Reparto**: Dashboard dinámico para recolectar pedidos listos y gestionar entregas mediante mapas en tiempo real.
4.  **Bot de Telegram**: Canal de entrada de pedidos automatizado para los clientes.

---

## 🛠️ Arquitectura y Funcionamiento

El proyecto utiliza una arquitectura moderna basada en **Provider** para el manejo de estado y un backend ligero en **Python** con persistencia en **JSON**.

### 1. Persistencia de Datos (JSON)
El "corazón" de los datos reside en el archivo `pedidos.json`.
*   **Sincronización**: La aplicación Flutter se comunica con una API Python (`api_pedidos.py`) que lee y escribe en este archivo.
*   **Estructura**: Cada pedido contiene ID único, información del cliente, lista de ítems, totales, dirección (si aplica) y el **estado** actual.

### 2. Estados del Pedido
El flujo de vida de un pedido es lineal y se refleja en tiempo real en todos los módulos:
*   `recibido` ➔ `en_preparacion` ➔ `listo` ➔ `en_camino` ➔ `entregado`

### 3. Almacenamiento Local (SharedPreferences)
Se utiliza para gestionar la sesión del usuario y la persistencia ligera:
*   **Sesiones**: Almacena el usuario actual y su rol para mantener la sesión iniciada tras cerrar la app.
*   **Cache de Pedidos**: En caso de pérdida de conexión con la API, la aplicación utiliza una copia local guardada en SharedPreferences para permitir que el personal siga viendo los pedidos actuales (modo offline optimista).

### 4. Gestión de Estado (Provider)
*   **`AuthService`**: Singleton que gestiona el login, logout y los roles (Gerente, Cocinero, Repartidor).
*   **`OrderProvider`**: Gestor central de los pedidos. Realiza *polling* constante a la API para recibir actualizaciones y expone listas filtradas (`listos`, `activos`, `enCamino`) que disparan la reconstrucción de la UI automáticamente.

---

## 🚀 Cómo empezar

### Requisitos
*   Flutter SDK (3.x o superior)
*   Python 3.10+
*   Dependencias de Python: `flask`, `flask-cors`

### Ejecución
1.  **Backend**:
    ```bash
    python api_pedidos.py
    ```
2.  **Frontend**:
    ```bash
    flutter run
    ```
3.  **Bot (Opcional)**:
    ```bash
    python bot_telegram.py
    ```

---

## 🎨 Diseño Visual
El proyecto sigue una estética **Premium** inspirada en diseños de Figma, utilizando:
*   **Tipografía**: Google Fonts (Inter)
*   **Iconografía**: FontAwesome
*   **Colores**: Paletas HSL personalizadas con soportes de modo oscuro y glassmorphism.

---

## 📝 Reglas de Desarrollo (Conventional Commits)
Este proyecto sigue el estándar de commit convencional:
*   `feat(...)`: Nuevas funcionalidades.
*   `fix(...)`: Corrección de errores.
*   `docs(...)`: Cambios en documentación.
*   `refactor(...)`: Cambios en el código que no afectan la funcionalidad.

---
*Desarrollado con ❤️ por el equipo de ProntoApp.*
