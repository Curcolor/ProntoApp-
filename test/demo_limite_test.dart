import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prontoapp/features/demo/data/demo_limite.dart';

void main() {
  test('permite 3 usos y bloquea el 4º', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final limite = DemoLimite(prefs);

    for (var i = 0; i < 3; i++) {
      expect(await limite.puedeUsar(), true);
      await limite.registrarUso();
    }
    expect(await limite.puedeUsar(), false);
    expect(limite.usosRestantes, 0);
  });
}
