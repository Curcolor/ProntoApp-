import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/app/routes.dart';
import 'package:prontoapp/data/services/auth_service.dart';
import 'package:prontoapp/data/services/firebase_auth_service.dart';
import 'package:prontoapp/data/services/perfil_usuario_admin_service.dart';
import 'package:prontoapp/data/repositories/inventory_repository.dart';
import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/repositories/order_repository.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

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
  await Firebase.initializeApp();
  await AuthService().initialize();

  final prefs = await SharedPreferences.getInstance();
  final inventoryRepo = InventoryRepository(prefs);
  final orderRepo = OrderRepository(prefs);

  // Data Connect — SDK SQL Connect generado. Reemplaza el legacy backend HTTP
  // con secret X-Secret hardcoded. Usa Firebase ID token automáticamente.
  final dataConnect = FirebaseDataConnect.instanceFor(
    connectorConfig: ProntoappConnector.connectorConfig,
  );
  final connector = ProntoappConnector(dataConnect: dataConnect);

  // F6.3 — providers HTTP legacy (InventoryProvider, OrderProvider) quedan
  // con baseUrl/secreto vacíos: el backend que servía esas rutas será
  // desmontado y reemplazado por servicios nuevos con verify_id_token. Las
  // llamadas activas contra el backend viejo ya están rotas de facto; F6.5
  // migrará providers al SDK Data Connect y eliminará estos shims.
  const String legacyBaseUrlVacio = '';
  const String legacySecretoVacio = '';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthService()),
        ChangeNotifierProvider(create: (_) => FirebaseAuthService()),
        ChangeNotifierProvider(
          create: (_) => PerfilUsuarioAdminService(connector),
        ),
        Provider<ProntoappConnector>.value(value: connector),
        ChangeNotifierProvider(
          create: (_) => InventoryProvider(
            inventoryRepo,
            baseUrl: legacyBaseUrlVacio,
            secreto: legacySecretoVacio,
          ),
        ),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProxyProvider<NotificationProvider, OrderProvider>(
          create: (_) => OrderProvider(
            repositorio: orderRepo,
            baseUrl: legacyBaseUrlVacio,
            secreto: legacySecretoVacio,
          ),
          update: (_, notifProvider, orderProvider) {
            orderProvider!.onNewNotification = notifProvider.addNotification;
            return orderProvider;
          },
        ),
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
