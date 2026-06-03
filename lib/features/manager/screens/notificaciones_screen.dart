import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  String _filtroActivo = 'Todas';
  final List<String> _filtros = ['Todas', 'Pedidos', 'IA', 'Sistema'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilters(),
            Expanded(
              child: _buildLista(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: FaIcon(FontAwesomeIcons.arrowLeft, color: AppColors.textPrimary, size: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Notificaciones',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              provider.markAllAsRead();
            },
            child: Text(
              'Marcar todo leído',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 11.6,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        scrollDirection: Axis.horizontal,
        itemCount: _filtros.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6.5),
        itemBuilder: (context, index) {
          final filtro = _filtros[index];
          final activo = _filtroActivo == filtro;
          return GestureDetector(
            onTap: () => setState(() => _filtroActivo = filtro),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
              decoration: BoxDecoration(
                color: activo ? AppColors.primary : AppColors.surface,
                border: Border.all(color: activo ? AppColors.primary : AppColors.border),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Center(
                child: Text(
                  filtro,
                  style: GoogleFonts.inter(
                    color: activo ? AppColors.surface : AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLista(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, provider, _) {
        final todas = provider.notifications;
        final filtradas = _filtroActivo == 'Todas'
            ? todas
            : todas.where((n) {
                if (_filtroActivo == 'Pedidos') return n.type == NotificationType.pedido;
                if (_filtroActivo == 'IA') return n.type == NotificationType.ia;
                if (_filtroActivo == 'Sistema') return n.type == NotificationType.sistema;
                return true;
              }).toList();

        if (filtradas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(FontAwesomeIcons.bellSlash, color: AppColors.border, size: 48),
                const SizedBox(height: 16),
                Text(
                  'No hay notificaciones',
                  style: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 14),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(22, 16, 22, 100),
          itemCount: filtradas.length,
          itemBuilder: (context, index) {
            final notif = filtradas[index];
            return _buildNotificationItem(notif, provider);
          },
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationModel notif, NotificationProvider provider) {
    final unread = !notif.isRead;
    return GestureDetector(
      onTap: () {
        if (unread) {
          provider.markAsRead(notif.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.fromLTRB(20, 16, 18, 16),
        decoration: BoxDecoration(
          color: unread ? const Color(0xFFF0FDF4) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            left: BorderSide(color: unread ? AppColors.primary : Colors.transparent, width: 3.2),
            top: BorderSide(color: unread ? AppColors.primary : AppColors.border, width: 1),
            right: BorderSide(color: unread ? AppColors.primary : AppColors.border, width: 1),
            bottom: BorderSide(color: unread ? AppColors.primary : AppColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 41,
              height: 41,
              decoration: BoxDecoration(
                color: notif.iconBgColor,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Center(
                child: FaIcon(notif.icon, color: notif.iconColor, size: 17),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notif.description,
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(notif.timestamp),
                    style: GoogleFonts.inter(
                      color: AppColors.textTertiary,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            if (unread)
              Container(
                width: 8.7,
                height: 8.7,
                margin: const EdgeInsets.only(top: 4, left: 8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }
}

@Preview(name: 'Notificaciones', group: 'Manager', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget notificacionesScreenPreview() => const NotificacionesScreen();

