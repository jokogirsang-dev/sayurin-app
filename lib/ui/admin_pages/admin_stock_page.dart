import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/produk_provider.dart';
import '../../model/produk.dart';
import '../../helpers/format_currency.dart';
import '../../widget/custom_app_bar.dart';

class AdminStockPage extends StatefulWidget {
  const AdminStockPage({super.key});

  @override
  State<AdminStockPage> createState() => _AdminStockPageState();
}

class _AdminStockPageState extends State<AdminStockPage> {
  late Future<void> _productsFuture;
  String _filterCategory = '';

  @override
  void initState() {
    super.initState();
    // Delay fetch until after first frame to avoid notifyListeners during build
    _productsFuture = Future.value();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _productsFuture = _fetchProducts();
      });
    });
  }

  Future<void> _fetchProducts() {
    // Panggil provider untuk mengambil data produk, listen: false karena hanya untuk aksi
    return Provider.of<ProdukProvider>(context, listen: false).fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: 'Manajemen Stok',
        backgroundColor: Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      // 2. GUNAKAN FutureBuilder UNTUK TANGANI LOADING & ERROR
      body: FutureBuilder(
        future: _productsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal memuat data: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _productsFuture = _fetchProducts();
                    }),
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          } else {
            // Jika sukses, baru tampilkan UI utama
            return _buildStockManagementUI();
          }
        },
      ),
    );
  }

  Widget _buildStockManagementUI() {
    return Consumer<ProdukProvider>(
      builder: (context, produkProv, _) {
        final allProducts = produkProv.listProduk ?? [];

        // Build categories from real product data
        final Map<String, int> categories = {};
        for (var product in allProducts) {
          categories[product.kategori] =
              (categories[product.kategori] ?? 0) + 1;
        }

        var products = _filterCategory.isNotEmpty
            ? allProducts.where((p) => p.kategori == _filterCategory).toList()
            : allProducts;

        // Sort products: low stock first
        products.sort((a, b) {
          if (a.stok < 5 && b.stok >= 5) return -1;
          if (a.stok >= 5 && b.stok < 5) return 1;
          return a.stok.compareTo(b.stok);
        });

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
                      count: allProducts.length,
                      selected: _filterCategory.isEmpty,
                      onTap: () => setState(() => _filterCategory = ''),
                    ),
                    ...categories.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: _buildCategoryButton(
                          label: entry.key,
                          count: entry.value,
                          selected: _filterCategory == entry.key,
                          onTap: () =>
                              setState(() => _filterCategory = entry.key),
                        ),
                      );
                    }),
                  ],
                ),
              ),

            // === STOCK SUMMARY ===
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'Total Produk',
                    products.length.toString(),
                    Icons.inventory_2,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildSummaryItem(
                    'Stok Rendah',
                    products
                        .where((p) => p.stok > 0 && p.stok < 5)
                        .length
                        .toString(),
                    Icons.warning,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  _buildSummaryItem(
                    'Stok Habis',
                    products.where((p) => p.stok == 0).length.toString(),
                    Icons.error,
                  ),
                ],
              ),
            ),

            // === STOCK LIST ===
            Expanded(
              child: products.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _filterCategory.isEmpty
                                ? 'Belum ada produk'
                                : 'Produk di kategori ini kosong',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchProducts,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildStockCard(context, product);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStockCard(BuildContext context, Produk product) {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    final isLowStock = product.stok > 0 && product.stok < 5;
    final isOutOfStock = product.stok == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isOutOfStock
          ? Colors.red.shade50
          : isLowStock
              ? Colors.orange.shade50
              : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isOutOfStock
              ? Colors.red.shade300
              : isLowStock
                  ? Colors.orange.shade300
                  : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        product.kategori,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                if (isOutOfStock)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'HABIS',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                else if (isLowStock)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'RENDAH',
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Stok Saat Ini',
                          style: TextStyle(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        '${product.stok} unit',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isOutOfStock
                              ? Colors.red
                              : isLowStock
                                  ? Colors.orange
                                  : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      _showStockUpdateDialog(context, product, adminProv),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Update Stok'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickButton(
                    label: '-5',
                    onTap: () => _quickUpdateStock(
                        adminProv, product, product.stok - 5)),
                _buildQuickButton(
                    label: '-1',
                    onTap: () => _quickUpdateStock(
                        adminProv, product, product.stok - 1)),
                _buildQuickButton(
                    label: '+1',
                    onTap: () => _quickUpdateStock(
                        adminProv, product, product.stok + 1)),
                _buildQuickButton(
                    label: '+5',
                    onTap: () => _quickUpdateStock(
                        adminProv, product, product.stok + 5)),
                _buildQuickButton(
                    label: '+10',
                    color: Colors.green,
                    onTap: () => _quickUpdateStock(
                        adminProv, product, product.stok + 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to reduce repetition
  Future<void> _quickUpdateStock(
      AdminProvider adminProv, Produk product, int newStockValue) async {
    final newStock = newStockValue.clamp(0, 10000);
    // 3. PERBAIKI ERROR TIPE DATA ID (String -> int)
    await adminProv.updateStock((product.id), newStock);
    if (mounted) {
      _showStockSnackbar(product.nama, newStock);
    }
  }

  Widget _buildCategoryButton({
    required String label,
    required int count,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: selected ? Colors.green : Colors.white,
            foregroundColor: selected ? Colors.white : Colors.black,
            elevation: selected ? 2 : 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(label,
              style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
          const SizedBox(width: 6),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(count.toString(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.green : Colors.white)))
        ]));
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(children: [
      Icon(icon, color: Colors.white, size: 24),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
      Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70))
    ]);
  }

  Widget _buildQuickButton(
      {required String label, required VoidCallback onTap, Color? color}) {
    return OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            side: BorderSide(color: color ?? Colors.grey.shade400),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color)));
  }

  void _showStockSnackbar(String productName, int newStock) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Stok $productName: $newStock unit',
            style: const TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating));
  }

  void _showStockUpdateDialog(
      BuildContext context, Produk product, AdminProvider adminProv) {
    final controller = TextEditingController(text: product.stok.toString());
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Row(children: [
                Icon(Icons.inventory, color: Color(0xFF1565C0)),
                SizedBox(width: 8),
                Text('Update Stok')
              ]),
              content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.nama,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text('Stok saat ini: ${product.stok} unit',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 16),
                    TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: const InputDecoration(
                            labelText: 'Stok Baru',
                            border: OutlineInputBorder(),
                            suffixText: 'unit',
                            prefixIcon: Icon(Icons.edit)))
                  ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Batal')),
                ElevatedButton(
                    onPressed: () async {
                      final newStock =
                          int.tryParse(controller.text) ?? product.stok;
                      if (newStock < 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Stok tidak boleh kurang dari 0'),
                                backgroundColor: Colors.red));
                        return;
                      }
                      // 3. PERBAIKI ERROR TIPE DATA ID (String -> int)
                      await adminProv.updateStock(product.id, newStock);
                      if (context.mounted) {
                        Navigator.pop(context);
                        _showStockSnackbar(product.nama, newStock);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white),
                    child: const Text('Update'))
              ]);
        });
  }
}
