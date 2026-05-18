import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterIntroSection extends StatelessWidget {
  final bool backPressed;
  final ValueChanged<bool>? onBackPressedChanged;
  final VoidCallback? onBack;

  const RegisterIntroSection({
    super.key,
    required this.backPressed,
    this.onBackPressedChanged,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 17.38, bottom: 21.73),
          child: Row(
            children: [
              GestureDetector(
                onTapDown: (_) => onBackPressedChanged?.call(true),
                onTapUp: (_) {
                  onBackPressedChanged?.call(false);
                  onBack?.call();
                },
                onTapCancel: () => onBackPressedChanged?.call(false),
                child: AnimatedScale(
                  scale: backPressed ? 0.88 : 1.0,
                  duration: const Duration(milliseconds: 120),
                  curve: Curves.easeOut,
                  child: Container(
                    width: 43.46,
                    height: 43.46,
                    decoration: BoxDecoration(
                      color: backPressed
                          ? const Color(0xFFCBD5E1)
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
        ),
        Text(
          'Configura tu negocio en menos de 2 minutos',
          style: GoogleFonts.inter(
            fontSize: 14.12,
            color: const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 26.08),
        Row(
          children: const [
            _ProgressSegment(Color(0xFF25D366)),
            SizedBox(width: 8.69),
            _ProgressSegment(Color(0xFF128C7E)),
            SizedBox(width: 8.69),
            _ProgressSegment(Color(0xFFE2E8F0)),
          ],
        ),
        const SizedBox(height: 30.42),
        RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 11.95,
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
        ),
      ],
    );
  }
}

class RegisterFormSection extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController businessNameController;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final Future<void> Function() onSubmit;

  const RegisterFormSection({
    super.key,
    required this.formKey,
    required this.businessNameController,
    required this.nameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Nombre del negocio'),
          const SizedBox(height: 6.52),
          _RegisterInputField(
            controller: businessNameController,
            hintText: 'Ej: Panadería El Buen Pan',
            icon: FontAwesomeIcons.store,
            iconColor: const Color(0xFF94A3B8),
            validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 17.38),
          Row(
            children: [
              Expanded(
                child: _NamedInput(
                  label: 'Nombre',
                  controller: nameController,
                  hintText: 'Carlos',
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
              ),
              const SizedBox(width: 13.04),
              Expanded(
                child: _NamedInput(
                  label: 'Apellido',
                  controller: lastNameController,
                  hintText: 'Mendoza',
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Requerido' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17.38),
          const _FieldLabel('Teléfono WhatsApp Business'),
          const SizedBox(height: 6.52),
          _RegisterInputField(
            controller: phoneController,
            hintText: '+57 300 000 0000',
            icon: FontAwesomeIcons.whatsapp,
            iconColor: const Color(0xFF25D366),
            keyboardType: TextInputType.phone,
            validator: (val) => val == null || val.isEmpty ? 'Requerido' : null,
          ),
          const SizedBox(height: 17.38),
          const _FieldLabel('Correo electrónico'),
          const SizedBox(height: 6.52),
          _RegisterInputField(
            controller: emailController,
            hintText: 'tu@correo.com',
            icon: FontAwesomeIcons.envelope,
            iconColor: const Color(0xFF94A3B8),
            keyboardType: TextInputType.emailAddress,
            fillColor: const Color(0xFFF8FAFC),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Requerido';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                return 'Correo inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 17.38),
          const _FieldLabel('Contraseña'),
          const SizedBox(height: 6.52),
          _PasswordField(
            controller: passwordController,
            visible: passwordVisible,
            onToggle: onTogglePassword,
          ),
          const SizedBox(height: 17.38),
          _SubmitButton(isLoading: isLoading, onSubmit: onSubmit),
        ],
      ),
    );
  }
}

class RegisterFooterLinks extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const RegisterFooterLinks({super.key, this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 11.95,
                color: const Color(0xFF94A3B8),
              ),
              children: [
                const TextSpan(text: 'Al continuar aceptas nuestros '),
                _linkSpan('Términos de servicio'),
                const TextSpan(text: ' y '),
                _linkSpan('Política de privacidad'),
                const TextSpan(text: '.'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 21.73),
        Center(
          child: TextButton(
            onPressed: onLoginTap,
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 14.12,
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
        ),
      ],
    );
  }
}

class _ProgressSegment extends StatelessWidget {
  final Color color;

  const _ProgressSegment(this.color);

  @override
  Widget build(BuildContext context) {
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
}

class _NamedInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  const _NamedInput({
    required this.label,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 6.52),
        _RegisterInputField(
          controller: controller,
          hintText: hintText,
          icon: FontAwesomeIcons.user,
          iconColor: const Color(0xFF94A3B8),
          validator: validator,
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14.12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF334155),
      ),
    );
  }
}

class _RegisterInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final FaIconData icon;
  final Color iconColor;
  final TextInputType keyboardType;
  final Color fillColor;
  final String? Function(String?)? validator;

  const _RegisterInputField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.iconColor,
    this.keyboardType = TextInputType.text,
    this.fillColor = Colors.white,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 16.3, color: const Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 16.3,
          color: const Color(0xFF757575),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15.21, right: 12),
          child: FaIcon(icon, color: iconColor, size: 17.38),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18.47,
          vertical: 17.93,
        ),
        border: _outline(13.04, const Color(0xFFE2E8F0), 1.09),
        enabledBorder: _outline(13.04, const Color(0xFFE2E8F0), 1.09),
        focusedBorder: _outline(13.04, const Color(0xFF25D366), 1.5),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.controller,
    required this.visible,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: (val) {
        if (val == null || val.isEmpty) return 'Requerido';
        if (val.length < 6) return 'Mínimo 6 caracteres';
        return null;
      },
      style: GoogleFonts.inter(fontSize: 16.3, color: const Color(0xFF1E293B)),
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: GoogleFonts.inter(
          fontSize: 16.3,
          color: const Color(0xFF757575),
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 15.21, right: 12),
          child: FaIcon(
            FontAwesomeIcons.lock,
            color: Color(0xFF94A3B8),
            size: 17.38,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: IconButton(
          icon: FaIcon(
            visible ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
            color: const Color(0xFF94A3B8),
            size: 17.38,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18.47,
          vertical: 17.93,
        ),
        border: _outline(16, const Color(0xFFE2E8F0), 1.09),
        enabledBorder: _outline(16, const Color(0xFFE2E8F0), 1.09),
        focusedBorder: _outline(16, const Color(0xFF25D366), 1.5),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() onSubmit;

  const _SubmitButton({required this.isLoading, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
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
        onPressed: isLoading ? null : onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(17.38),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
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
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
      ),
    );
  }
}

TextSpan _linkSpan(String text) {
  return TextSpan(
    text: text,
    style: GoogleFonts.inter(
      fontSize: 11.95,
      color: const Color(0xFF1DB954),
      decoration: TextDecoration.underline,
      decorationColor: const Color(0xFF1DB954),
    ),
  );
}

OutlineInputBorder _outline(double radius, Color color, double width) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: width),
  );
}
