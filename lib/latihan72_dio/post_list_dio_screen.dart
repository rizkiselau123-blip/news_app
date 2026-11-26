import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/error_view.dart';
import '../widgets/post_card.dart';
import 'post_detail_dio_screen.dart';
import 'post_form_screen.dart';
import 'post_providers.dart';

class PostListDioScreen extends ConsumerWidget {
  const PostListDioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postListProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan 7.2 · Dio + Riverpod')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PostFormScreen()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorView(
          pesan: '$error',
          onRetry: () => ref.invalidate(postListProvider),
        ),
        data: (posts) => RefreshIndicator(
          onRefresh: () async {
            try {
              await ref.refresh(postListProvider.future).then<void>((_) {});
            } catch (_) {
              // Error ditampilkan oleh AsyncValue.
            }
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: posts.length,
            itemBuilder: (context, index) => PostCard(
              post: posts[index],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PostDetailDioScreen(post: posts[index]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
