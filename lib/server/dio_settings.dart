import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = Dio();
  // dio.options.baseUrl = 'http://194.233.71.42/~bdhpointdev/english/V1.0/';
  dio.options.baseUrl = 'http://localhost:8000/V1.0/';
  // dio.options.baseUrl = 'http://192.168.137.1/BDH-English-backend/public/V1.0/';
  dio.options.headers['Accept'] = 'application/json';

  return dio;
}
