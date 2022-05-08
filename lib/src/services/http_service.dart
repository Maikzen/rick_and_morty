import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'network/api_exception.dart';
import 'network/network_service.dart';

///
/// Servicio Http
///
/// Encargado de proporcionar los métodos para realizar los distintos tipos de peticiones http (delete, download, get, post, put)
/// Permite devolver distintos errores en funcion de los códigos devueltos en las peticiones
///

class HttpService {
  Dio? _httpClient;

  Dio getHttpClient() {
    if (_httpClient == null) {
      NetworkService networkService = NetworkService();
      _httpClient = networkService.getHttpClient();
    }
    return _httpClient!;
  }

  Future<dynamic> delete(String path) async {
    dynamic responseJson;
    try {
      final response = await getHttpClient().delete(path);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      //send errors
      if (e.response != null) {
        log(e.response!.realUri.path + ' status code: ' + e.response!.statusCode.toString());
        if (e.response!.statusCode != 401 && e.response!.statusCode != 403) {
        }
      }
      rethrow;
    }
    return responseJson;
  }

  Future<Response<dynamic>> download(String path, String savePath) async {
    return await getHttpClient().download(path, savePath);
  }

  Future<dynamic> get(String path,
      {Map<String, dynamic>? params, Options? options}) async {
    log('HttpService.get: $path');
    dynamic responseJson;
    try {
      final response = await getHttpClient()
          .get(path, queryParameters: params, options: options);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      //send errors
      if (e.response != null) {
        log(e.response!.realUri.path + ' status code: ' + e.response!.statusCode.toString());
        if (e.response!.statusCode != 401 && e.response!.statusCode != 403) {
        }
      }
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> post(String path, {dynamic data}) async {
    dynamic responseJson;
    try {
      final response = await getHttpClient().post(path, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      //send errors
      if (e.response != null) {
        log(e.response!.realUri.path + ' status code: ' + e.response!.statusCode.toString());
        if (e.response!.statusCode != 401 && e.response!.statusCode != 403) {
        }
      }
      rethrow;
    }
    return responseJson;
  }

  Future<dynamic> put(String path, {dynamic data}) async {
    dynamic responseJson;
    try {
      final response = await getHttpClient().put(path, data: data);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } on DioError catch (e) {
      //send errors
      if (e.response != null) {
        log(e.response!.realUri.path + ' status code: ' + e.response!.statusCode.toString());
        if (e.response!.statusCode != 401 && e.response!.statusCode != 403) {
        }
      }
      rethrow;
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        log(response.data.toString());
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.data.toString());
      case 404:
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
