import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../core/dio_error.dart';

class UploadService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.escuelajs.co/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<String> uploadFoto(
    XFile file, {
    void Function(double progress)? onProgress,
  }) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        await file.readAsBytes(),
        filename: file.name,
      ),
    });

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/files/upload',
        data: formData,
        onSendProgress: (sent, total) {
          if (total > 0) onProgress?.call(sent / total);
        },
      );
      return response.data!['location'] as String;
    } on DioException catch (error) {
      throw mapDioError(error);
    }
  }
}
