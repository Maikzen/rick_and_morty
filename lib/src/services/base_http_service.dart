import 'http_service.dart';

///
/// Clase Abstracta para proporcionar una url al servicio Http para realizar peticiones al microservicio correspondiente
///

abstract class BaseHttpService extends HttpService {
  String baseUrl;

  BaseHttpService(this.baseUrl);
}
