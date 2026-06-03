import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../services/api_client.dart';

/// Acceso a pedidos: remoto (ApiClient) + cache de solo-lectura.
class OrderRepository {
  final ApiClient _api;
  final SharedPreferences _prefs;
  static const String _claveCache = 'prontoapp_orders_cache';

  OrderRepository(this._api, this._prefs);

  Future<List<OrderModel>> fetchPedidos() async {
    final lista = await _api.get('/pedidos') as List<dynamic>;
    final pedidos = lista.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    await _prefs.setString(_claveCache, jsonEncode(pedidos.map((p) => p.toJson()).toList()));
    return pedidos;
  }

  List<OrderModel> readCache() {
    final jsonStr = _prefs.getString(_claveCache);
    if (jsonStr == null) return [];
    try {
      return (jsonDecode(jsonStr) as List)
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> avanzarEstado(String id, String estado) =>
      _api.patch('/pedidos/$id/estado', {'estado': estado});

  Future<void> eliminarPedido(String id) => _api.delete('/pedidos/$id');
}
