import 'package:prontoapp/data/services/api_client.dart';
import 'demo_http_client.dart';

/// ApiClient aislado para el demo: usa un http.Client falso → cero red, cero prod.
ApiClient crearDemoApiClient() =>
    ApiClient(baseUrl: '', secreto: '', client: DemoHttpClient());
