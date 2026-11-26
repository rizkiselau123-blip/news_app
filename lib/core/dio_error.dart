import 'package:dio/dio.dart';

import 'api_exception.dart';

ApiException mapDioError(DioException error) {
  final code = error.response?.statusCode;
  final message = switch (error.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => 'Koneksi lambat, silakan coba lagi',
    DioExceptionType.connectionError => 'Tidak ada koneksi internet',
    DioExceptionType.cancel => 'Permintaan dibatalkan',
    DioExceptionType.badResponse => switch (code) {
      401 => 'Sesi berakhir, silakan login ulang (401)',
      403 => 'Anda tidak memiliki akses (403)',
      404 => 'Data tidak ditemukan (404)',
      _ when code != null && code >= 500 => 'Server sedang bermasalah ($code)',
      _ => 'Permintaan ditolak server ($code)',
    },
    _ => 'Terjadi kesalahan, silakan coba lagi',
  };
  return ApiException(message);
}
