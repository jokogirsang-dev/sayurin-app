// lib/ui/admin_dashboard.dart
// Pertemuan 11 – Admin Dashboard
// Fitur: Melihat daftar produk, menambah & menghapus (simulasi CRUD)

import 'package:flutter/material.dart';
import '../service/produk_service.dart';
import '../model/produk.dart';
import '../helpers/format_currency.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Produk>> _futureProduk;

  @override
  void initState() {
    super.initState();
    _futureProduk = ProdukService().fetchProduk();
  }

  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    String name = '';
    String price = '';
    String image = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                  onSaved: (v) => name = v ?? '',
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                  onSaved: (v) => price = v ?? '',
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'URL Gambar'),
                  onSaved: (v) => image = v ?? '',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('Simpan'),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  // Simulasi: di sini kamu bisa tambahkan ke list lokal / panggil API
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Produk "$name" disimpan (simulasi, belum ke API).'),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<Produk>>(
        future: _futureProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat produk: ${snapshot.error}'),
            );
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('Belum ada produk.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: data.length,
            itemBuilder: (context, i) {
              final p = data[i];
              return Card(
                child: ListTile(
                  leading: Image.network(
                    p.image,
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.broken_image, size: 40),
                  ),
                  title: Text(p.name),
                  subtitle: Text(
                    // kalau FormatCurrency.toRupiah sudah ada "Rp", hapus "Rp " di depan
                    'Rp ${FormatCurrency.toRupiah(p.harga)}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, size: 20.0),
                    onPressed: () {
                      // Simulasi hapus: tampilkan SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${p.name} dihapus dari daftar produk (simulasi).',
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
