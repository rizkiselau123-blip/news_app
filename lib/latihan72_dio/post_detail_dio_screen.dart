import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_exception.dart';
import '../models/post.dart';
import 'post_form_screen.dart';
import 'post_providers.dart';

class PostDetailDioScreen extends ConsumerWidget {
  const PostDetailDioScreen({super.key, required this.post});

  final Post post;

  Future<void> _hapus(BuildContext context, WidgetRef ref) async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus post?'),
        content: Text('Post #${post.id} akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(postListProvider.notifier).hapus(post.id);
      if (!context.mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(const SnackBar(content: Text('Post dihapus')));
    } on ApiException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daftar = ref.watch(postListProvider).value ?? [];
    final terbaru =
        daftar.where((item) => item.id == post.id).firstOrNull ?? post;
    final teks = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Post #${terbaru.id}'),
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PostFormScreen(post: terbaru)),
            ),
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _hapus(context, ref),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(terbaru.title, style: teks.headlineSmall),
          const SizedBox(height: 12),
          Text(terbaru.body, style: teks.bodyLarge),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Chip(label: Text('User ${terbaru.userId}')),
          ),
        ],
      ),
    );
  }
}
