import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/screens/auth/login_screen.dart';
import 'package:prontoapp/widgets/custom_text_field.dart';
import 'package:prontoapp/widgets/auth_popup_dialogs.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // fill_AYX6SH
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
              const SizedBox(height: 10),
              // Header Exacto
              Text(
                'Crear cuenta',
                style: GoogleFonts.inter(
                  fontSize: 28.25,
                  fontWeight: 
                  FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Empieza a automatizar hoy mismo.',
                style: GoogleFonts.inter(
                  fontSize: 14.12,
                  color: const Color(0xFF64748B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Formulario Exacto sin íconos según Figma
              const CustomTextField(
                label: 'Nombre completo',
                hintText: 'Juan Pérez',
              ),
              const SizedBox(height: 16),
              
              const CustomTextField(
                label: 'Nombre de Negocio',
                hintText: 'Ej. ProntoDelivery',
              ),
              const SizedBox(height: 16),
              
              const CustomTextField(
                label: 'Correo Electrónico',
                hintText: 'ejemplo@negocio.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              
              const CustomTextField(
                label: 'Contraseña',
                hintText: 'Mínimo 8 caracteres',
                isPassword: true,
              ),
              const SizedBox(height: 32),

              // Botón Principal
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
                    AuthPopupDialogs.showConfirmCodeDialog(context);
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
                    'Registrarse',
                    style: GoogleFonts.inter(
                      fontSize: 17.38,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Separador "o"
              Row(
                children: [
                   Expanded(child: Container(height: 1, color: const Color(0xFFE2E8F0))), // fill_9QILB3
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'O regístrate con',
                      style: GoogleFonts.inter(
                        fontSize: 12,
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
              
              // Ya tienes cuenta?
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                       style: GoogleFonts.inter(
                        fontSize: 14.12,
                        color: const Color(0xFF64748B),
                      ),
                      children: const [
                        TextSpan(text: '¿Ya tienes cuenta? '),
                        TextSpan(
                          text: 'Inicia Sesión',
                          style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1DB954)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
               const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
