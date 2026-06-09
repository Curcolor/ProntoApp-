import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:prontoapp/preview_support/preview_theme.dart';
import 'package:prontoapp/preview_support/preview_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prontoapp/features/auth/screens/login_screen.dart';
import 'package:prontoapp/features/auth/widgets/auth_popup_dialogs.dart';
import 'package:prontoapp/data/services/auth_service.dart';

/// Pantalla de registro rediseñada según Figma node 237:258.
/// Estructura: Header inline + barra de progreso + formulario por pasos.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // --- Controladores de texto ---
  final TextEditingController _nombreNegocioController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  bool _contrasenaVisible = false;
  bool _botonPresionado = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreNegocioController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // ── Barra de estado (espaciado superior) ──────────────────────
            const SizedBox(height: 4),

            // ── Contenido scrolleable ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.08, vertical: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header inline: flecha + título ─────────────────
                    _buildHeaderRow(context),

                    const SizedBox(height: 4),

                    // ── Subtítulo ───────────────────────────────────────
                    Text(
                      'Configura tu negocio en menos de 2 minutos',
                      style: GoogleFonts.inter(
                        fontSize: 14.12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),

                    const SizedBox(height: 26.08),

                    // ── Barra de progreso (3 pasos) ─────────────────────
                    _buildBarraProgreso(),

                    const SizedBox(height: 30.42),

                    // ── Etiqueta de paso ────────────────────────────────
                    _buildEtiquetaPaso(),

                    const SizedBox(height: 21.73),

                    // ── Sección de formulario ───────────────────────────
                    _buildFormulario(),

                    const SizedBox(height: 13.04),

                    // ── Texto de términos y condiciones ─────────────────
                    _buildTerminos(),

                    const SizedBox(height: 21.73),

                    // ── Enlace de inicio de sesión ──────────────────────
                    _buildEnlaceLogin(context),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  // Widgets internos
  // ══════════════════════════════════════════════════════════════════

  /// Fila superior: botón atrás + título "Crear cuenta"
  Widget _buildHeaderRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17.38, bottom: 21.73),
      child: Row(
        children: [
          // Botón atrás estilo Figma: fondo gris claro, ícono oscuro
          GestureDetector(
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
          const SizedBox(width: 10.87),
          // Título
          Text(
            'Crear cuenta',
            style: GoogleFonts.inter(
              fontSize: 23.9,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.33,
            ),
          ),
        ],
      ),
    );
  }

  /// Tres segmentos de progreso: verde activo, verde-oscuro activo, gris inactivo
  Widget _buildBarraProgreso() {
    return Row(
      children: [
        _segmentoPaso(const Color(0xFF25D366)),
        const SizedBox(width: 8.69),
        _segmentoPaso(const Color(0xFF128C7E)),
        const SizedBox(width: 8.69),
        _segmentoPaso(const Color(0xFFE2E8F0)),
      ],
    );
  }

  Widget _segmentoPaso(Color color) {
    return Expanded(
      child: Container(
        height: 4.35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1085.41),
        ),
      ),
    );
  }

  /// Texto "Paso 2 de 3 — Información del negocio"
  Widget _buildEtiquetaPaso() {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.inter(
          fontSize: 11.95,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF64748B),
        ),
        children: [
          const TextSpan(text: 'Paso 2 de 3 — '),
          TextSpan(
            text: 'Información del negocio',
            style: GoogleFonts.inter(
              fontSize: 11.95,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  /// Todos los campos del formulario + botón "Continuar"
  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Nombre del negocio
        _buildCampoLabel('Nombre del negocio'),
        const SizedBox(height: 6.52),
        _buildInputConIcono(
          controlador: _nombreNegocioController,
          hintText: 'Ej: Panadería El Buen Pan',
          icono: FontAwesomeIcons.store,
          iconoColor: const Color(0xFF94A3B8),
          validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
        ),

        const SizedBox(height: 17.38),

        // Nombre y Apellido en dos columnas
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampoLabel('Nombre'),
                  const SizedBox(height: 6.52),
                  _buildInputConIcono(
                    controlador: _nombreController,
                    hintText: 'Carlos',
                    icono: FontAwesomeIcons.user,
                    iconoColor: const Color(0xFF94A3B8),
                    validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 13.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCampoLabel('Apellido'),
                  const SizedBox(height: 6.52),
                  _buildInputConIcono(
                    controlador: _apellidoController,
                    hintText: 'Mendoza',
                    icono: FontAwesomeIcons.user,
                    iconoColor: const Color(0xFF94A3B8),
                    validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 17.38),

        // Teléfono WhatsApp Business
        _buildCampoLabel('Teléfono WhatsApp Business'),
        const SizedBox(height: 6.52),
        _buildInputConIcono(
          controlador: _telefonoController,
          hintText: '+57 300 000 0000',
          icono: FontAwesomeIcons.whatsapp,
          iconoColor: const Color(0xFF25D366),
          tipoTeclado: TextInputType.phone,
          validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
        ),

        const SizedBox(height: 17.38),

        // Correo electrónico
        _buildCampoLabel('Correo electrónico'),
        const SizedBox(height: 6.52),
        _buildInputConIcono(
          controlador: _correoController,
          hintText: 'tu@correo.com',
          icono: FontAwesomeIcons.envelope,
          iconoColor: const Color(0xFF94A3B8),
          tipoTeclado: TextInputType.emailAddress,
          validator: (val) {
            if (val == null || val.isEmpty) return 'Requerido';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) return 'Correo inválido';
            return null;
          },
        ),

        const SizedBox(height: 17.38),

        // Contraseña
        _buildCampoLabel('Contraseña'),
        const SizedBox(height: 6.52),
        _buildInputContrasena(),

        const SizedBox(height: 17.38),

        // Botón "Continuar →"
        _buildBotonContinuar(),
      ],
    ),
    );
  }

  /// Etiqueta de campo con estilo semibold
  Widget _buildCampoLabel(String texto) {
    return Text(
      texto,
      style: GoogleFonts.inter(
        fontSize: 14.12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildInputConIcono({
    required TextEditingController controlador,
    required String hintText,
    required FaIconData icono,
    required Color iconoColor,
    TextInputType tipoTeclado = TextInputType.text,
    Color fillColor = const Color(0xFFF8FAFC), // diseño: inputs #f8fafc (sólo contraseña en blanco)
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controlador,
      keyboardType: tipoTeclado,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 16.3,
        color: const Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.3,
          color: const Color(0xFF757575),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15.21, right: 12),
          child: FaIcon(icono, color: iconoColor, size: 17.38),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.47, vertical: 17.93),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.04),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.09),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.04),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.09),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13.04),
          borderSide: const BorderSide(color: Color(0xFF25D366), width: 1.5),
        ),
      ),
    );
  }

  /// Campo de contraseña con ícono de candado y botón de visibilidad
  Widget _buildInputContrasena() {
    return TextFormField(
      controller: _contrasenaController,
      obscureText: !_contrasenaVisible,
      validator: (val) {
        if (val == null || val.isEmpty) return 'Requerido';
        if (val.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
      style: GoogleFonts.inter(
        fontSize: 16.3,
        color: const Color(0xFF1E293B),
      ),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: GoogleFonts.inter(
          fontSize: 16.3,
          color: const Color(0xFF757575),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15.21, right: 12),
          child: FaIcon(
            FontAwesomeIcons.lock,
            color: const Color(0xFF94A3B8),
            size: 17.38,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: IconButton(
          icon: FaIcon(
            _contrasenaVisible
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
            color: const Color(0xFF94A3B8),
            size: 17.38,
          ),
          onPressed: () {
            setState(() {
              _contrasenaVisible = !_contrasenaVisible;
            });
          },
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18.47, vertical: 17.93),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.09),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.09),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF25D366), width: 1.5),
        ),
      ),
    );
  }

  /// Botón principal "Continuar →" con gradiente verde
  Widget _buildBotonContinuar() {
    return Container(
      height: 56.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(17.38),
        gradient: const LinearGradient(
          colors: [Color(0xFF25D366), Color(0xFF128C7E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withAlpha((0.35 * 255).toInt()),
            blurRadius: 7.61,
            offset: const Offset(0, 4.35),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : () async {
          if (!_formKey.currentState!.validate()) return;
          setState(() => _isLoading = true);
          
          final success = await AuthService().register(
            name: _nombreController.text.trim(),
            lastName: _apellidoController.text.trim(),
            businessName: _nombreNegocioController.text.trim(),
            email: _correoController.text.trim(),
            password: _contrasenaController.text,
          );

          setState(() => _isLoading = false);

          if (!mounted) return;

          if (success) {
            // Ir al dialog de confirmación y luego al Dashboard
            AuthPopupDialogs.showConfirmCodeDialog(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('El correo ya está en uso.')),
            );
          }
        },
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
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continuar',
                  style: GoogleFonts.inter(
                    fontSize: 17.38,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8.69),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
      ),
    );
  }

  /// Texto de términos con links verdes subrayados
  Widget _buildTerminos() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.inter(
            fontSize: 11.95,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
          ),
          children: [
            const TextSpan(text: 'Al continuar aceptas nuestros '),
            TextSpan(
              text: 'Términos de servicio',
              style: GoogleFonts.inter(
                fontSize: 11.95,
                color: const Color(0xFF1DB954),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF1DB954),
              ),
            ),
            const TextSpan(text: ' y '),
            TextSpan(
              text: 'Política de privacidad',
              style: GoogleFonts.inter(
                fontSize: 11.95,
                color: const Color(0xFF1DB954),
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF1DB954),
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  /// Enlace inferior "¿Ya tienes cuenta? Iniciar sesión"
  Widget _buildEnlaceLogin(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        },
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14.12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
            children: [
              const TextSpan(text: '¿Ya tienes cuenta? '),
              TextSpan(
                text: 'Iniciar sesión',
                style: GoogleFonts.inter(
                  fontSize: 14.12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1DB954),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Registro', group: 'Auth', wrapper: previewWrapper, theme: previewTheme, size: kPreviewPhone)
Widget registerScreenPreview() => const RegisterScreen();
