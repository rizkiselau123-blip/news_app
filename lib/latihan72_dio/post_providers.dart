import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post.dart';
import 'dio_client.dart';
import 'mock_post_repository.dart';
import 'post_repository.dart';
import 'post_repository_impl.dart';

const pakaiMock = false;

final postRepositoryProvider = Provider<PostRepository>((ref) {
  if (pakaiMock) return MockPostRepository();
  return PostRepositoryImpl(createDio());
});

final postListProvider = AsyncNotifierProvider<PostListNotifier, List<Post>>(
  PostListNotifier.new,
);

class PostListNotifier extends AsyncNotifier<List<Post>> {
  PostRepository get _repo => ref.read(postRepositoryProvider);

  @override
  Future<List<Post>> build() {
    return ref.watch(postRepositoryProvider).getPosts();
  }

  Future<void> tambah(String title, String body) async {
    final baru = await _repo.createPost(
      Post(id: 0, userId: 1, title: title, body: body),
    );
    state = AsyncData([baru, ...?state.value]);
  }

  Future<void> ubah(Post post) async {
    final hasil = await _repo.updatePost(post);
    state = AsyncData([
      for (final item in state.value ?? <Post>[])
        item.id == hasil.id ? hasil : item,
    ]);
  }

  Future<void> hapus(int id) async {
    await _repo.deletePost(id);
    state = AsyncData([
      for (final item in state.value ?? <Post>[])
        if (item.id != id) item,
    ]);
  }
}
