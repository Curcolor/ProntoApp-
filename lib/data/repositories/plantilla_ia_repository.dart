import '../models/plantilla_ia_model.dart';
import '../services/api_client.dart';

/// Acceso a la plantilla del agente IA (fila única) vía FastAPI.
class PlantillaIaRepository {
  final ApiClient _api;
  PlantillaIaRepository(this._api);

  Future<PlantillaIa> fetch() async =>
      PlantillaIa.fromJson(await _api.get('/plantilla-ia') as Map<String, dynamic>);

  Future<PlantillaIa> update(Map<String, dynamic> datos) async =>
      PlantillaIa.fromJson(await _api.put('/plantilla-ia', datos) as Map<String, dynamic>);
}
