import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();

  dio.options.baseUrl = 'http://localhost:8000/V1.0/';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}
