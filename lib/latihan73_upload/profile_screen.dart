import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../core/api_exception.dart';
import 'upload_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _maksByte = 2 * 1024 * 1024;
  final _picker = ImagePicker();
  final _service = UploadService();
  String? _fotoUrl;
  XFile? _preview;
  Uint8List? _previewBytes;
  double? _progress;

  void _snack(String pesan, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        backgroundColor: error ? Colors.red : null,
      ),
    );
  }

  Future<void> _pickImage() async {
    final sumber = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (sumber == null) return;
    final dipilih = await _picker.pickImage(source: sumber);
    if (dipilih == null) return;

    final ukuran = await dipilih.length();
    if (!mounted) return;
    if (ukuran > _maksByte) {
      final mb = (ukuran / (1024 * 1024)).toStringAsFixed(1);
      _snack('Ukuran foto $mb MB, maksimal 2 MB', error: true);
      return;
    }
    final bytes = await dipilih.readAsBytes();
    if (!mounted) return;
    setState(() {
      _preview = dipilih;
      _previewBytes = bytes;
    });
  }

  Future<void> _uploadImage(XFile imageFile) async {
    setState(() => _progress = 0);
    try {
      final url = await _service.uploadFoto(
        imageFile,
        onProgress: (progress) {
          if (mounted) setState(() => _progress = progress);
        },
      );
      if (!mounted) return;
      setState(() {
        _fotoUrl = url;
        _preview = null;
        _previewBytes = null;
      });
      _snack('Foto profil berhasil diperbarui');
    } on ApiException catch (error) {
      if (mounted) _snack(error.message, error: true);
    } finally {
      if (mounted) setState(() => _progress = null);
    }
  }

  Widget _avatar() {
    const diameter = 120.0;
    if (_previewBytes != null) {
      return ClipOval(
        child: Image.memory(
          _previewBytes!,
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
        ),
      );
    }
    return CircleAvatar(
      radius: diameter / 2,
      backgroundImage: _fotoUrl != null ? NetworkImage(_fotoUrl!) : null,
      child: _fotoUrl == null ? const Icon(Icons.person, size: 56) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _progress;
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan 7.3 · Upload Foto')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(child: _avatar()),
          const SizedBox(height: 16),
          const Text(
            'Mahasiswa Flutter',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text('mahasiswa@contoh.ac.id', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          if (progress != null) ...[
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            Text(
              'Mengunggah ${(progress * 100).toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
            ),
          ] else if (_preview != null)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() {
                      _preview = null;
                      _previewBytes = null;
                    }),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => _uploadImage(_preview!),
                    child: const Text('Simpan'),
                  ),
                ),
              ],
            )
          else
            FilledButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Ganti Foto'),
            ),
        ],
      ),
    );
  }
}
