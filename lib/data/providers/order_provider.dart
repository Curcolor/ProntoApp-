import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import 'notification_provider.dart';

/// Provider de pedidos. Fuente de verdad = servidor (vía repo). Poll 5s + cache.
class OrderProvider extends ChangeNotifier {
  final OrderRepository? _repositorio;
  List<OrderModel> _pedidos = [];
  bool _estaConectado = false;
  final bool _cargando = false;
  Timer? _timer;
  void Function(NotificationModel)? onNewNotification;
  static const Duration _intervaloPoll = Duration(seconds: 5);

  OrderProvider({required OrderRepository repositorio}) : _repositorio = repositorio {
    _pedidos = repositorio.readCache();
    _iniciarPolling();
  }

  /// Solo para widget previews: siembra pedidos, sin repo/timer/red.
  OrderProvider.preview({List<OrderModel>? pedidos}) : _repositorio = null {
    _pedidos = pedidos ?? <OrderModel>[];
  }

  // ─── Getters ────────────────────────────────────────────────────────────────
  List<OrderModel> get pedidos => List.unmodifiable(_pedidos);
  bool get estaConectado => _estaConectado;
  bool get cargando => _cargando;
  List<OrderModel> get recibidos => _filtrarPor(EstadoPedido.recibido);
  List<OrderModel> get enPreparacion => _filtrarPor(EstadoPedido.enPreparacion);
  List<OrderModel> get listos => _filtrarPor(EstadoPedido.listo);
  List<OrderModel> get enCamino => _filtrarPor(EstadoPedido.enCamino);
  List<OrderModel> get entregados => _filtrarPor(EstadoPedido.entregado);
  List<OrderModel> get activos => [...recibidos, ...enPreparacion];

  int get pedidosHoy {
    final hoy = DateTime.now();
    return _pedidos.where((p) =>
        p.creadoEn.year == hoy.year && p.creadoEn.month == hoy.month && p.creadoEn.day == hoy.day).length;
  }

  double get ventasHoy {
    final hoy = DateTime.now();
    return _pedidos.where((p) => p.estado == EstadoPedido.entregado &&
        p.creadoEn.year == hoy.year && p.creadoEn.month == hoy.month && p.creadoEn.day == hoy.day)
        .fold(0.0, (s, p) => s + p.total);
  }

  int get pedidosUltimos7Dias {
    final hace7 = DateTime.now().subtract(const Duration(days: 7));
    return _pedidos.where((p) => p.creadoEn.isAfter(hace7)).length;
  }

  double get ventasUltimos7Dias {
    final hace7 = DateTime.now().subtract(const Duration(days: 7));
    return _pedidos.where((p) => p.estado == EstadoPedido.entregado && p.creadoEn.isAfter(hace7))
        .fold(0.0, (s, p) => s + p.total);
  }

  Map<String, int> get pedidosPorDia {
    final resultado = <String, int>{};
    final dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    for (int i = 6; i >= 0; i--) {
      final fecha = DateTime.now().subtract(Duration(days: i));
      final dia = dias[fecha.weekday - 1];
      resultado[dia] = _pedidos.where((p) =>
          p.creadoEn.year == fecha.year && p.creadoEn.month == fecha.month && p.creadoEn.day == fecha.day).length;
    }
    return resultado;
  }

  Map<TipoPedido, double> get ratioTipos {
    if (_pedidos.isEmpty) return {TipoPedido.domicilio: 0, TipoPedido.recoger: 0};
    final total = _pedidos.length.toDouble();
    final domicilio = _pedidos.where((p) => p.tipo == TipoPedido.domicilio).length;
    return {
      TipoPedido.domicilio: (domicilio / total) * 100,
      TipoPedido.recoger: ((total - domicilio) / total) * 100,
    };
  }

  // ─── Polling / sincronización ────────────────────────────────────────────────
  void _iniciarPolling() {
    sincronizar();
    _timer = Timer.periodic(_intervaloPoll, (_) => sincronizar());
  }

  Future<void> sincronizar() async {
    final repo = _repositorio;
    if (repo == null) return;
    try {
      final nuevos = await repo.fetchPedidos();
      if (_pedidos.isNotEmpty) {
        final idsViejos = _pedidos.map((p) => p.id).toSet();
        for (final p in nuevos) {
          if (!idsViejos.contains(p.id) && p.estado == EstadoPedido.recibido) {
            onNewNotification?.call(NotificationModel(
              id: DateTime.now().millisecondsSinceEpoch.toString() + p.id,
              title: 'Nuevo pedido recibido',
              description: '${p.cliente} · \$${p.total}',
              timestamp: DateTime.now(), type: NotificationType.pedido));
          }
        }
      }
      _pedidos = nuevos..sort((a, b) => b.creadoEn.compareTo(a.creadoEn));
      _estaConectado = true;
    } catch (_) {
      if (_estaConectado) {
        _estaConectado = false;
        _pedidos = repo.readCache();
        onNewNotification?.call(NotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'Conexión con el servidor perdida',
          description: 'No se pueden recibir nuevos pedidos.',
          timestamp: DateTime.now(), type: NotificationType.sistema));
      }
    }
    notifyListeners();
  }

  // ─── Acciones ─────────────────────────────────────────────────────────────
  Future<bool> avanzarEstado(String id) async {
    final repo = _repositorio;
    if (repo == null) return false;
    final index = _pedidos.indexWhere((p) => p.id == id);
    if (index == -1) return false;
    final siguiente = _pedidos[index].estado.siguiente;
    if (siguiente == null) return false;
    try {
      await repo.avanzarEstado(id, siguiente.claveApi);
      await sincronizar();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> eliminarPedido(String id) async {
    final repo = _repositorio;
    if (repo == null) return false;
    try {
      await repo.eliminarPedido(id);
      await sincronizar();
      return true;
    } catch (_) {
      return false;
    }
  }

  List<OrderModel> _filtrarPor(EstadoPedido estado) =>
      _pedidos.where((p) => p.estado == estado).toList();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
