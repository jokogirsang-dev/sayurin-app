// Pertemuan 13 - About / Tentang aplikasi
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tentang Sayur.in')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sayur.in',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
                'Aplikasi marketplace produk segar untuk mahasiswa dan masyarakat. Dibuat untuk keperluan mata kuliah Mobile Programming 2 (UBSI).'),
            SizedBox(height: 12),
            Text('Versi: 1.0.0'),
            SizedBox(height: 12),
            Text('Tim: Kelompok Sayur.in - Sistem Informasi UBSI'),
          ],
        ),
      ),
    );
  }
}
