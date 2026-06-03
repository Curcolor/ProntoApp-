import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:prontoapp/data/providers/inventory_provider.dart';
import 'package:prontoapp/data/providers/notification_provider.dart';
import 'package:prontoapp/data/providers/order_provider.dart';
import 'package:prontoapp/data/repositories/negocio_repository.dart';
import 'package:prontoapp/data/repositories/usuario_repository.dart';
import 'package:prontoapp/data/services/api_client.dart';
import 'package:prontoapp/data/services/auth_service.dart';

import 'preview_fixtures.dart';

/// ApiClient usado solo por los repos en previews. No hay servidor: las
/// pantallas que lo consumen degradan a estado vacío (no crashean).
final ApiClient _previewApi = ApiClient(baseUrl: 'http://localhost:5050', secreto: '');

/// Envuelve el widget previsualizado con los providers de la app, usando
/// instancias `.preview()` (sin red ni timers). Firma compatible con
/// `WidgetWrapper = Widget Function(Widget)`.
Widget previewWrapper(Widget child) => MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: AuthService.preview()),
        ChangeNotifierProvider<InventoryProvider>.value(
          value: InventoryProvider.preview(
            products: sampleProducts(),
            categories: sampleCategories(),
          ),
        ),
        ChangeNotifierProvider<NotificationProvider>.value(
          value: NotificationProvider.preview(),
        ),
        ChangeNotifierProvider<OrderProvider>.value(
          value: OrderProvider.preview(pedidos: sampleOrders()),
        ),
        Provider<NegocioRepository>.value(value: NegocioRepository(_previewApi)),
        Provider<UsuarioRepository>.value(value: UsuarioRepository(_previewApi)),
      ],
      child: child,
    );
