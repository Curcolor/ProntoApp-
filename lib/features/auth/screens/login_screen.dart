import 'package:flutter/material.dart';
import 'package:prontoapp/core/constants/app_colors.dart';
import 'package:prontoapp/data/models/user_model.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/features/auth/screens/recover_password_screen.dart';
import 'package:prontoapp/features/auth/screens/register_screen.dart';
import 'package:prontoapp/features/auth/widgets/auth_popup_dialogs.dart';
import 'package:prontoapp/features/delivery/screens/delivery_main_screen.dart';
import 'package:prontoapp/features/kitchen/screens/kitchen_main_screen.dart';
import 'package:prontoapp/features/manager/screens/manager_main_screen.dart';
import 'package:prontoapp/ui/components/auth/login_components.dart';

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

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final user = await AuthService().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (!mounted) return;

    if (user != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
          switch (user.role) {
            case RoleType.gerente:
              return const ManagerMainScreen();
            case RoleType.cocinero:
              return const KitchenMainScreen();
            case RoleType.repartidor:
              return const DeliveryMainScreen();
          }
        }),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Credenciales incorrectas. (Pista: usa gerente@prontoa.com / password123)',
          ),
          backgroundColor: AppColors.dangerIcon,
        ),
      );
    }
  }

  void _goToRecoverPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RecoverPasswordScreen()),
    );
  }

  void _goToRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingresa tu contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 76,
        leading: LoginBackButton(onBack: () => Navigator.of(context).pop()),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const LoginHeroHeader(),
              const SizedBox(height: 30),
              LoginAuthForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                onSubmit: _handleLogin,
                onForgotPassword: _goToRecoverPassword,
                emailValidator: _validateEmail,
                passwordValidator: _validatePassword,
              ),
              const SizedBox(height: 32),
              LoginSocialButtons(
                onGooglePressed: () =>
                    AuthPopupDialogs.showGoogleOAuthDialog(context),
                onFacebookPressed: () =>
                    AuthPopupDialogs.showFacebookOAuthDialog(context),
              ),
              const SizedBox(height: 48),
              LoginRegisterLink(onRegisterPressed: _goToRegister),
            ],
          ),
        ),
      ),
    );
  }
}
