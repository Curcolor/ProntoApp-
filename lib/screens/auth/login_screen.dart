import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/screens/auth/register_screen.dart';
import 'package:prontoapp/screens/auth/recover_password_screen.dart';
import 'package:prontoapp/screens/auth/processing_screen.dart';
import 'package:prontoapp/widgets/custom_text_field.dart';
import 'package:prontoapp/widgets/auth_popup_dialogs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fondo exacto de Figma fill_AYX6SH
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF25D366),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Logo Area Exacto
              Column(
                children: [
                   Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21.7),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                        stops: [0.0, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF25D366).withAlpha((0.35 * 255).toInt()),
                          blurRadius: 26,
                          offset: const Offset(0, 8.7),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                        size: 34.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Prontoa!',
                    style: GoogleFonts.inter(
                      fontSize: 28.25,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Bienvenido de vuelta',
                    style: GoogleFonts.inter(
                      fontSize: 19.55,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Inicia sesión para gestionar tus pedidos',
                    style: GoogleFonts.inter(
                      fontSize: 14.12,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Inputs Exactos (Sin iconos prefix según figma)
              const CustomTextField(
                label: 'Correo electrónico',
                hintText: 'tu@correo.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              const CustomTextField(
                label: 'Contraseña',
                hintText: '••••••••',
                isPassword: true,
              ),
              
              // Recuperar Contraseña Exactly aligned
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const RecoverPasswordScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1DB954), // fill_HT2GI8
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botón Principal Exacto
              Container(
                height: 52.15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17.38),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF25D366).withAlpha((0.35 * 255).toInt()),
                      blurRadius: 15.2,
                      offset: const Offset(0, 4.3),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const ProcessingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.38),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: GoogleFonts.inter(
                      fontSize: 17.38,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Separador "O continúa con"
              Row(
                children: [
                  Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))), // fill_9QILB3
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'O continúa con',
                      style: GoogleFonts.inter(
                        fontSize: 12, // approx
                        color: const Color(0xFF94A3B8), // fill_UG401K
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))),
                ],
              ),
              const SizedBox(height: 24),

              // Social Logins
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => AuthPopupDialogs.showGoogleOAuthDialog(context),
                        icon: SizedBox(width: 18, height: 18, child: SvgPicture.asset('assets/icons/google-color.svg')),
                        label: Text(
                          'Google',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.04),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () => AuthPopupDialogs.showFacebookOAuthDialog(context),
                        icon: const FaIcon(FontAwesomeIcons.facebook, color: Color(0xFF1877F2), size: 18),
                        label: Text(
                          'Facebook',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF334155),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.04),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 48),
              
              // ¿No tienes cuenta?
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(
                        fontSize: 14.12,
                        color: const Color(0xFF64748B),
                      ),
                      children: const [
                        TextSpan(text: '¿No tienes cuenta? '),
                        TextSpan(
                          text: 'Crear cuenta gratis',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1DB954)),
                        ),
                      ],
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
