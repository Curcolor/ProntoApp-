"""Adaptador de notificaciones Telegram.

Implementa el puerto NotificadorPedidos. Lee TELEGRAM_BOT_TOKEN del entorno;
si está vacío o ausente, no hace nada (no-op). La lógica replica exactamente
la función _notificar_cambio_estado_telegram de api_pedidos.py original."""
import os

import httpx


class TelegramNotificador:
    """Envía mensajes de estado de pedido vía la Bot API de Telegram."""

    _ESTADOS = {
        "recibido": "📋 Recibido y en cola",
        "en_preparacion": "👨‍🍳 En preparación (¡Ya casi!)",
        "listo": "🛍️ Listo para recoger/enviar",
        "en_camino": "🛵 En camino a tu dirección",
        "entregado": "✅ Entregado. ¡Que lo disfrutes!",
    }

    def notificar_cambio_estado(self, chat_id: str, pedido_id: str, estado: str) -> None:
        token = os.getenv("TELEGRAM_BOT_TOKEN", "")
        if not token:
            return
        mensaje = (
            f"🔔 Tu pedido *{pedido_id}* ha cambiado de estado:\n\n"
            f"👉 {self._ESTADOS.get(estado, estado)}"
        )
        try:
            httpx.post(
                f"https://api.telegram.org/bot{token}/sendMessage",
                json={"chat_id": chat_id, "text": mensaje, "parse_mode": "Markdown"},
                timeout=5,
            )
        except Exception as e:
            print(f"Error enviando notificación a Telegram: {e}")
