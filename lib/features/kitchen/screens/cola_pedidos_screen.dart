import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/core/constants/app_colors.dart';

class ColaPedidosScreen extends StatelessWidget {
  const ColaPedidosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> mockOrders = [
      {
        'orderId': '#38',
        'orderRef': 'Pedido #P-0038',
        'channel': 'vía WhatsApp · Ana Martínez',
        'statusLabel': '¡Urgente!',
        'statusBgColor': AppColors.dangerBg,
        'statusTextColor': AppColors.dangerText,
        'borderColor': AppColors.dangerIcon,
        'timer': '12:35 min',
        'timerColor': AppColors.dangerDark,
        'timerBgColor': AppColors.dangerBg,
        'items': ['2× Pan de bono', '1× Almojábana', '1× Café tinto'],
        'primaryActionText': 'Preparando',
        'primaryActionIcon': FontAwesomeIcons.fire,
        'primaryActionBgColor': AppColors.warningIcon,
        'secondaryActionText': 'Listo',
        'secondaryActionIcon': FontAwesomeIcons.check,
        'secondaryActionBgColor': AppColors.textPrimary,
      },
      {
        'orderId': '#39',
        'orderRef': 'Pedido #P-0039',
        'channel': 'vía WhatsApp · Luis Pérez',
        'statusLabel': 'En prep.',
        'statusBgColor': AppColors.warningBg,
        'statusTextColor': AppColors.warningText,
        'borderColor': AppColors.warningIcon,
        'timer': '5:20 min',
        'timerColor': AppColors.warningText,
        'timerBgColor': AppColors.warningBg,
        'items': ['3× Croissant de jamón', '2× Jugo de naranja'],
        'primaryActionText': 'Marcar listo',
        'primaryActionIcon': FontAwesomeIcons.check,
        'primaryActionBgColor': AppColors.textPrimary,
      },
      {
        'orderId': '#40',
        'orderRef': 'Pedido #P-0040',
        'channel': 'vía WhatsApp · Juan Rodríguez',
        'statusLabel': 'Nuevo',
        'statusBgColor': AppColors.successBg,
        'statusTextColor': AppColors.successText,
        'borderColor': AppColors.borderLight, // Gray border for new
        'timer': '0:45 min',
        'timerColor': AppColors.successText,
        'timerBgColor': AppColors.successBg,
        'items': ['2× Pan de queso', '1× Chocolate caliente', '1× Medialunas ×3'],
        'primaryActionText': 'Empezar',
        'primaryActionIcon': FontAwesomeIcons.play,
        'primaryActionBgColor': AppColors.primary,
      },
      {
        'orderId': '#41',
        'orderRef': 'Pedido #P-0041',
        'channel': 'vía WhatsApp · María García',
        'statusLabel': 'Nuevo',
        'statusBgColor': AppColors.successBg,
        'statusTextColor': AppColors.successText,
        'borderColor': AppColors.primary, // Green border
        'timer': '0:10 min',
        'timerColor': AppColors.successText,
        'timerBgColor': AppColors.successBg,
        'items': ['1× Torta de cumpleaños', '2× Palitos de queso'],
        'primaryActionText': 'Empezar',
        'primaryActionIcon': FontAwesomeIcons.play,
        'primaryActionBgColor': AppColors.primary,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
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
                _buildShiftMetric('3', '🔴 Urgentes', AppColors.dangerDark),
                _buildShiftMetric('5', '🟡 En cola', AppColors.warningText),
                _buildShiftMetric('12', '✅ Listos', AppColors.primaryDark),
              ],
            ),
            const SizedBox(height: 16),
            
            // Urgency Tabs
            Row(
              children: [
                _buildUrgencyTab('3', 'Urgente', const Color(0xFFFEF2F2), AppColors.dangerIcon, AppColors.dangerDark),
                const SizedBox(width: 8),
                _buildUrgencyTab('5', 'Pendiente', const Color(0xFFFFFBEB), AppColors.warningIcon, AppColors.warningDark),
                const SizedBox(width: 8),
                _buildUrgencyTab('12', 'Listos', const Color(0xFFF0FDF4), AppColors.primary, AppColors.primaryDark),
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
                    color: AppColors.textPrimary,
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mockOrders.length,
              itemBuilder: (context, index) {
                final order = mockOrders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildOrderCard(
                    orderId: order['orderId'] as String,
                    orderRef: order['orderRef'] as String,
                    channel: order['channel'] as String,
                    statusLabel: order['statusLabel'] as String,
                    statusBgColor: order['statusBgColor'] as Color,
                    statusTextColor: order['statusTextColor'] as Color,
                    borderColor: order['borderColor'] as Color,
                    timer: order['timer'] as String,
                    timerColor: order['timerColor'] as Color,
                    timerBgColor: order['timerBgColor'] as Color,
                    items: order['items'] as List<String>,
                    primaryActionText: order['primaryActionText'] as String,
                    primaryActionIcon: order['primaryActionIcon'] as FaIconData,
                    primaryActionBgColor: order['primaryActionBgColor'] as Color,
                    secondaryActionText: order['secondaryActionText'] as String?,
                    secondaryActionIcon: order['secondaryActionIcon'] as FaIconData?,
                    secondaryActionBgColor: order['secondaryActionBgColor'] as Color?,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
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
                  color: AppColors.textTertiary,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'Pedro Naranjo',
                style: GoogleFonts.inter(
                  color: AppColors.textPrimary,
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
              color: AppColors.warningBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.warningIcon,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                FaIcon(FontAwesomeIcons.fireBurner, color: AppColors.warningDarker, size: 11),
                const SizedBox(width: 6),
                Text(
                  'Cocina',
                  style: GoogleFonts.inter(
                    color: AppColors.warningDarker,
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
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
                color: AppColors.textTertiary,
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
    required FaIconData primaryActionIcon,
    required Color primaryActionBgColor,
    String? secondaryActionText,
    FaIconData? secondaryActionIcon,
    Color? secondaryActionBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 15, 17, 15),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
          top: const BorderSide(color: AppColors.borderLight, width: 1),
          right: const BorderSide(color: AppColors.borderLight, width: 1),
          bottom: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        channel,
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
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
                      margin: const EdgeInsets.only(right: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.textMuted,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          
          // Bottom Row Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: timerBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    FaIcon(FontAwesomeIcons.clock, color: timerColor, size: 9),
                    const SizedBox(width: 4),
                    Text(
                      timer,
                      style: GoogleFonts.inter(
                        color: timerColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  if (secondaryActionText != null && secondaryActionIcon != null && secondaryActionBgColor != null) ...[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: secondaryActionBgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            FaIcon(secondaryActionIcon, color: AppColors.surface, size: 10),
                            const SizedBox(width: 6),
                            Text(
                              secondaryActionText,
                              style: GoogleFonts.inter(
                                color: AppColors.surface,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryActionBgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          FaIcon(primaryActionIcon, color: AppColors.surface, size: 10),
                          const SizedBox(width: 6),
                          Text(
                            primaryActionText,
                            style: GoogleFonts.inter(
                              color: AppColors.surface,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
