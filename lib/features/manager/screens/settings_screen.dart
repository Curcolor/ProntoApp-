import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/features/manager/data/providers/order_provider.dart';
import 'package:prontoapp/features/manager/widgets/configurar_agente_modal.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock state for toggles
  bool _newOrders = true;
  bool _deliveryReminder = true;
  bool _customerReviews = false;
  bool _dailyReport = true;
  bool _aiEnabled = true;
  bool _hideCancelled = true;
  bool _sortByRecent = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuración',
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('NOTIFICACIONES'),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.bell,
              iconBgColor: AppColors.successBg,
              iconColor: AppColors.successText,
              title: 'Nuevos pedidos',
              subtitle: 'Alerta inmediata al recibir',
              value: _newOrders,
              onChanged: (val) => setState(() => _newOrders = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.box,
              iconBgColor: AppColors.infoBg,
              iconColor: AppColors.infoText,
              title: 'Recordatorio entrega',
              subtitle: 'Aviso antes de la hora',
              value: _deliveryReminder,
              onChanged: (val) => setState(() => _deliveryReminder = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.star,
              iconBgColor: AppColors.warningBg,
              iconColor: AppColors.warningText,
              title: 'Reseñas de clientes',
              subtitle: 'Cuando dejan opinión',
              value: _customerReviews,
              onChanged: (val) => setState(() => _customerReviews = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.chartSimple,
              iconBgColor: AppColors.aiBg,
              iconColor: AppColors.aiText,
              title: 'Reporte diario',
              subtitle: 'Resumen al finalizar el día',
              value: _dailyReport,
              onChanged: (val) => setState(() => _dailyReport = val),
              isLast: true,
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionTitle('AGENTE IA'),
          const SizedBox(height: 8),
          Consumer<OrderProvider>(
            builder: (context, orderProvider, child) {
              final bool conectada = orderProvider.estaConectado;
              
              return _buildSettingsGroup([
                _buildToggleRow(
                  icon: FontAwesomeIcons.robot,
                  iconBgColor: conectada ? AppColors.successBg : AppColors.warningBg,
                  iconColor: conectada ? AppColors.successText : AppColors.warningText,
                  title: conectada ? 'IA activada' : 'IA no activa',
                  subtitle: conectada 
                      ? 'Responde pedidos automáticamente' 
                      : 'Sin conexión al servidor',
                  value: conectada ? _aiEnabled : false,
                  onChanged: conectada ? (val) => setState(() => _aiEnabled = val) : null,
                ),
                _buildNavigationRow(
                  icon: FontAwesomeIcons.gear,
                  iconBgColor: AppColors.infoBg,
                  iconColor: AppColors.infoText,
                  title: 'Configuración básica',
                  subtitle: 'Comportamiento básico y mensajes',
                  isLast: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const ConfigurarAgenteModal(),
                    );
                  },
                ),
              ]);
            },
          ),
          
          const SizedBox(height: 24),
          _buildSectionTitle('VISUALIZACIÓN'),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.eyeSlash,
              iconBgColor: AppColors.borderLight,
              iconColor: AppColors.textSecondary,
              title: 'Ocultar cancelados',
              subtitle: 'Solo mostrar activos',
              value: _hideCancelled,
              onChanged: (val) => setState(() => _hideCancelled = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.arrowDownWideShort,
              iconBgColor: AppColors.borderLight,
              iconColor: AppColors.textSecondary,
              title: 'Ordenar por recientes',
              subtitle: 'Más nuevos primero',
              value: _sortByRecent,
              onChanged: (val) => setState(() => _sortByRecent = val),
              isLast: true,
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionTitle('APLICACIÓN'),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.moon,
              iconBgColor: AppColors.textPrimary,
              iconColor: AppColors.textMuted,
              title: 'Modo oscuro',
              subtitle: 'Tema oscuro en la app',
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
              isLast: true,
            ),
          ]),
          
          const SizedBox(height: 32),
          // Delete account button
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket, color: AppColors.dangerText, size: 16),
              label: Text(
                'Borrar Cuenta',
                style: GoogleFonts.inter(
                  color: AppColors.dangerText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: AppColors.textMuted,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: rows,
      ),
    );
  }

  Widget _buildToggleRow({
    required FaIconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: FaIcon(icon, color: iconColor, size: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary, // Or specific title color
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: AppColors.textTertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.surface,
            activeTrackColor: AppColors.primary,
            inactiveThumbColor: AppColors.toggleInactiveThumb,
            inactiveTrackColor: AppColors.toggleInactiveBg,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required FaIconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: AppColors.borderLight, width: 1)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 16),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: AppColors.textTertiary,
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: AppColors.toggleInactiveBg, size: 14),
          ],
        ),
      ),
    );
  }
}
