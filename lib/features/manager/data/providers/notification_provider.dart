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
    // Inicialmente vacío, se llena dinámicamente con eventos reales.
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
