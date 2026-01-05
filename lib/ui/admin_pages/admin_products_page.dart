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
  late Future<void> _productsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Memuat data produk saat halaman pertama kali dibuka
    _productsFuture = _fetchProducts();
  }

  Future<void> _fetchProducts() {
    // Memanggil provider untuk mengambil data, listen: false karena hanya butuh aksi
    return Provider.of<ProdukProvider>(context, listen: false).fetchProduk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: 'Manajemen Produk',
        backgroundColor: Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _productsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Tampilkan loading indicator saat data sedang dimuat
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Tampilkan pesan error jika terjadi masalah
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Gagal memuat data: ${snapshot.error}'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _productsFuture = _fetchProducts();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  )
                ],
              ),
            );
          } else {
            // Jika data berhasil dimuat, tampilkan UI utama
            return _buildProductList();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProductDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Produk'),
        backgroundColor: const Color(0xFF1565C0),
      ),
    );
  }

  Widget _buildProductList() {
    return Consumer<ProdukProvider>(
      builder: (context, produkProv, _) {
        final allProducts = produkProv.listProduk ?? [];
        final products = _searchQuery.isEmpty
            ? allProducts
            : allProducts
                .where((p) =>
                    p.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
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
                  hintText: 'Cari produk atau kategori...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1565C0)),
                  ),
                ),
              ),
            ),

            // === PRODUCTS COUNT ===
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    '${products.length} Produk',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // === PRODUCTS LIST ===
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
                            _searchQuery.isEmpty
                                ? 'Belum ada produk'
                                : 'Produk tidak ditemukan',
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          // AdminProvider didapat dari context via Provider.of
                          return _buildProductCard(context, product);
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProductCard(BuildContext context, Produk product) {
    // AdminProvider diambil di sini agar tidak perlu di-pass sebagai argumen
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
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
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.kategori,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: product.stok > 0
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Stok: ${product.stok}',
                          style: TextStyle(
                            fontSize: 11,
                            color: product.stok > 0
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontWeight: FontWeight.w500,
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
                  onPressed: () => _showEditProductDialog(context, product),
                  icon: const Icon(Icons.edit, size: 20),
                  color: Colors.blue,
                  tooltip: 'Edit',
                ),
                IconButton(
                  onPressed: () => _showDeleteConfirmation(context, product),
                  icon: const Icon(Icons.delete, size: 20),
                  color: Colors.red,
                  tooltip: 'Hapus',
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
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    onSaved: (v) => nama = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(),
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                    onSaved: (v) => harga = double.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Stok',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Stok wajib diisi' : null,
                    onSaved: (v) => stok = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(),
                      hintText: 'https://...',
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'URL gambar wajib diisi'
                        : null,
                    onSaved: (v) => gambar = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    initialValue: kategori,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Kategori wajib diisi'
                        : null,
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

                  final success = await adminProv.tambahProduk(
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
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal menambahkan produk'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, Produk product) {
    final formKey = GlobalKey<FormState>();
    String nama = product.nama;
    double harga = product.harga;
    String gambar = product.gambar;
    int stok = product.stok;
    String kategori = product.kategori;
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

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
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    onSaved: (v) => nama = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: harga.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(),
                      prefixText: 'Rp ',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Harga wajib diisi' : null,
                    onSaved: (v) => harga = double.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: stok.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Stok',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Stok wajib diisi' : null,
                    onSaved: (v) => stok = int.tryParse(v ?? '0') ?? 0,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: gambar,
                    decoration: const InputDecoration(
                      labelText: 'URL Gambar',
                      border: OutlineInputBorder(),
                      hintText: 'https://...',
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'URL gambar wajib diisi'
                        : null,
                    onSaved: (v) => gambar = v ?? '',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: kategori,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Kategori wajib diisi'
                        : null,
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

                  final success = await adminProv.editProduk(
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
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Gagal memperbarui produk'),
                          backgroundColor: Colors.red,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Produk product) {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

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
                final success = await adminProv.hapusProduk(product.id);
                if (mounted) {
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Produk "${product.nama}" berhasil dihapus'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gagal menghapus produk'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
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
