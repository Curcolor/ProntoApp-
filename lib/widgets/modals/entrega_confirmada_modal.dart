import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EntregaConfirmadaModal extends StatelessWidget {
  const EntregaConfirmadaModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24),
          child: EntregaConfirmadaModal(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // rgba(0,0,0,0.1)
            offset: Offset(0, 4),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Color(0x2E000000), // rgba(0,0,0,0.18)
            offset: Offset(0, 24),
            blurRadius: 64,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top bar (simulated status bar not needed in a real app modal, but we'll add some top padding)
          const SizedBox(height: 32),
          
          // Success Circle
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x6625D366), // rgba(37,211,102,0.4)
                  offset: Offset(0, 8),
                  blurRadius: 32,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const FaIcon(
              FontAwesomeIcons.check,
              size: 44,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            '¡Entregado con éxito!',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.6,
                ),
                children: const [
                  TextSpan(text: 'El pedido de '),
                  TextSpan(text: 'María García', style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: ' fue entregado\ncorrectamente. El cliente fue notificado vía WhatsApp.'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Info Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: FontAwesomeIcons.hashtag,
                    label: 'Pedido',
                    value: '#P-0041',
                    valueColor: const Color(0xFF0F172A),
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.clock,
                    label: 'Tiempo entrega',
                    value: '7 min 22 seg ✓',
                    valueColor: const Color(0xFF128C7E),
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.route,
                    label: 'Distancia',
                    value: '2.3 km',
                    valueColor: const Color(0xFF0F172A),
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.moneyBillWave,
                    label: 'Cobrado',
                    value: '\$18,500 ✓',
                    valueColor: const Color(0xFF0F172A),
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 28),
          
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.whatsapp, size: 13, color: Color(0xFF25D366)),
                          const SizedBox(width: 6),
                          Text(
                            'Reportar',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x5925D366),
                          offset: Offset(0, 4),
                          blurRadius: 14,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // Vuelve al dashboard de pedidos
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(FontAwesomeIcons.boxOpen, size: 13, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Siguiente entrega',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required FaIconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required bool showDivider,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: showDivider ? const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              FaIcon(icon, size: 13, color: const Color(0xFF94A3B8)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
