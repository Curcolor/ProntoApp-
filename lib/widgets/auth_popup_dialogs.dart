import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prontoapp/screens/auth/processing_screen.dart';

class AuthPopupDialogs {
  // Reusable Floating Icon Dialog Base
  static Future<void> showFloatingIconDialog({
    required BuildContext context,
    required Widget iconRef,
    required Widget child,
    Color iconBackgroundColor = Colors.white,
    bool showNotificationDot = false,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(120),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 36),
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: child,
              ),
              Positioned(
                top: 0,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: iconBackgroundColor == Colors.transparent ? null : [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 15,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        alignment: Alignment.center,
                        child: iconRef,
                      ),
                    ),
                    if (showNotificationDot)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showGoogleOAuthDialog(BuildContext context) {
    showFloatingIconDialog(
      context: context,
      iconRef: SvgPicture.asset('assets/icons/google-color.svg', width: 32, height: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar sesión con Google',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Selecciona la cuenta de Google que deseas\nusar para acceder a Prontoa.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Account 1 (Selected)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4), // Light green background
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF22C55E), width: 1.5), // Green border
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0E7FF), // Subtle blue
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset('assets/icons/google-color.svg', width: 20, height: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Carlos Mendoza',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        'carlos.mendoza@gmail.com',
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.radio_button_checked, color: Color(0xFF22C55E)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          
          // Add Another Account
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9), // Subtle grey
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const FaIcon(FontAwesomeIcons.solidUser, size: 18, color: Color(0xFF94A3B8)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Otra cuenta',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
                      ),
                      Text(
                        'Añadir cuenta de Google',
                        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
                      ),
                    ],
                  ),
                ),
                const FaIcon(FontAwesomeIcons.plus, color: Color(0xFF22C55E), size: 16),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          Text(
            'PRONTOA SOLICITARÁ ACCESO A',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF94A3B8),
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          // Permssion 1
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.solidUserCircle, color: Color(0xFF22C55E), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ver tu información básica de perfil (nombre y foto)',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF1F5F9), height: 1),
          ),
          // Permission 2
          Row(
            children: [
              const FaIcon(FontAwesomeIcons.solidEnvelope, color: Color(0xFF22C55E), size: 18),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ver tu dirección de correo electrónico de Google',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF475569)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Action buttons
          Container(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withAlpha(80),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()));
              },
              icon: SvgPicture.asset('assets/icons/google-color.svg', width: 20, height: 20),
              label: Text(
                'Autorizar con Google',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showFacebookOAuthDialog(BuildContext context) {
    showFloatingIconDialog(
      context: context,
      iconBackgroundColor: const Color(0xFF1877F2), // Facebook Blue
      iconRef: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Iniciar sesión con Facebook',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Usa tu cuenta de Facebook para acceder\nrápidamente a Prontoa.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF64748B),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Email internal field
          Text(
            'Correo o teléfono de Facebook',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: 'tu@correo.com',
              hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1877F2)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          // Password internal field
          Text(
            'Contraseña de Facebook',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              hintText: '••••••••',
              hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
              prefixIcon: const Icon(Icons.lock, color: Color(0xFF94A3B8)),
              suffixIcon: const Icon(Icons.visibility, color: Color(0xFF94A3B8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF1877F2)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Alert info box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FaIcon(FontAwesomeIcons.shieldHalved, color: Color(0xFF1877F2), size: 16),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Solo accederemos a tu nombre y correo.\nNunca publicaremos en tu nombre.',
                    style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B), height: 1.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Action Buttons
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ProcessingScreen()));
              },
              icon: const FaIcon(FontAwesomeIcons.facebookF, color: Colors.white, size: 18),
              label: Text(
                'Iniciar sesión con Facebook',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1877F2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () {},
              child: Text(
                '¿Olvidaste tu contraseña de Facebook?',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1877F2)),
              ),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancelar',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: const Color(0xFF94A3B8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void showConfirmCodeDialog(BuildContext context) {
    showFloatingIconDialog(
      context: context,
      iconBackgroundColor: Colors.transparent,
      showNotificationDot: false,
      iconRef: SvgPicture.asset(
        'assets/icons/IconoCorreo.svg',
        width: 72,
        height: 72,
        fit: BoxFit.contain,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Verificación de correo enviada',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Se enviará un código de verificación al correo electrónico *****@correo.com para el proceso de verificación de su cuenta',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF475569),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // 6 boxes for code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return Container(
                width: 44,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                alignment: Alignment.center,
                child: Text(
                  '0',
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFFE2E8F0)),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 32),
          // Link Text
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF475569)),
                children: [
                  const TextSpan(text: '¿No ha recibido el código de verificación? '),
                  TextSpan(
                    text: 'Vuelve a intentarlo.',
                    style: GoogleFonts.inter(color: const Color(0xFF22C55E)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Confirm Button
          Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF25D366), Color(0xFF128C7E)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF25D366).withAlpha(80),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const ProcessingScreen()),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.arrowRightToBracket, size: 18),
              label: Text(
                'Confirmar',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
