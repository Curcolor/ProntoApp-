import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

void main() {
  runApp(const ProntoApp());
}

class ProntoApp extends StatelessWidget {
  const ProntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProntoApp!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const AuthWrapper(),
    );
  }
}

/// Este widget decide qué pantalla mostrar basado en el estado de autenticación
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  // TODO: Cambiar esto para que lea el estado real de Firebase o SecureStorage
  // Por defecto está en 'false' indicando que es un usuario nuevo o sin sesión
  bool isUserLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    if (isUserLoggedIn) {
      // Pantalla principal de la app para usuarios logueados
      return const DashboardPage();
    } else {
      // Pantalla inicial (Landing Page) para usuarios nuevos/deslogueados
      return const LandingPage();
    }
  }
}

// ------ Placeholder de Dashboard (Hasta que lo diseñemos) -----
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio - ProntoApp')),
      body: Center(
        child: Text(
          'Bienvenido de nuevo',
          style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
