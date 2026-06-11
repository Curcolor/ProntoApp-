import 'package:shared_preferences/shared_preferences.dart';

/// Tope de usos del demo por dispositivo (persistido en SharedPreferences).
class DemoLimite {
  static const int maxUsos = 3;
  static const String _clave = 'demo_usos';
  final SharedPreferences _prefs;

  DemoLimite(this._prefs);

  int get _usos => _prefs.getInt(_clave) ?? 0;
  int get usosRestantes => (maxUsos - _usos).clamp(0, maxUsos);

  Future<bool> puedeUsar() async => _usos < maxUsos;

  Future<void> registrarUso() async => _prefs.setInt(_clave, _usos + 1);
}
