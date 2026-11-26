import '../models/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({int page = 1, int limit = 20});
  Future<Post> getPostById(int id);
  Future<Post> createPost(Post post);
  Future<Post> updatePost(Post post);
  Future<void> deletePost(int id);
}
