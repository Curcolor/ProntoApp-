import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvitacionEnviadaModal extends StatelessWidget {
  const InvitacionEnviadaModal({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24),
          child: InvitacionEnviadaModal(),
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
          const SizedBox(height: 32),
          
          // Icono WhatsApp grande
          Container(
            width: 96,
            height: 96,
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
              FontAwesomeIcons.whatsapp,
              size: 42,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Title
          Text(
            'Invitacion enviada',
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
                  TextSpan(text: 'Laura Gomez', style: TextStyle(fontWeight: FontWeight.w700)),
                  TextSpan(text: ' recibira un mensaje de WhatsApp con\nel enlace para unirse a tu equipo en Prontoa.'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Resumen de la invitacion
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
                    icon: FontAwesomeIcons.user,
                    iconColor: const Color(0xFF94A3B8),
                    label: 'Nombre',
                    value: 'Laura Gomez',
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.whatsapp,
                    iconColor: const Color(0xFF25D366),
                    label: 'WhatsApp',
                    value: '+57 315 888 4422',
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.userShield,
                    iconColor: const Color(0xFFF59E0B),
                    label: 'Rol asignado',
                    value: 'Cocinera',
                    showDivider: true,
                  ),
                  _buildInfoRow(
                    icon: FontAwesomeIcons.clock,
                    iconColor: const Color(0xFF94A3B8),
                    label: 'Expiracion',
                    value: '48 horas',
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 28),
          
          // Info adicional
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                border: Border.all(color: const Color(0xFFFDE68A)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: FaIcon(FontAwesomeIcons.infoCircle, size: 14, color: Color(0xFFF59E0B)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Si no acepta en 48h, podras reenviar la invitacion desde la lista del equipo.',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF92400E),
                        height: 1.5,
                      ),
                    ),
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
                        // Navegar o cerrar modal
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
                          const FaIcon(FontAwesomeIcons.plus, size: 13, color: Color(0xFF334155)),
                          const SizedBox(width: 6),
                          Text(
                            'Otro',
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
                        // Ver equipo
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
                          const FaIcon(FontAwesomeIcons.users, size: 13, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Ver equipo',
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
    required Color iconColor,
    required String label,
    required String value,
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
              FaIcon(icon, size: 13, color: iconColor),
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
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
