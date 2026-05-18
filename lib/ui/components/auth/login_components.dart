import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/core/widgets/custom_text_field.dart';

class LoginBackButton extends StatefulWidget {
  final VoidCallback? onBack;

  const LoginBackButton({super.key, this.onBack});

  @override
  State<LoginBackButton> createState() => _LoginBackButtonState();
}

class _LoginBackButtonState extends State<LoginBackButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
      child: Semantics(
        label: 'Volver',
        button: true,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) {
            setState(() => _pressed = false);
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.of(context).maybePop();
            }
          },
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.88 : 1,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: Container(
              width: 43.46,
              height: 43.46,
              decoration: BoxDecoration(
                color: _pressed ? AppColors.toggleInactiveBg : AppColors.borderLight,
                borderRadius: BorderRadius.circular(13.04),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginHeroHeader extends StatelessWidget {
  const LoginHeroHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21.7),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha((0.35 * 255).toInt()),
                blurRadius: 26,
                offset: const Offset(0, 8.7),
              ),
            ],
          ),
          child: const Center(
            child: FaIcon(
              FontAwesomeIcons.whatsapp,
              color: AppColors.surface,
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
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Bienvenido de vuelta',
          style: GoogleFonts.inter(
            fontSize: 19.55,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Inicia sesión para gestionar tus pedidos',
          style: GoogleFonts.inter(
            fontSize: 14.12,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class LoginAuthForm extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isLoading;
  final VoidCallback? onSubmit;
  final VoidCallback? onForgotPassword;
  final FormFieldValidator<String>? emailValidator;
  final FormFieldValidator<String>? passwordValidator;

  const LoginAuthForm({
    super.key,
    this.formKey,
    this.emailController,
    this.passwordController,
    this.isLoading = false,
    this.onSubmit,
    this.onForgotPassword,
    this.emailValidator,
    this.passwordValidator,
  });

  @override
  State<LoginAuthForm> createState() => _LoginAuthFormState();
}

class _LoginAuthFormState extends State<LoginAuthForm> {
  final _fallbackFormKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool get _ownsEmailController => widget.emailController == null;
  bool get _ownsPasswordController => widget.passwordController == null;

  @override
  void initState() {
    super.initState();
    _emailController = widget.emailController ?? TextEditingController();
    _passwordController = widget.passwordController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (_ownsEmailController) _emailController.dispose();
    if (_ownsPasswordController) _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey ?? _fallbackFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            label: 'Correo electrónico',
            textField: true,
            child: CustomTextField(
              controller: _emailController,
              label: 'Correo electrónico',
              hintText: 'gerente@prontoa.com',
              keyboardType: TextInputType.emailAddress,
              validator: widget.emailValidator,
            ),
          ),
          const SizedBox(height: 16),
          Semantics(
            label: 'Contraseña',
            textField: true,
            child: CustomTextField(
              controller: _passwordController,
              label: 'Contraseña',
              hintText: '••••••••',
              isPassword: true,
              validator: widget.passwordValidator,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Semantics(
              label: 'Recuperar contraseña',
              button: true,
              child: TextButton(
                onPressed: widget.onForgotPassword,
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
                    color: AppColors.successIcon,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            height: 52.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17.38),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha((0.35 * 255).toInt()),
                  blurRadius: 15.2,
                  offset: const Offset(0, 4.3),
                ),
              ],
            ),
            child: Semantics(
              label: 'Iniciar sesión',
              button: true,
              child: ElevatedButton(
                onPressed: widget.isLoading ? null : widget.onSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17.38),
                  ),
                ),
                child: widget.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.surface,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Iniciar Sesión',
                        style: GoogleFonts.inter(
                          fontSize: 17.38,
                          fontWeight: FontWeight.w600,
                          color: AppColors.surface,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginSocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;

  const LoginSocialButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.border)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'O continúa con',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: Semantics(
                  label: 'Continuar con Google',
                  button: true,
                  child: OutlinedButton.icon(
                    onPressed: onGooglePressed,
                    icon: SizedBox(
                      width: 18,
                      height: 18,
                      child: SvgPicture.asset('assets/icons/google-color.svg'),
                    ),
                    label: Text(
                      'Google',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border, width: 1.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.04),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52,
                child: Semantics(
                  label: 'Continuar con Facebook',
                  button: true,
                  child: OutlinedButton.icon(
                    onPressed: onFacebookPressed,
                    icon: const FaIcon(
                      FontAwesomeIcons.facebook,
                      color: AppColors.infoText,
                      size: 18,
                    ),
                    label: Text(
                      'Facebook',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border, width: 1.08),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13.04),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LoginRegisterLink extends StatelessWidget {
  final VoidCallback? onRegisterPressed;

  const LoginRegisterLink({super.key, this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: 'Crear cuenta gratis',
        button: true,
        child: TextButton(
          onPressed: onRegisterPressed,
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14.12,
                color: AppColors.textTertiary,
              ),
              children: const [
                TextSpan(text: '¿No tienes cuenta? '),
                TextSpan(
                  text: 'Crear cuenta gratis',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.successIcon,
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
