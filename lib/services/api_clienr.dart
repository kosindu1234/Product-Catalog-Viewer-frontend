import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                // Ip should be change according to the device  http://deviceIp:port
                baseUrl: 'http://192.168.1.4:8080',
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<Response<dynamic>> get(String path) async {
    return _dio.get(path);
  }
}