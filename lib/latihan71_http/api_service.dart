import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/api_exception.dart';
import '../models/post.dart';
import '../models/user.dart';

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://jsonplaceholder.typicode.com';
  final http.Client _client;

  Future<List<Post>> fetchPosts() async {
    final data = await _get('/posts') as List<dynamic>;
    return data
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Post> fetchPostById(int id) async {
    final data = await _get('/posts/$id') as Map<String, dynamic>;
    return Post.fromJson(data);
  }

  Future<User> fetchUserById(int userId) async {
    final data = await _get('/users/$userId') as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<dynamic> _get(String path) async {
    try {
      final response = await _client
          .get(Uri.parse('$_baseUrl$path'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 404) {
        throw const ApiException('Data tidak ditemukan (404)');
      }
      if (response.statusCode != 200) {
        throw ApiException('Server merespons ${response.statusCode}');
      }
      return jsonDecode(response.body);
    } on TimeoutException {
      throw const ApiException('Koneksi lambat, silakan coba lagi');
    } on http.ClientException {
      throw const ApiException('Tidak ada koneksi internet');
    }
  }
}
