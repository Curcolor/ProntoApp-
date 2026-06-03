import '../models/negocio_model.dart';
import '../services/api_client.dart';

/// Acceso a la configuración del negocio (fila única) vía FastAPI.
class NegocioRepository {
  final ApiClient _api;
  NegocioRepository(this._api);

  Future<Negocio> fetchNegocio() async {
    final data = await _api.get('/negocio');
    if (data == null) return Negocio.empty();
    return Negocio.fromJson(data as Map<String, dynamic>);
  }

  Future<Negocio> updateNegocio(Map<String, dynamic> datos) async =>
      Negocio.fromJson(await _api.put('/negocio', datos) as Map<String, dynamic>);
}
