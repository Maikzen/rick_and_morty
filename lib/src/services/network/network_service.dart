import 'package:dio/dio.dart' as dio;
import 'package:rick_and_morty/src/providers/constants.dart';

///
/// Servicio de Network
///
/// Capa intermedia para configurar las peticiones http mediante el plugin dio.
///

class NetworkService {
  dio.Dio? _httpClient;

  _init() {
    dio.BaseOptions options = dio.BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: 30000,
      receiveTimeout: 35000,
    );
    _httpClient = dio.Dio(options);
    _httpClient!.interceptors.add(dio.LogInterceptor());
  }

  /* Getters and Setters */

  dio.Dio getHttpClient() {
    if (_httpClient == null) {
      _init();
    }
    return _httpClient!;
  }
}
