// widget/product_card.dart
// Kartu Produk – Pertemuan 5–6

import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../ui/produk_detail_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../helpers/format_currency.dart';

class ProductCard extends StatelessWidget {
  final Produk produk;
  const ProductCard({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3.0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProdukDetailPage(produk: produk),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12.0),
                ),
                child: produk.gambar.isNotEmpty
                    ? Image.network(produk.gambar, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/sayurin.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4.0),

                  // Harga: int → double via produk.harga
                  Text(
                    'Rp ${FormatCurrency.toRupiah(produk.harga)}',
                    style: const TextStyle(color: Colors.green),
                  ),
                  const SizedBox(height: 6.0),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart, size: 16.0),
                    label: const Text('Tambah'),
                    onPressed: () {
                      cart.tambah(produk);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Ditambahkan ke keranjang'),
                        ),
                      );
                    },
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
