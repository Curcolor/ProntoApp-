import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_model.dart';

/// Repositorio de pedidos: cache local en SharedPreferences.
/// Los pedidos reales vienen del FastAPI; este repositorio los guarda
/// offline para que la app funcione aunque el servidor esté caído.
class OrderRepository {
  final SharedPreferences _prefs;
  static const String _claveCache = 'prontoapp_orders_cache';

  const OrderRepository(this._prefs);

  // ─── Lectura ───────────────────────────────────────────────────────────────

  /// Obtiene los pedidos del cache local.
  List<OrderModel> obtenerCache() {
    final jsonStr = _prefs.getString(_claveCache);
    if (jsonStr == null) return [];

    try {
      final lista = jsonDecode(jsonStr) as List<dynamic>;
      return lista
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ─── Escritura ─────────────────────────────────────────────────────────────

  /// Persiste la lista completa de pedidos en el cache local.
  Future<void> guardarCache(List<OrderModel> pedidos) async {
    final jsonStr = jsonEncode(pedidos.map((p) => p.toJson()).toList());
    await _prefs.setString(_claveCache, jsonStr);
  }

  /// Limpia el cache local.
  Future<void> limpiarCache() async {
    await _prefs.remove(_claveCache);
  }
}
