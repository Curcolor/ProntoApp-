import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 21.73, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Configuración',
            style: GoogleFonts.inter(
              color: const Color(0xFF0F172A),
              fontSize: 23.90,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.33,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildSectionTitle('NOTIFICACIONES'),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.bell,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF15803D),
              title: 'Nuevos pedidos',
              subtitle: 'Alerta inmediata al recibir',
              value: _newOrders,
              onChanged: (val) => setState(() => _newOrders = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.box,
              iconBgColor: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF1D4ED8),
              title: 'Recordatorio entrega',
              subtitle: 'Aviso antes de la hora',
              value: _deliveryReminder,
              onChanged: (val) => setState(() => _deliveryReminder = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.star,
              iconBgColor: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFB45309),
              title: 'Reseñas de clientes',
              subtitle: 'Cuando dejan opinión',
              value: _customerReviews,
              onChanged: (val) => setState(() => _customerReviews = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.chartSimple,
              iconBgColor: const Color(0xFFEDE9FE),
              iconColor: const Color(0xFF6D28D9),
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
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.robot,
              iconBgColor: const Color(0xFFDCFCE7),
              iconColor: const Color(0xFF15803D),
              title: 'IA activada',
              subtitle: 'Responde pedidos automáticamente',
              value: _aiEnabled,
              onChanged: (val) => setState(() => _aiEnabled = val),
            ),
            _buildNavigationRow(
              icon: FontAwesomeIcons.gear,
              iconBgColor: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF1D4ED8),
              title: 'Configuración básica',
              subtitle: 'Comportamiento básico y mensajes',
              isLast: true,
            ),
          ]),
          
          const SizedBox(height: 24),
          _buildSectionTitle('VISUALIZACIÓN'),
          const SizedBox(height: 8),
          _buildSettingsGroup([
            _buildToggleRow(
              icon: FontAwesomeIcons.eyeSlash,
              iconBgColor: const Color(0xFFF1F5F9),
              iconColor: const Color(0xFF475569),
              title: 'Ocultar cancelados',
              subtitle: 'Solo mostrar activos',
              value: _hideCancelled,
              onChanged: (val) => setState(() => _hideCancelled = val),
            ),
            _buildToggleRow(
              icon: FontAwesomeIcons.arrowDownWideShort,
              iconBgColor: const Color(0xFFF1F5F9),
              iconColor: const Color(0xFF475569),
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
              iconBgColor: const Color(0xFF0F172A),
              iconColor: const Color(0xFF94A3B8),
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
              icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket, color: Color(0xFFB91C1C), size: 16),
              label: Text(
                'Borrar Cuenta',
                style: GoogleFonts.inter(
                  color: const Color(0xFFB91C1C),
                  fontSize: 14.12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.04)),
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
      padding: const EdgeInsets.symmetric(horizontal: 4.35),
      child: Text(
        title,
        style: GoogleFonts.inter(
          color: const Color(0xFF94A3B8),
          fontSize: 11.95,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.87,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17.38),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.09),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.04 * 255).toInt()),
            blurRadius: 2.17,
            offset: const Offset(0, 1.09),
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
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
      decoration: BoxDecoration(
        border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.09)),
      ),
      child: Row(
        children: [
          Container(
            width: 36.94,
            height: 36.94,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(8.69),
            ),
            child: Center(
              child: FaIcon(icon, color: iconColor, size: 16.30),
            ),
          ),
          const SizedBox(width: 13.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 14.12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
                    fontSize: 11.95,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF25D366),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFCBD5E1),
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
  }) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17.38, vertical: 15.21),
        decoration: BoxDecoration(
          border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1.09)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.94,
              height: 36.94,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8.69),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 16.30),
              ),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1E293B),
                      fontSize: 14.12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF64748B),
                      fontSize: 11.95,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const FaIcon(FontAwesomeIcons.chevronRight, color: Color(0xFFCBD5E1), size: 13.04),
          ],
        ),
      ),
    );
  }
}
