import 'dart:convert';
import 'package:http/http.dart' as http;

/// http.Client falso para el demo: nunca toca la red.
/// GET → lista vacía `[]`; cualquier otra cosa → objeto vacío `{}`. Siempre 200.
class DemoHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final cuerpo = request.method == 'GET' ? '[]' : '{}';
    return http.StreamedResponse(
      Stream.value(utf8.encode(cuerpo)),
      200,
      headers: const {'content-type': 'application/json'},
    );
  }
}
