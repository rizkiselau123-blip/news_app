import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = 'Bearer token-demo-123';
        handler.next(options);
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: false,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  return dio;
}
