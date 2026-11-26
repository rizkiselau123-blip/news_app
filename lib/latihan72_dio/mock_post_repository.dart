import '../core/api_exception.dart';
import '../models/post.dart';
import 'post_repository.dart';

class MockPostRepository implements PostRepository {
  final List<Post> _data = List.generate(
    45,
    (index) => Post(
      id: index + 1,
      userId: index % 5 + 1,
      title: 'Post contoh nomor ${index + 1}',
      body: 'Isi post dummy untuk pengembangan offline.',
    ),
  );

  int _nextId = 46;

  Future<void> _jeda() =>
      Future<void>.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<Post>> getPosts({int page = 1, int limit = 20}) async {
    await _jeda();
    return _data.skip((page - 1) * limit).take(limit).toList();
  }

  @override
  Future<Post> getPostById(int id) async {
    await _jeda();
    return _data.firstWhere(
      (post) => post.id == id,
      orElse: () => throw const ApiException('Data tidak ditemukan'),
    );
  }

  @override
  Future<Post> createPost(Post post) async {
    await _jeda();
    final baru = Post(
      id: _nextId++,
      userId: post.userId,
      title: post.title,
      body: post.body,
    );
    _data.insert(0, baru);
    return baru;
  }

  @override
  Future<Post> updatePost(Post post) async {
    await _jeda();
    final index = _data.indexWhere((item) => item.id == post.id);
    if (index == -1) {
      throw const ApiException('Data tidak ditemukan');
    }
    _data[index] = post;
    return post;
  }

  @override
  Future<void> deletePost(int id) async {
    await _jeda();
    _data.removeWhere((post) => post.id == id);
  }
}
