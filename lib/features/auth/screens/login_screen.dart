import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:prontoapp/features/auth/screens/register_screen.dart';
import 'package:prontoapp/features/auth/screens/recover_password_screen.dart';
import 'package:prontoapp/core/widgets/custom_text_field.dart';
import 'package:prontoapp/features/auth/widgets/auth_popup_dialogs.dart';

import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/features/manager/screens/manager_main_screen.dart';
import 'package:prontoapp/features/kitchen/screens/kitchen_main_screen.dart';
import 'package:prontoapp/features/delivery/screens/delivery_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _botonPresionado = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = await AuthService().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (user != null) {
      // Como estamos usando Provider y Consumer en main.dart, al hacer login
      // la aplicación automáticamente redibuja la pantalla inicial correcta.
      // Sin embargo, como estamos dentro de un sub-árbol de navegación (Navigator.push),
      // debemos limpiar la pila para volver a la raíz.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          switch (user.role) {
            case RoleType.gerente: return const ManagerMainScreen();
            case RoleType.cocinero: return const KitchenMainScreen();
            case RoleType.repartidor: return const DeliveryMainScreen();
          }
        }),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas. (Pista: usa gerente@prontoa.com / password123)'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leadingWidth: 76,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _botonPresionado = true),
            onTapUp: (_) {
              setState(() => _botonPresionado = false);
              Navigator.of(context).pop();
            },
            onTapCancel: () => setState(() => _botonPresionado = false),
            child: AnimatedScale(
              scale: _botonPresionado ? 0.88 : 1.0,
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              child: Container(
                width: 43.46,
                height: 43.46,
                decoration: BoxDecoration(
                  color: _botonPresionado
                      ? const Color(0xFFCBD5E1) // gris más oscuro al presionar
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(13.04),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF334155),
                  size: 18,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 0.0),
          child: Form(
            key: _formKey,
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
                CustomTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  hintText: 'gerente@prontoa.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Ingresa un correo válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  hintText: '••••••••',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu contraseña';
                    }
                    if (value.length < 6) {
                      return 'La contraseña debe tener al menos 6 caracteres';
                    }
                    return null;
                  },
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

                // Botón Principal Exacto (diseño: 56.5, más alto que los sociales)
                Container(
                  height: 56.5,
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
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17.38),
                      ),
                    ),
                    child: _isLoading 
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text(
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
      ),
    );
  }
}

@Preview(name: 'Login', group: 'Auth', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget loginScreenPreview() => const LoginScreen();
