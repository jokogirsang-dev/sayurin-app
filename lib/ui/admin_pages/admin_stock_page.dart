import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/produk_provider.dart';
import '../../helpers/format_currency.dart';
import '../../widget/custom_app_bar.dart';

class AdminStockPage extends StatefulWidget {
  const AdminStockPage({super.key});

  @override
  State<AdminStockPage> createState() => _AdminStockPageState();
}

class _AdminStockPageState extends State<AdminStockPage> {
  String _filterCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Manajemen Stok',
        backgroundColor: const Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      body: Consumer2<AdminProvider, ProdukProvider>(
        builder: (context, adminProv, produkProv, _) {
          // Build categories from real product data
          final Map<String, int> categories = {};
          for (var product in produkProv.produkList) {
            categories[product.kategori] =
                (categories[product.kategori] ?? 0) + 1;
          }

          var products = produkProv.produkList;

          if (_filterCategory.isNotEmpty) {
            products =
                products.where((p) => p.kategori == _filterCategory).toList();
          }

          return Column(
            children: [
              // === CATEGORY FILTER ===
              if (categories.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      _buildCategoryButton(
                        label: 'Semua',
                        selected: _filterCategory.isEmpty,
                        onTap: () => setState(() => _filterCategory = ''),
                      ),
                      ...categories.keys.map((category) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: _buildCategoryButton(
                            label: category,
                            selected: _filterCategory == category,
                            onTap: () =>
                                setState(() => _filterCategory = category),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),

              // === STOCK LIST ===
              Expanded(
                child: products.isEmpty
                    ? const Center(child: Text('Tidak ada produk'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final isLowStock = product.stok < 5;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: isLowStock ? Colors.red[50] : null,
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product.nama,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Rp ${FormatCurrency.toRupiah(product.harga)}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isLowStock)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'STOK RENDAH',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // === STOCK CONTROL ===
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Stok Saat Ini',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${product.stok} unit',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: isLowStock
                                                    ? Colors.red
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () => _showStockUpdateDialog(
                                          context,
                                          product,
                                          adminProv,
                                        ),
                                        icon: const Icon(Icons.edit, size: 16),
                                        label: const Text('Update Stok'),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // === QUICK ACTIONS ===
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      _buildQuickButton(
                                        label: '-5',
                                        onTap: () async {
                                          final newStock = (product.stok - 5)
                                              .clamp(0, 10000);
                                          await adminProv.updateStock(
                                            product.id,
                                            newStock,
                                          );
                                        },
                                      ),
                                      _buildQuickButton(
                                        label: '-1',
                                        onTap: () async {
                                          final newStock = (product.stok - 1)
                                              .clamp(0, 10000);
                                          await adminProv.updateStock(
                                            product.id,
                                            newStock,
                                          );
                                        },
                                      ),
                                      _buildQuickButton(
                                        label: '+1',
                                        onTap: () async {
                                          await adminProv.updateStock(
                                            product.id,
                                            product.stok + 1,
                                          );
                                        },
                                      ),
                                      _buildQuickButton(
                                        label: '+5',
                                        onTap: () async {
                                          await adminProv.updateStock(
                                            product.id,
                                            product.stok + 5,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.green : Colors.grey[300],
        foregroundColor: selected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildQuickButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(label),
    );
  }

  void _showStockUpdateDialog(
    BuildContext context,
    dynamic product,
    dynamic adminProv,
  ) {
    final controller = TextEditingController(text: product.stok.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Stok'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stok Baru',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newStock = int.tryParse(controller.text) ?? 0;
                await adminProv.updateStock(product.id, newStock);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Stok ${product.nama} diperbarui menjadi $newStock unit',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
