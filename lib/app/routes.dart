import 'package:flutter/material.dart';
import 'package:prontoapp/features/auth/screens/landing_page.dart';
import 'package:prontoapp/features/auth/screens/login_screen.dart';
import 'package:prontoapp/features/auth/screens/register_screen.dart';
import 'package:prontoapp/features/auth/screens/recover_password_screen.dart';
import 'package:prontoapp/features/manager/screens/manager_main_screen.dart';
import 'package:prontoapp/features/kitchen/screens/kitchen_main_screen.dart';
import 'package:prontoapp/features/delivery/screens/delivery_main_screen.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/models/user_model.dart';

class AppRoutes {
  static const String initial = '/';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String register = '/register';
  static const String recoverPassword = '/recover-password';
  static const String managerHome = '/manager/home';
  static const String kitchenHome = '/kitchen/home';
  static const String deliveryHome = '/delivery/home';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      landing: (context) => const LandingPage(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      recoverPassword: (context) => const RecoverPasswordScreen(),
      managerHome: (context) => const ManagerMainScreen(),
      kitchenHome: (context) => const KitchenMainScreen(),
      deliveryHome: (context) => const DeliveryMainScreen(),
    };
  }

  /// Este método decide qué pantalla mostrar al inicio basado en el estado de autenticación
  static Widget getInitialScreen() {
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
    }
    return const LandingPage();
  }
}
