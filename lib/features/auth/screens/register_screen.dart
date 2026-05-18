import 'package:flutter/material.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/features/auth/screens/login_screen.dart';
import 'package:prontoapp/features/auth/widgets/auth_popup_dialogs.dart';
import 'package:prontoapp/ui/components/auth/register_components.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nombreNegocioController =
      TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _contrasenaVisible = false;
  bool _botonPresionado = false;
  bool _isLoading = false;

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
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RegisterIntroSection(
                      backPressed: _botonPresionado,
                      onBackPressedChanged: (value) =>
                          setState(() => _botonPresionado = value),
                      onBack: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 21.73),
                    RegisterFormSection(
                      formKey: _formKey,
                      businessNameController: _nombreNegocioController,
                      nameController: _nombreController,
                      lastNameController: _apellidoController,
                      phoneController: _telefonoController,
                      emailController: _correoController,
                      passwordController: _contrasenaController,
                      passwordVisible: _contrasenaVisible,
                      isLoading: _isLoading,
                      onTogglePassword: () => setState(
                        () => _contrasenaVisible = !_contrasenaVisible,
                      ),
                      onSubmit: _submit,
                    ),
                    const SizedBox(height: 13.04),
                    RegisterFooterLinks(
                      onLoginTap: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                    ),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final success = await AuthService().register(
      name: _nombreController.text.trim(),
      lastName: _apellidoController.text.trim(),
      businessName: _nombreNegocioController.text.trim(),
      email: _correoController.text.trim(),
      password: _contrasenaController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      AuthPopupDialogs.showConfirmCodeDialog(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El correo ya está en uso.')),
      );
    }
  }
}
