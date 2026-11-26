import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post, this.onTap});

  final Post post;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text(
          post.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('User ${post.userId}'),
        ),
      ),
    );
  }
}
