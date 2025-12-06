import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../model/produk.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Widget _buildProductImage(Produk p) {
    // Kalau image berupa URL
    if (p.image.startsWith('http')) {
      return Image.network(
        p.image,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported),
      );
    }

    // Kalau image berupa asset lokal
    return Image.asset(
      p.image,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang Belanja'),
      ),
      body: cartProv.items.isEmpty
          ? const Center(child: Text('Keranjang masih kosong'))
          : ListView.builder(
              itemCount: cartProv.items.length,
              itemBuilder: (context, index) {
                final p = cartProv.items[index]; // p adalah Produk

                return ListTile(
                  leading: _buildProductImage(p),
                  title: Text(p.name),
                  subtitle: Text('Rp ${p.price.toStringAsFixed(0)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cartProv.remove(p);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cartProv.items.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total: Rp ${cartProv.totalHarga.toStringAsFixed(0)}',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CheckoutPage(),
                        ),
                      );
                    },
                    child: const Text('Lanjut ke Checkout'),
                  ),
                ],
              ),
            ),
    );
  }
}
