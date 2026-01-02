import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_buttons.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);
    final items = cartProv.items;
    final total = cartProv.getTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Keranjang Saya',
        backgroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Colors.green.shade300,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Keranjang kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mulai tambahkan produk favorit Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Lanjut Belanja',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final produk = items[i];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                produk.gambar,
                                width: 88,
                                height: 88,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 88,
                                  height: 88,
                                  color: Colors.green.shade50,
                                  child: Icon(
                                    Icons.eco,
                                    color: Colors.green.shade200,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    produk.nama,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rp ${produk.harga.toStringAsFixed(0)} / ${produk.kategori}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey[100],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                Icons.remove,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                cartProv
                                                    .kurangiJumlah(produk.id);
                                              },
                                              color: Colors.grey[700],
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                            ),
                                            Text(
                                              produk.jumlah.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF212121),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add,
                                                size: 18,
                                              ),
                                              onPressed: () {
                                                cartProv
                                                    .tambahJumlah(produk.id);
                                              },
                                              color: const Color(0xFF2E7D32),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(
                                                minWidth: 36,
                                                minHeight: 36,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Rp ${(produk.harga * produk.jumlah).toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {
                                          cartProv.hapus(produk);
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Color(0xFFD32F2F),
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Harga',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF424242),
                                ),
                              ),
                              Text(
                                'Rp ${total.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: 'Lanjut ke Pembayaran',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        SecondaryButton(
                          text: 'Kosongkan Keranjang',
                          onPressed: () {
                            cartProv.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
