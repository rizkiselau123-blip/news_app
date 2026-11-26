import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/api_exception.dart';
import '../models/post.dart';
import 'post_providers.dart';

class PostFormScreen extends ConsumerStatefulWidget {
  const PostFormScreen({super.key, this.post});

  final Post? post;

  @override
  ConsumerState<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends ConsumerState<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleC = TextEditingController(text: widget.post?.title);
  late final _bodyC = TextEditingController(text: widget.post?.body);
  bool _menyimpan = false;

  bool get _modeEdit => widget.post != null;

  @override
  void dispose() {
    _titleC.dispose();
    _bodyC.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _menyimpan = true);
    final notifier = ref.read(postListProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final title = _titleC.text.trim();
    final body = _bodyC.text.trim();

    try {
      if (_modeEdit) {
        await notifier.ubah(widget.post!.copyWith(title: title, body: body));
      } else {
        await notifier.tambah(title, body);
      }
      if (!mounted) return;
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(_modeEdit ? 'Post diperbarui' : 'Post ditambahkan'),
        ),
      );
    } on ApiException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.message), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _menyimpan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_modeEdit ? 'Edit Post' : 'Post Baru')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleC,
              decoration: const InputDecoration(
                labelText: 'Judul',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().length < 5
                  ? 'Judul minimal 5 karakter'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _bodyC,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Isi wajib diisi'
                  : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _menyimpan ? null : _simpan,
              icon: _menyimpan
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.send),
              label: Text(_modeEdit ? 'Simpan Perubahan' : 'Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
