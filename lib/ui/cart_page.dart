// lib/ui/cart_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/produk.dart';
import '../providers/cart_provider.dart';
import '../helpers/format_currency.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Set<String> _selectedItemIds = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cart = Provider.of<CartProvider>(context, listen: false);
      setState(() {
        _selectedItemIds = Set.from(cart.items.map((item) => item.id));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5FAF2),
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              final cart = Provider.of<CartProvider>(context, listen: false);
              // Perbaikan: Gunakan indexWhere untuk menghindari null
              final itemsToRemove = <Produk>[];
              for (final id in _selectedItemIds) {
                final itemIndex = cart.items.indexWhere((p) => p.id == id);
                if (itemIndex != -1) {
                  itemsToRemove.add(cart.items[itemIndex]);
                }
              }
              for (final item in itemsToRemove) {
                cart.hapus(item);
              }
              setState(() {
                _selectedItemIds.clear();
              });
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          final allItems = cart.items;
          final selectedItems = allItems.where((item) => _selectedItemIds.contains(item.id)).toList();

          if (allItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.shopping_cart_outlined,
                      size: 60,
                      color: Colors.green[700],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Keranjangmu Kosong',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ayo belanja sayur dan buah segar di Sayur.in!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Belanja Sekarang'),
                  ),
                ],
              ),
            );
          }

          final totalHarga = cart.getSelectedTotal(_selectedItemIds);

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: allItems.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = allItems[index];
                    bool isSelected = _selectedItemIds.contains(item.id);
                    return _CartItemCard(
                      produk: item,
                      isSelected: isSelected,
                      onSelectedChanged: (bool? value) { // Perbaikan 1: bool? di sini
                        if (value == null) return; // Perbaikan 2: Cek null
                        setState(() {
                          if (value) {
                            _selectedItemIds.add(item.id);
                          } else {
                            _selectedItemIds.remove(item.id);
                          }
                        });
                      },
                      onQuantityChanged: (int newQty) {
                        final provider = Provider.of<CartProvider>(context, listen: false);
                        provider.perbaruiJumlah(item, newQty);
                      },
                      onDelete: () {
                        cart.hapus(item);
                        setState(() {
                          _selectedItemIds.remove(item.id);
                        });
                      },
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _selectedItemIds.length == allItems.length && allItems.isNotEmpty,
                            onChanged: (bool? value) { // Perbaikan 3: bool? di sini
                              if (value == null) return; // Perbaikan 4: Cek null
                              if (value) {
                                setState(() {
                                  _selectedItemIds = Set.from(allItems.map((item) => item.id));
                                });
                              } else {
                                setState(() {
                                  _selectedItemIds.clear();
                                });
                              }
                            },
                          ),
                          const Text('Pilih Semua'),
                          const Spacer(),
                          Text(
                            'Rp ${FormatCurrency.toRupiah(totalHarga)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: selectedItems.isEmpty
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const CheckoutPage(),
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Checkout (${selectedItems.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Perbaikan 5: Tipe parameter onSelectedChanged di sini
class _CartItemCard extends StatelessWidget {
  final Produk produk;
  final bool isSelected;
  final Function(bool?) onSelectedChanged; // <-- Ini sekarang bool?
  final Function(int) onQuantityChanged;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.produk,
    required this.isSelected,
    required this.onSelectedChanged,
    required this.onQuantityChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: isSelected,
              // Perbaikan 6: Fungsi inline untuk menyesuaikan tipe
              onChanged: (bool? value) => onSelectedChanged(value),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(width: 4),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(produk),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${FormatCurrency.toRupiah(produk.harga)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (produk.jumlah > 1) {
                                  onQuantityChanged(produk.jumlah - 1);
                                }
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              constraints: const BoxConstraints(minWidth: 20),
                              child: Text(
                                '${produk.jumlah}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                onQuantityChanged(produk.jumlah + 1);
                              },
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Spacer(),
                      Text(
                        'Subtotal: Rp ${FormatCurrency.toRupiah(produk.harga * produk.jumlah)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Hapus Item',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(Produk p) {
    final String url = p.gambar;
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) =>
            Container(width: 60, height: 60, color: Colors.grey[300], child: const Icon(Icons.error)),
      );
    } else {
      return Image.asset(
        url.isNotEmpty ? url : 'assets/images/sayurin.png',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }
  }
}