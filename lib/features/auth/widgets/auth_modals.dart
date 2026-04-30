import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/features/manager/screens/manager_main_screen.dart'; // Solo para propósitos de UI (navegación falsa)

class AuthModals {
  static void showLoginGoogle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _SocialAuthDialog(
        title: 'Iniciar sesión con Google',
        iconData: FontAwesomeIcons.google,
        iconColor: Color(0xFFEA4335),
        accountName: 'Carlos Mendoza',
        accountEmail: 'carlos.mendoza@gmail.com',
        authButtonText: 'Autorizar con Google',
      ),
    );
  }

  static void showLoginFacebook(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _SocialAuthDialog(
        title: 'Iniciar sesión con Facebook',
        iconData: FontAwesomeIcons.facebook,
        iconColor: Color(0xFF1877F2),
        accountName: 'Carlos Mendoza',
        accountEmail: 'carlos.mendoza@facebook.com',
        authButtonText: 'Autorizar con Facebook',
      ),
    );
  }

  static void showRevisaCorreo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: const FaIcon(FontAwesomeIcons.envelopeOpenText, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 24),
              Text(
                'Revisa tu correo',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Hemos enviado un enlace mágico a:\ncarlos.mendoza@correo.com\n\nHaz clic en el enlace para entrar.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Entendido',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialAuthDialog extends StatelessWidget {
  final String title;
  final FaIconData iconData;
  final Color iconColor;
  final String accountName;
  final String accountEmail;
  final String authButtonText;

  const _SocialAuthDialog({
    required this.title,
    required this.iconData,
    required this.iconColor,
    required this.accountName,
    required this.accountEmail,
    required this.authButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: const [
                    BoxShadow(color: Color(0x14000000), offset: Offset(0, 1), blurRadius: 3),
                  ],
                ),
                alignment: Alignment.center,
                child: FaIcon(iconData, size: 32, color: iconColor),
              ),
              const SizedBox(height: 16),
              // Title
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'Selecciona la cuenta que deseas\nusar para acceder a Prontoa.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Account List
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  border: Border.all(color: const Color(0xFF25D366)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBEAFE),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        accountName[0],
                        style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: const Color(0xFF1D4ED8)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            accountName,
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                          ),
                          Text(
                            accountEmail,
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF25D366), width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF25D366),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              
              // Add Account
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      alignment: Alignment.center,
                      child: const FaIcon(FontAwesomeIcons.user, size: 20, color: Color(0xFF94A3B8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Otra cuenta',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                          ),
                          Text(
                            'Añadir cuenta',
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: const Color(0xFF94A3B8)),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      '+',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF1DB954)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Permissions
              SizedBox(
                width: double.infinity,
                child: Text(
                  'PRONTOA SOLICITARÁ ACCESO A',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  _buildPermRow(FontAwesomeIcons.solidUserCircle, 'Ver tu información básica de perfil'),
                  const Divider(color: Color(0xFFF1F5F9), height: 16),
                  _buildPermRow(FontAwesomeIcons.solidEnvelope, 'Ver tu dirección de correo electrónico'),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Action Buttons
              Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0x5925D366), offset: Offset(0, 4), blurRadius: 14),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ManagerMainScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(iconData, size: 14, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        authButtonText,
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
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermRow(FaIconData icon, String text) {
    return Row(
      children: [
        FaIcon(icon, size: 14, color: const Color(0xFF1DB954)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }
}
