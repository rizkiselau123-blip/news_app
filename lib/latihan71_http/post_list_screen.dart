import 'package:flutter/material.dart';

import '../models/post.dart';
import '../widgets/error_view.dart';
import '../widgets/post_card.dart';
import 'api_service.dart';
import 'post_detail_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final _api = ApiService();
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _futurePosts = _api.fetchPosts();
  }

  void _muatUlang() {
    setState(() => _futurePosts = _api.fetchPosts());
  }

  Future<void> _onRefresh() async {
    _muatUlang();
    try {
      await _futurePosts;
    } catch (_) {
      // FutureBuilder menampilkan error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan 7.1 · http')),
      body: FutureBuilder<List<Post>>(
        future: _futurePosts,
        builder: (context, snapshot) {
          final loading = snapshot.connectionState == ConnectionState.waiting;
          if (loading && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(pesan: '${snapshot.error}', onRetry: _muatUlang);
          }
          final posts = snapshot.data ?? [];
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  post: post,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailScreen(
                        postId: post.id,
                        userId: post.userId,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
