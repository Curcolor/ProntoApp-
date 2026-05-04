import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/order_model.dart';
import '../repositories/order_repository.dart';
import 'notification_provider.dart';

/// Provider de pedidos: fuente única de verdad para todos los módulos.
///
/// Hace polling al servidor FastAPI cada [_intervaloPoll] segundos
/// y notifica a los listeners cuando cambia la lista de pedidos.
/// Si el servidor no responde, usa el cache local de SharedPreferences.
class OrderProvider extends ChangeNotifier {
  final OrderRepository _repositorio;

  /// URL base del servidor FastAPI.
  final String _baseUrl;

  /// Secreto para autenticar las peticiones al FastAPI.
  final String _secreto;

  // Estado interno
  List<OrderModel> _pedidos = [];
  bool _estaConectado = false;
  bool _cargando = false;
  Timer? _timer;

  /// Callback para inyectar notificaciones sin crear dependencia circular
  void Function(NotificationModel)? onNewNotification;

  static const Duration _intervaloPoll = Duration(seconds: 5);

  OrderProvider({
    required OrderRepository repositorio,
    String baseUrl = 'http://localhost:5050',
    String secreto = '',
  })  : _repositorio = repositorio,
        _baseUrl = baseUrl,
        _secreto = secreto {
    // Cargar cache inmediatamente para que la UI no quede en blanco
    _pedidos = _repositorio.obtenerCache();

    // Iniciar polling al FastAPI
    _iniciarPolling();
  }

  // ─── Getters públicos ──────────────────────────────────────────────────────

  List<OrderModel> get pedidos => List.unmodifiable(_pedidos);
  bool get estaConectado => _estaConectado;
  bool get cargando => _cargando;

  /// Pedidos filtrados por estado.
  List<OrderModel> get recibidos =>
      _filtrarPor(EstadoPedido.recibido);
  List<OrderModel> get enPreparacion =>
      _filtrarPor(EstadoPedido.enPreparacion);
  List<OrderModel> get listos => _filtrarPor(EstadoPedido.listo);
  List<OrderModel> get enCamino => _filtrarPor(EstadoPedido.enCamino);
  List<OrderModel> get entregados => _filtrarPor(EstadoPedido.entregado);

  /// Pedidos activos para el dashboard (recibidos + en preparación).
  List<OrderModel> get activos => [...recibidos, ...enPreparacion];

  // ─── KPIs computados ──────────────────────────────────────────────────────

  /// Total de pedidos creados hoy.
  int get pedidosHoy {
    final hoy = DateTime.now();
    return _pedidos
        .where((p) =>
            p.creadoEn.year == hoy.year &&
            p.creadoEn.month == hoy.month &&
            p.creadoEn.day == hoy.day)
        .length;
  }

  /// Suma de ventas del día (solo pedidos entregados).
  double get ventasHoy {
    final hoy = DateTime.now();
    return _pedidos
        .where((p) =>
            p.estado == EstadoPedido.entregado &&
            p.creadoEn.year == hoy.year &&
            p.creadoEn.month == hoy.month &&
            p.creadoEn.day == hoy.day)
        .fold(0.0, (suma, p) => suma + p.total);
  }

  /// Pedidos de los últimos 7 días.
  int get pedidosUltimos7Dias {
    final hace7 = DateTime.now().subtract(const Duration(days: 7));
    return _pedidos.where((p) => p.creadoEn.isAfter(hace7)).length;
  }

  /// Ventas de los últimos 7 días.
  double get ventasUltimos7Dias {
    final hace7 = DateTime.now().subtract(const Duration(days: 7));
    return _pedidos
        .where((p) =>
            p.estado == EstadoPedido.entregado && p.creadoEn.isAfter(hace7))
        .fold(0.0, (suma, p) => suma + p.total);
  }

  /// Pedidos por día para la gráfica de barras (últimos 7 días).
  /// Devuelve un mapa {nombre_día: cantidad}.
  Map<String, int> get pedidosPorDia {
    final resultado = <String, int>{};
    final dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

    for (int i = 6; i >= 0; i--) {
      final fecha = DateTime.now().subtract(Duration(days: i));
      final dia = dias[fecha.weekday - 1];
      resultado[dia] = _pedidos
          .where((p) =>
              p.creadoEn.year == fecha.year &&
              p.creadoEn.month == fecha.month &&
              p.creadoEn.day == fecha.day)
          .length;
    }

    return resultado;
  }

  /// Ratio de tipos de entrega (domicilio vs recoger).
  Map<TipoPedido, double> get ratioTipos {
    if (_pedidos.isEmpty) return {TipoPedido.domicilio: 0, TipoPedido.recoger: 0};
    final total = _pedidos.length.toDouble();
    final domicilio = _pedidos.where((p) => p.tipo == TipoPedido.domicilio).length;
    return {
      TipoPedido.domicilio: (domicilio / total) * 100,
      TipoPedido.recoger: ((total - domicilio) / total) * 100,
    };
  }

  // ─── Polling ───────────────────────────────────────────────────────────────

  void _iniciarPolling() {
    // Primera carga inmediata
    sincronizar();

    // Polling periódico
    _timer = Timer.periodic(_intervaloPoll, (_) => sincronizar());
  }

  /// Sincroniza los pedidos con el servidor FastAPI.
  /// Llama directamente desde la UI para forzar una actualización.
  Future<void> sincronizar() async {
    try {
      final respuesta = await http
          .get(
            Uri.parse('$_baseUrl/pedidos'),
            headers: _cabeceras(),
          )
          .timeout(const Duration(seconds: 4));

      if (respuesta.statusCode == 200) {
        final lista = jsonDecode(respuesta.body) as List<dynamic>;
        final nuevosPedidos = lista
            .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
            .toList();

        // Detectar nuevos pedidos para notificaciones reales
        if (_pedidos.isNotEmpty) {
          final idsViejos = _pedidos.map((p) => p.id).toSet();
          for (var p in nuevosPedidos) {
            if (!idsViejos.contains(p.id) && p.estado == EstadoPedido.recibido) {
              onNewNotification?.call(
                NotificationModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString() + p.id,
                  title: 'Nuevo pedido recibido',
                  description: '${p.cliente} · \$${p.total}',
                  timestamp: DateTime.now(),
                  type: NotificationType.pedido,
                ),
              );
            }
          }
        }

        _pedidos = nuevosPedidos;

        // Ordenar: más recientes primero
        _pedidos.sort((a, b) => b.creadoEn.compareTo(a.creadoEn));

        // Persistir en cache local
        await _repositorio.guardarCache(_pedidos);

        if (!_estaConectado) {
          _estaConectado = true;
        }
      }
    } catch (_) {
      // Sin conexión: usar cache local
      if (_estaConectado) {
        _estaConectado = false;
        _pedidos = _repositorio.obtenerCache();
        
        onNewNotification?.call(
          NotificationModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: 'Conexión con el servidor perdida',
            description: 'No se pueden recibir nuevos pedidos.',
            timestamp: DateTime.now(),
            type: NotificationType.sistema,
          ),
        );
      }
    }

    notifyListeners();
  }

  // ─── Acciones ──────────────────────────────────────────────────────────────

  /// Avanza el pedido al siguiente estado del ciclo de vida.
  Future<bool> avanzarEstado(String id) async {
    final index = _pedidos.indexWhere((p) => p.id == id);
    if (index == -1) return false;

    final pedido = _pedidos[index];
    final siguiente = pedido.estado.siguiente;
    if (siguiente == null) return false;

    try {
      final respuesta = await http
          .patch(
            Uri.parse('$_baseUrl/pedidos/$id/estado'),
            headers: {..._cabeceras(), 'Content-Type': 'application/json'},
            body: jsonEncode({'estado': siguiente.claveApi}),
          )
          .timeout(const Duration(seconds: 4));

      if (respuesta.statusCode == 200) {
        _pedidos[index] = pedido.copyWith(estado: siguiente);
        await _repositorio.guardarCache(_pedidos);
        notifyListeners();
        return true;
      }
    } catch (_) {
      // Actualización optimista: cambia localmente aunque falle la red
      _pedidos[index] = pedido.copyWith(estado: siguiente);
      await _repositorio.guardarCache(_pedidos);
      notifyListeners();
    }

    return false;
  }

  /// Elimina un pedido de la lista.
  Future<bool> eliminarPedido(String id) async {
    try {
      await http
          .delete(
            Uri.parse('$_baseUrl/pedidos/$id'),
            headers: _cabeceras(),
          )
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // Continuar con eliminación local aunque falle la red
    }

    _pedidos.removeWhere((p) => p.id == id);
    await _repositorio.guardarCache(_pedidos);
    notifyListeners();
    return true;
  }

  // ─── Utilidades ────────────────────────────────────────────────────────────

  List<OrderModel> _filtrarPor(EstadoPedido estado) =>
      _pedidos.where((p) => p.estado == estado).toList();

  Map<String, String> _cabeceras() =>
      _secreto.isNotEmpty ? {'X-Secret': _secreto} : {};

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
