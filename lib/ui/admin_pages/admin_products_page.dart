import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/produk_provider.dart';
import '../../model/produk.dart';
import '../../helpers/format_currency.dart';
import '../../widget/custom_app_bar.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Manajemen Produk',
        backgroundColor: const Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      body: Consumer2<AdminProvider, ProdukProvider>(
        builder: (context, adminProv, produkProv, _) {
          // Use actual data dari ProdukProvider
          final products = _searchQuery.isEmpty
              ? produkProv.produkList
              : produkProv.produkList
                  .where((p) =>
                      p.nama
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()) ||
                      p.kategori
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                  .toList();

          return Column(
            children: [
              // === SEARCH BAR ===
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // === PRODUCTS LIST ===
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text('Tidak ada produk'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return _buildProductCard(context, product, adminProv);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductCard(
      BuildContext context, Produk product, AdminProvider adminProv) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === IMAGE ===
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.gambar,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // === INFO ===
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
                    'Rp ${FormatCurrency.toRupiah(product.harga)}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.kategori,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: product.stok > 0
                              ? Colors.green[100]
                              : Colors.red[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Stok: ${product.stok}',
                          style: TextStyle(
                            fontSize: 11,
                            color: product.stok > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // === ACTION BUTTONS ===
            Column(
              children: [
                IconButton(
                  onPressed: () =>
                      _showEditProductDialog(context, product, adminProv),
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.blue,
                ),
                IconButton(
                  onPressed: () =>
                      _showDeleteConfirmation(context, product, adminProv),
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String nama = '';
    double harga = 0;
    String gambar = '';
    int stok = 0;
    String kategori = 'Sayuran';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Produk Baru'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    onSaved: (v) => nama = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                    onSaved: (v) => harga = double.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Stok wajib diisi' : null,
                    onSaved: (v) => stok = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'URL Gambar'),
                    onSaved: (v) => gambar = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    initialValue: kategori,
                    onSaved: (v) => kategori = v ?? 'Sayuran',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();
                  final adminProv =
                      Provider.of<AdminProvider>(context, listen: false);

                  final success = await adminProv.addProduct(
                    nama: nama,
                    harga: harga,
                    gambar: gambar,
                    stok: stok,
                    kategori: kategori,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Produk "$nama" berhasil ditambahkan'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menambahkan produk'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(
      BuildContext context, Produk product, AdminProvider adminProv) {
    final formKey = GlobalKey<FormState>();
    String nama = product.nama;
    double harga = product.harga;
    String gambar = product.gambar;
    int stok = product.stok;
    String kategori = product.kategori;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Produk'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: nama,
                    decoration: const InputDecoration(labelText: 'Nama Produk'),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    onSaved: (v) => nama = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: harga.toString(),
                    decoration: const InputDecoration(labelText: 'Harga'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                    onSaved: (v) => harga = double.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: stok.toString(),
                    decoration: const InputDecoration(labelText: 'Stok'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Stok wajib diisi' : null,
                    onSaved: (v) => stok = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: gambar,
                    decoration: const InputDecoration(labelText: 'URL Gambar'),
                    onSaved: (v) => gambar = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: kategori,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    onSaved: (v) => kategori = v ?? '',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState?.validate() ?? false) {
                  formKey.currentState?.save();

                  final success = await adminProv.editProduct(
                    id: product.id,
                    nama: nama,
                    harga: harga,
                    gambar: gambar,
                    stok: stok,
                    kategori: kategori,
                  );

                  if (mounted) {
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Produk berhasil diperbarui'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Produk product, AdminProvider adminProv) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Produk'),
          content: Text('Apakah Anda yakin ingin menghapus "${product.nama}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await adminProv.deleteProduct(product.id);
                if (mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk berhasil dihapus'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
