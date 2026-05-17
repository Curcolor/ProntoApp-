/// Resuelve el perfil de aplicación (`UsuarioAdmin`) tras login Firebase.
///
/// Llama `ObtenerMiPerfilUsuarioAdmin` del SDK Data Connect — el filtro
/// `firebaseUid: { eq_expr: "auth.uid" }` resuelve el usuario por el ID token
/// activo. Devuelve `null` si Firebase Auth está logueado pero aún no existe
/// `UsuarioAdmin` (caso primer login pre-onboarding).
library;

import 'package:prontoapp/generated/prontoapp_dataconnect/prontoapp.dart';

/// Snapshot mínimo del perfil que la UI consume.
class PerfilUsuarioAdmin {
  const PerfilUsuarioAdmin({
    required this.id,
    required this.nombre,
    required this.email,
    required this.cargo,
    required this.negocioId,
    required this.negocioNombre,
    required this.tipoNegocio,
    required this.formatoEntrega,
    required this.zonaHoraria,
    required this.monedaIso,
  });

  final String id;
  final String nombre;
  final String email;
  final EnumValue<RolAdmin> cargo;
  final String negocioId;
  final String negocioNombre;
  final EnumValue<TipoNegocio> tipoNegocio;
  final EnumValue<FormatoEntrega> formatoEntrega;
  final String zonaHoraria;
  final String monedaIso;
}

class PerfilUsuarioAdminService {
  PerfilUsuarioAdminService(this._connector);

  final ProntoappConnector _connector;

  /// Llama la query Data Connect y normaliza a `PerfilUsuarioAdmin`.
  /// Devuelve `null` si el SDK devuelve la lista vacía.
  Future<PerfilUsuarioAdmin?> obtenerMiPerfil() async {
    final result = await _connector.obtenerMiPerfilUsuarioAdmin().execute();
    final data = result.data.usuariosAdmin;
    if (data.isEmpty) {
      return null;
    }
    final row = data.first;
    final negocio = row.negocio;
    return PerfilUsuarioAdmin(
      id: row.id,
      nombre: row.nombre,
      email: row.email,
      cargo: row.cargo,
      negocioId: row.negocioId,
      negocioNombre: negocio.nombre,
      tipoNegocio: negocio.tipoNegocio,
      formatoEntrega: negocio.formatoEntrega,
      zonaHoraria: negocio.zonaHoraria,
      monedaIso: negocio.monedaIso,
    );
  }
}
