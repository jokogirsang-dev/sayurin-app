// lib/ui/produk_detail_page.dart
// Pertemuan 6 - Produk Detail Page

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/produk.dart';
import '../providers/cart_provider.dart';

class ProdukDetailPage extends StatelessWidget {
  final Produk produk;
  const ProdukDetailPage({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(produk.name),
        // 🔙 tombol kembali
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🔹 Gambar produk dengan fallback kalau URL error
            produk.image.isNotEmpty
                ? Image.network(
                    produk.image,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 260,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.broken_image,
                        size: 48,
                      ),
                    ),
                  )
                : Image.asset(
                    'assets/images/sayur.png',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${produk.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    produk.description.isNotEmpty
                        ? produk.description
                        : 'Tidak ada deskripsi produk.',
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        cart.tambah(produk);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Berhasil ditambahkan ke keranjang'),
                          ),
                        );
                      },
                      child: const Text('Tambah ke Keranjang'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
