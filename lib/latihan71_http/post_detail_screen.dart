import 'package:flutter/material.dart';

import '../models/post.dart';
import '../models/user.dart';
import '../widgets/error_view.dart';
import 'api_service.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({
    super.key,
    required this.postId,
    required this.userId,
  });

  final int postId;
  final int userId;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _api = ApiService();
  late Future<(Post, User)> _future;

  @override
  void initState() {
    super.initState();
    _future = _muat();
  }

  Future<(Post, User)> _muat() async {
    final hasil = await Future.wait([
      _api.fetchPostById(widget.postId),
      _api.fetchUserById(widget.userId),
    ]);
    return (hasil[0] as Post, hasil[1] as User);
  }

  @override
  Widget build(BuildContext context) {
    final teks = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text('Detail Post #${widget.postId}')),
      body: FutureBuilder<(Post, User)>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return ErrorView(
              pesan: '${snapshot.error}',
              onRetry: () => setState(() => _future = _muat()),
            );
          }
          final (post, user) = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(post.title, style: teks.headlineSmall),
              const SizedBox(height: 12),
              Text(post.body, style: teks.bodyLarge),
              const Divider(height: 32),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text(user.name),
                subtitle: Text('${user.email}\n${user.company}'),
                isThreeLine: true,
              ),
            ],
          );
        },
      ),
    );
  }
}
