import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ColaPedidosScreen extends StatelessWidget {
  const ColaPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shift Metrics
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildShiftMetric('3', '🔴 Urgentes', const Color(0xFFDC2626)),
                _buildShiftMetric('5', '🟡 En cola', const Color(0xFFB45309)),
                _buildShiftMetric('12', '✅ Listos', const Color(0xFF128C7E)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Urgency Tabs
            Row(
              children: [
                _buildUrgencyTab('3', 'Urgente', const Color(0xFFFEF2F2), const Color(0xFFEF4444), const Color(0xFFDC2626)),
                const SizedBox(width: 8),
                _buildUrgencyTab('5', 'Pendiente', const Color(0xFFFFFBEB), const Color(0xFFF59E0B), const Color(0xFFD97706)),
                const SizedBox(width: 8),
                _buildUrgencyTab('12', 'Listos', const Color(0xFFF0FDF4), const Color(0xFF25D366), const Color(0xFF128C7E)),
              ],
            ),
            const SizedBox(height: 24),
            
            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '📋 Cola activa',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1E293B),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ordenar ↕',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1DB954),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Orders List
            _buildOrderCard(
              orderId: '#38',
              orderRef: 'Pedido #P-0038',
              channel: 'vía WhatsApp · Ana Martínez',
              statusLabel: '¡Urgente!',
              statusBgColor: const Color(0xFFFEE2E2),
              statusTextColor: const Color(0xFFB91C1C),
              borderColor: const Color(0xFFEF4444),
              timer: '12:35 min',
              timerColor: const Color(0xFFDC2626),
              timerBgColor: const Color(0xFFFEE2E2),
              items: ['2× Pan de bono', '1× Almojábana', '1× Café tinto'],
              primaryActionText: 'Preparando',
              primaryActionIcon: FontAwesomeIcons.fire,
              primaryActionBgColor: const Color(0xFFF59E0B),
              secondaryActionText: 'Listo',
              secondaryActionIcon: FontAwesomeIcons.check,
              secondaryActionBgColor: const Color(0xFF1E293B),
            ),
            const SizedBox(height: 12),
            _buildOrderCard(
              orderId: '#39',
              orderRef: 'Pedido #P-0039',
              channel: 'vía WhatsApp · Luis Pérez',
              statusLabel: 'En prep.',
              statusBgColor: const Color(0xFFFEF3C7),
              statusTextColor: const Color(0xFFB45309),
              borderColor: const Color(0xFFF59E0B),
              timer: '5:20 min',
              timerColor: const Color(0xFFB45309),
              timerBgColor: const Color(0xFFFEF3C7),
              items: ['3× Croissant de jamón', '2× Jugo de naranja'],
              primaryActionText: 'Marcar listo',
              primaryActionIcon: FontAwesomeIcons.check,
              primaryActionBgColor: const Color(0xFF1E293B),
            ),
            const SizedBox(height: 12),
            _buildOrderCard(
              orderId: '#40',
              orderRef: 'Pedido #P-0040',
              channel: 'vía WhatsApp · Juan Rodríguez',
              statusLabel: 'Nuevo',
              statusBgColor: const Color(0xFFDCFCE7),
              statusTextColor: const Color(0xFF15803D),
              borderColor: const Color(0xFFF1F5F9), // Gray border for new
              timer: '0:45 min',
              timerColor: const Color(0xFF15803D),
              timerBgColor: const Color(0xFFDCFCE7),
              items: ['2× Pan de queso', '1× Chocolate caliente', '1× Medialunas ×3'],
              primaryActionText: 'Empezar',
              primaryActionIcon: FontAwesomeIcons.play,
              primaryActionBgColor: const Color(0xFF25D366),
            ),
             const SizedBox(height: 12),
            _buildOrderCard(
              orderId: '#41',
              orderRef: 'Pedido #P-0041',
              channel: 'vía WhatsApp · María García',
              statusLabel: 'Nuevo',
              statusBgColor: const Color(0xFFDCFCE7),
              statusTextColor: const Color(0xFF15803D),
              borderColor: const Color(0xFF25D366), // Green border
              timer: '0:10 min',
              timerColor: const Color(0xFF15803D),
              timerBgColor: const Color(0xFFDCFCE7),
              items: ['1× Torta de cumpleaños', '2× Palitos de queso'],
              primaryActionText: 'Empezar',
              primaryActionIcon: FontAwesomeIcons.play,
              primaryActionBgColor: const Color(0xFF25D366),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8FAFC),
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenos días 👋',
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Pedro Naranjo',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF59E0B),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                const FaIcon(FontAwesomeIcons.fireBurner, color: Color(0xFF92400E), size: 11),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF92400E),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildShiftMetric(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F5F9), width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.08 * 255).toInt()),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: valueColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgencyTab(String value, String label, Color bgColor, Color borderColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                color: textColor,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String orderRef,
    required String channel,
    required String statusLabel,
    required Color statusBgColor,
    required Color statusTextColor,
    required Color borderColor,
    required String timer,
    required Color timerColor,
    required Color timerBgColor,
    required List<String> items,
    required String primaryActionText,
    required IconData primaryActionIcon,
    required Color primaryActionBgColor,
    String? secondaryActionText,
    IconData? secondaryActionIcon,
    Color? secondaryActionBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 17, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          top: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
          right: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
          bottom: const BorderSide(color: Color(0xFFF1F5F9), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.08 * 255).toInt()),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        orderId,
                        style: GoogleFonts.inter(
                          color: statusTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderRef,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0F172A),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        channel,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF94A3B8),
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.inter(
                    color: statusTextColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          
          // Items
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      item,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF334155),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          
          // Footer with Timer and Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: timerBgColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.clock, color: timerColor, size: 11),
                    const SizedBox(width: 5),
                    Text(
                      timer,
                      style: GoogleFonts.inter(
                        color: timerColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildActionButton(
                    text: primaryActionText,
                    icon: primaryActionIcon,
                    bgColor: primaryActionBgColor,
                  ),
                  if (secondaryActionText != null && secondaryActionIcon != null && secondaryActionBgColor != null) ...[
                    const SizedBox(width: 6),
                    _buildActionButton(
                      text: secondaryActionText,
                      icon: secondaryActionIcon,
                      bgColor: secondaryActionBgColor,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required Color bgColor,
  }) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, color: Colors.white, size: 11),
          const SizedBox(width: 5),
          Text(
            text,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
