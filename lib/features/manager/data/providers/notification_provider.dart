import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

enum NotificationType { pedido, ia, sistema }

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });

  FaIconData get icon {
    switch (type) {
      case NotificationType.pedido:
        return FontAwesomeIcons.bagShopping;
      case NotificationType.ia:
        return FontAwesomeIcons.robot;
      case NotificationType.sistema:
        return FontAwesomeIcons.clockRotateLeft; // Or warning
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.pedido:
        return AppColors.successText;
      case NotificationType.ia:
        return AppColors.primary; // Blue
      case NotificationType.sistema:
        return AppColors.warningText;
    }
  }

  Color get iconBgColor {
    switch (type) {
      case NotificationType.pedido:
        return AppColors.successBg;
      case NotificationType.ia:
        return const Color(0xFFDBEAFE); // light blue
      case NotificationType.sistema:
        return AppColors.warningBg;
    }
  }
}

class NotificationProvider extends ChangeNotifier {
  final List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  NotificationProvider() {
    _initializeDefaultData();
  }

  void _initializeDefaultData() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        id: '1',
        title: 'Nuevo pedido recibido',
        description: 'María García · 2× Pan de bono, 1× Almojábana\n· \$18,500',
        timestamp: now.subtract(const Duration(minutes: 2)),
        type: NotificationType.pedido,
      ),
      NotificationModel(
        id: '2',
        title: 'IA procesó pedido #P-0040',
        description: 'El agente confirmó automáticamente el pedido\nde Juan Rodríguez',
        timestamp: now.subtract(const Duration(minutes: 7)),
        type: NotificationType.ia,
      ),
      NotificationModel(
        id: '3',
        title: 'Pedido #P-0038 lleva 6 min sin confirmar',
        description: 'Ana Martínez espera respuesta. Revisa el\npedido pronto.',
        timestamp: now.subtract(const Duration(minutes: 6)),
        type: NotificationType.sistema,
      ),
      NotificationModel(
        id: '4',
        title: 'Pedido #P-0037 entregado',
        description: 'Luis Pérez recibió su pedido. Pago confirmado:\n\$24,000',
        timestamp: now.subtract(const Duration(minutes: 35)),
        type: NotificationType.pedido,
        isRead: true, // Example of read notification
      ),
      NotificationModel(
        id: '5',
        title: 'Conexión WhatsApp inestable',
        description: 'Se detectó una interrupción breve. La IA está\nnuevamente activa.',
        timestamp: now.subtract(const Duration(hours: 24, minutes: 30)),
        type: NotificationType.sistema,
        isRead: true,
      ),
    ]);
  }

  void addNotification(NotificationModel notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !_notifications[index].isRead) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    bool changed = false;
    for (var n in _notifications) {
      if (!n.isRead) {
        n.isRead = true;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }
}
