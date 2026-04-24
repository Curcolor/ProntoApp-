import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'landing_page.dart';

import 'package:prontoapp/services/auth_service.dart';
import 'package:prontoapp/models/user_model.dart';
import 'package:prontoapp/screens/manager/manager_main_screen.dart';
import 'package:prontoapp/screens/kitchen/kitchen_main_screen.dart';
import 'package:prontoapp/screens/delivery/delivery_main_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    if (user != null) {
      switch (user.role) {
        case RoleType.gerente:
          return const ManagerMainScreen();
        case RoleType.cocinero:
          return const KitchenMainScreen();
        case RoleType.repartidor:
          return const DeliveryMainScreen();
      }
    } else {
      // Pantalla inicial (Landing Page)
      return const LandingPage();
    }
  }
}
