import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();

  dio.options.baseUrl = 'http://localhost:8000/api/';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}
