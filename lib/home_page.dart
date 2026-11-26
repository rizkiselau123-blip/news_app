import 'package:flutter/material.dart';

import 'latihan71_http/post_list_screen.dart';
import 'latihan72_dio/post_list_dio_screen.dart';
import 'latihan73_upload/profile_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menu = <(IconData, String, String, Widget)>[
      (
        Icons.http,
        'Latihan 7.1',
        'Daftar post dengan package http',
        const PostListScreen(),
      ),
      (
        Icons.sync_alt,
        'Latihan 7.2',
        'CRUD dengan Dio + Repository',
        const PostListDioScreen(),
      ),
      (
        Icons.account_circle,
        'Latihan 7.3',
        'Upload foto profil (multipart)',
        const ProfileScreen(),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('BAB 7 · REST API')),
      body: ListView(
        children: [
          for (final (ikon, judul, sub, halaman) in menu)
            ListTile(
              leading: Icon(ikon),
              title: Text(judul),
              subtitle: Text(sub),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => halaman),
              ),
            ),
        ],
      ),
    );
  }
}
