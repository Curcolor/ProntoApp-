import 'dart:convert';
import 'package:http/http.dart' as http;

/// Error de una petición HTTP al backend de ProntoApp.
class ApiException implements Exception {
  final int statusCode;
  final String mensaje;
  ApiException(this.statusCode, this.mensaje);
  @override
  String toString() => 'ApiException($statusCode): $mensaje';
}

/// Cliente HTTP central hacia el FastAPI. Único lugar que usa `package:http`.
class ApiClient {
  final String baseUrl;
  final String secreto;
  final http.Client _client;

  ApiClient({required this.baseUrl, required this.secreto, http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> get _headers => {
        if (secreto.isNotEmpty) 'X-Secret': secreto,
        'Content-Type': 'application/json',
      };

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  dynamic _parse(http.Response r, String metodo, String path) {
    if (r.statusCode >= 200 && r.statusCode < 300) {
      if (r.body.isEmpty) return null;
      return jsonDecode(utf8.decode(r.bodyBytes));
    }
    throw ApiException(r.statusCode, '$metodo $path -> ${r.body}');
  }

  Future<dynamic> get(String path) async =>
      _parse(await _client.get(_uri(path), headers: _headers), 'GET', path);

  Future<dynamic> post(String path, Object body) async => _parse(
      await _client.post(_uri(path), headers: _headers, body: jsonEncode(body)), 'POST', path);

  Future<dynamic> patch(String path, Object body) async => _parse(
      await _client.patch(_uri(path), headers: _headers, body: jsonEncode(body)), 'PATCH', path);

  Future<dynamic> put(String path, Object body) async => _parse(
      await _client.put(_uri(path), headers: _headers, body: jsonEncode(body)), 'PUT', path);

  Future<void> delete(String path) async =>
      _parse(await _client.delete(_uri(path), headers: _headers), 'DELETE', path);
}
