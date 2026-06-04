import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/app/routes.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/repositories/inventory_repository.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/repositories/order_repository.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/repositories/negocio_repository.dart';
import 'package:prontoapp/data/repositories/usuario_repository.dart';
import 'package:prontoapp/data/repositories/plantilla_ia_repository.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:5050');
  const apiSecret = String.fromEnvironment('API_SECRET', defaultValue: '83c58120a0a140ade0282b37ff64731f3fdd3f7dc306be3151ec62e967b43f43');
  final apiClient = ApiClient(
    baseUrl: baseUrl,
    secreto: apiSecret,
    negocioId: () => AuthService().currentUser?.negocioId ?? 'main',
  );
  await AuthService().initialize(apiClient);
  final inventoryRepo = InventoryRepository(apiClient, prefs);
  final orderRepo = OrderRepository(apiClient, prefs);
  final negocioRepo = NegocioRepository(apiClient);
  final usuarioRepo = UsuarioRepository(apiClient);
  final plantillaIaRepo = PlantillaIaRepository(apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider(create: (_) => InventoryProvider(inventoryRepo)),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProxyProvider<NotificationProvider, OrderProvider>(
          create: (_) => OrderProvider(repositorio: orderRepo),
          update: (_, notifProvider, orderProvider) {
            orderProvider!.onNewNotification = notifProvider.addNotification;
            return orderProvider;
          },
        ),
        Provider<NegocioRepository>.value(value: negocioRepo),
        Provider<UsuarioRepository>.value(value: usuarioRepo),
        Provider<PlantillaIaRepository>.value(value: plantillaIaRepo),
      ],
      child: const ProntoApp(),
    ),
  );
}

class ProntoApp extends StatelessWidget {
  const ProntoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, auth, _) {
        return MaterialApp(
          title: 'ProntoApp!',
          debugShowCheckedModeBanner: false,
          scrollBehavior: AppScrollBehavior(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF25D366)),
            useMaterial3: true,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
          ),
          routes: AppRoutes.getRoutes(),
          home: AppRoutes.getInitialScreen(),
        );
      },
    );
  }
}
