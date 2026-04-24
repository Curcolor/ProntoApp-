import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditarPerfilModals {
  static void showEditarCorreo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Editar correo electrónico',
        subtitle: 'El correo es tu identificador de acceso a Prontoa.',
        currentLabel: 'Correo actual',
        currentValue: 'carlos.mendoza@correo.com',
        currentIcon: FontAwesomeIcons.solidEnvelope,
        inputLabel1: 'Nuevo correo electrónico',
        inputHint1: 'nuevo@correo.com',
        inputIcon1: FontAwesomeIcons.solidEnvelope,
        inputLabel2: 'Confirmar nuevo correo',
        inputHint2: 'nuevo@correo.com',
        inputIcon2: FontAwesomeIcons.solidCheckCircle,
        infoText: 'Te enviaremos un enlace de verificación al nuevo correo antes de aplicar el cambio.',
        submitText: 'Enviar verificación',
        submitIcon: FontAwesomeIcons.paperPlane,
      ),
    );
  }

  static void showEditarTelefono(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Editar teléfono',
        subtitle: 'Tu número es usado para contactarte y para iniciar sesión.',
        currentLabel: 'Teléfono actual',
        currentValue: '+57 315 888 4422',
        currentIcon: FontAwesomeIcons.phoneAlt,
        inputLabel1: 'Nuevo número de teléfono',
        inputHint1: '+57 300 000 0000',
        inputIcon1: FontAwesomeIcons.phoneAlt,
        inputLabel2: 'Confirmar nuevo número',
        inputHint2: '+57 300 000 0000',
        inputIcon2: FontAwesomeIcons.solidCheckCircle,
        infoText: 'Se requerirá confirmación vía SMS.',
        submitText: 'Guardar cambios',
        submitIcon: FontAwesomeIcons.save,
      ),
    );
  }

  static void showCambiarContrasena(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _BaseEditBottomSheet(
        title: 'Cambiar Contraseña',
        subtitle: 'Asegúrate de usar al menos 8 caracteres.',
        currentLabel: 'Seguridad actual',
        currentValue: 'Contraseña fuerte',
        currentIcon: FontAwesomeIcons.lock,
        inputLabel1: 'Nueva contraseña',
        inputHint1: '••••••••',
        inputIcon1: FontAwesomeIcons.lock,
        inputLabel2: 'Confirmar nueva contraseña',
        inputHint2: '••••••••',
        inputIcon2: FontAwesomeIcons.solidCheckCircle,
        infoText: 'Cerraremos las sesiones en otros dispositivos.',
        submitText: 'Actualizar',
        submitIcon: FontAwesomeIcons.check,
        obscureText: true,
      ),
    );
  }
}

class _BaseEditBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String currentLabel;
  final String currentValue;
  final IconData currentIcon;
  final String inputLabel1;
  final String inputHint1;
  final IconData inputIcon1;
  final String inputLabel2;
  final String inputHint2;
  final IconData inputIcon2;
  final String infoText;
  final String submitText;
  final IconData submitIcon;
  final bool obscureText;

  const _BaseEditBottomSheet({
    required this.title,
    required this.subtitle,
    required this.currentLabel,
    required this.currentValue,
    required this.currentIcon,
    required this.inputLabel1,
    required this.inputHint1,
    required this.inputIcon1,
    required this.inputLabel2,
    required this.inputHint2,
    required this.inputIcon2,
    required this.infoText,
    required this.submitText,
    required this.submitIcon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 24,
        right: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 24),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 24),
          
          // Current Value Chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              border: Border.all(color: const Color(0xFFBBF7D0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                FaIcon(currentIcon, size: 14, color: const Color(0xFF1DB954)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentLabel,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentValue,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF128C7E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Inputs
          _buildInputGroup(inputLabel1, inputHint1, inputIcon1),
          const SizedBox(height: 16),
          _buildInputGroup(inputLabel2, inputHint2, inputIcon2),
          
          const SizedBox(height: 20),
          
          // Info Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: FaIcon(FontAwesomeIcons.infoCircle, size: 14, color: Color(0xFF1DB954)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    infoText,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 28),
          
          // Buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF334155)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF25D366), Color(0xFF128C7E)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14)],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
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
                        FaIcon(submitIcon, size: 16, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(
                          submitText,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputGroup(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: FaIcon(icon, size: 16, color: const Color(0xFF94A3B8)),
              ),
              Expanded(
                child: TextField(
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF757575),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
