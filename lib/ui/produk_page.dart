// lib/ui/produk_page.dart

import 'package:flutter/material.dart';
import '../service/produk_service.dart';
import '../model/produk.dart';
import 'produk_detail_page.dart';
import 'cart_page.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../helpers/format_currency.dart';

class ProdukPage extends StatefulWidget {
  final String? initialCategory;
  const ProdukPage({super.key, this.initialCategory});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Produk>> _futureProduk;
  String selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _futureProduk = ProdukService().fetchProduk();
    // If an initial category was passed, normalize it (capitalize first letter)
    if (widget.initialCategory != null &&
        widget.initialCategory!.trim().isNotEmpty) {
      final c = widget.initialCategory!.trim();
      selectedCategory = c.length == 1
          ? c.toUpperCase()
          : (c[0].toUpperCase() + c.substring(1).toLowerCase());
    }
  }

  // Fungsi untuk mendapatkan satuan berdasarkan kategori/nama produk
  String _getSatuan(Produk produk) {
    final nama = produk.nama.toLowerCase();
    final kategori = produk.kategori.toLowerCase();

    // Bumbu dan rempah biasanya per 100g atau per ons
    if (kategori == 'bumbu' ||
        nama.contains('andaliman') ||
        nama.contains('sihala') ||
        nama.contains('bawang batak') ||
        nama.contains('utte mungkur')) {
      return '/ 100g';
    }

    // Sayuran berdaun biasanya per ikat
    if (nama.contains('bayam') ||
        nama.contains('daun') ||
        nama.contains('sawi')) {
      return '/ ikat';
    }

    // Buah dan sayur lainnya per kg
    if (kategori == 'buah' || kategori == 'sayur') {
      return '/ kg';
    }

    // Default per kg
    return '/ kg';
  }

  // Fungsi untuk mendapatkan rating dummy berdasarkan produk
  double _getRating(Produk produk) {
    final nama = produk.nama.toLowerCase();

    // Produk unggulan dapat rating tinggi
    if (nama.contains('andaliman') ||
        nama.contains('jeruk') ||
        nama.contains('tomat')) {
      return 4.8;
    }

    if (nama.contains('cabai') || nama.contains('bawang')) {
      return 4.7;
    }

    // Rating default antara 4.3 - 4.6
    return 4.3 + (produk.id.hashCode % 4) * 0.1;
  }

  // Fungsi untuk cek apakah produk adalah produk lokal unggulan
  bool _isLocalProduct(Produk produk) {
    final nama = produk.nama.toLowerCase();
    return nama.contains('andaliman') ||
        nama.contains('sihala') ||
        nama.contains('rias') ||
        nama.contains('bawang batak') ||
        nama.contains('hosaya') ||
        nama.contains('utte mungkur') ||
        nama.contains('asam jungga') ||
        nama.contains('daun kunyit');
  }

  @override
  Widget build(BuildContext context) {
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_basket_rounded,
                color: Color(0xFF2E7D32),
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'HORTASIMA FRESH',
              style: TextStyle(
                color: Color(0xFF1B5E20),
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B5E20)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            ),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Color(0xFF1B5E20),
                ),
                if (cartProv.totalItems > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F00),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        cartProv.totalItems > 9
                            ? '9+'
                            : cartProv.totalItems.toString(),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // --- Filter Kategori ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('Semua', 'Semua', Icons.apps_rounded),
                  _buildCategoryChip('Sayur', 'Sayur', Icons.eco_rounded),
                  _buildCategoryChip(
                      'Bumbu', 'Bumbu', Icons.local_dining_rounded),
                  _buildCategoryChip('Buah', 'Buah', Icons.apple_rounded),
                ],
              ),
            ),
          ),

          // --- Daftar Produk ---
          Expanded(
            child: FutureBuilder<List<Produk>>(
              future: _futureProduk,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Color(0xFF2E7D32),
                  ));
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Gagal memuat produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${snapshot.error}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                List<Produk> data = snapshot.data ?? [];
                // Filter berdasarkan kategori yang dipilih (case-insensitive)
                final sel = selectedCategory.trim().toLowerCase();
                if (sel != 'semua') {
                  data = data
                      .where((p) => p.kategori.toLowerCase().contains(sel))
                      .toList();
                }

                if (data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak ada produk',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final p = data[index];
                    // Menggunakan provider untuk status favorit
                    final isFavorite = cartProv.isFavorite(p.id);
                    final isLocal = _isLocalProduct(p);
                    final rating = _getRating(p);
                    final satuan = _getSatuan(p);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProdukDetailPage(produkId: p.id),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar Produk dengan Badge dan Wishlist
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: Image.network(
                                    p.gambar,
                                    height: 140,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 140,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: const Color(0xFF2E7D32),
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 140,
                                      color: Colors.grey[300],
                                      child: Icon(
                                        Icons.broken_image_outlined,
                                        color: Colors.grey[500],
                                        size: 48,
                                      ),
                                    ),
                                  ),
                                ),

                                // Badge "Panen Lokal" untuk produk khas
                                if (isLocal)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFFFF6F00),
                                            Color(0xFFFF8F00)
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFFF6F00)
                                                .withOpacity(0.4),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.verified,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'LOKAL',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Tombol Wishlist (Favorit)
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Menggunakan provider untuk mengubah state
                                      cartProv.toggleFavorite(p.id);

                                      // Menampilkan SnackBar tanpa setState
                                      final isNowFavorite =
                                          cartProv.isFavorite(p.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(isNowFavorite
                                              ? '${p.nama} ditambahkan ke favorit'
                                              : '${p.nama} dihapus dari favorit'),
                                          backgroundColor: isNowFavorite
                                              ? const Color(0xFFFF6F00)
                                              : Colors.grey[700],
                                          behavior: SnackBarBehavior.floating,
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.95),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey[600],
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Informasi Produk
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Nama Produk
                                    Text(
                                      p.nama,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1B5E20),
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Rating Bintang
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Color(0xFFFFC107),
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          rating.toStringAsFixed(1),
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '(${50 + (p.id.hashCode % 200)})',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Harga dengan Satuan (FIX: Tidak ada "Rp Rp")
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            FormatCurrency.toRupiah(p.harga),
                                            style: const TextStyle(
                                              color: Color(0xFF2E7D32),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          satuan,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),

                                    // Tombol Tambah ke Keranjang
                                    SizedBox(
                                      width: double.infinity,
                                      height: 32,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cartProv.tambah(p);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  '${p.nama} ditambahkan ke keranjang'),
                                              backgroundColor:
                                                  const Color(0xFF2E7D32),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration:
                                                  const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF2E7D32),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.zero,
                                          elevation: 0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Icon(Icons.add_shopping_cart,
                                                size: 16),
                                            SizedBox(width: 4),
                                            Text(
                                              'Tambah',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String category, IconData icon) {
    final isSelected = selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Icon(
          icon,
          size: 18,
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[600],
        ),
        label: Text(label),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            selectedCategory = selected ? category : 'Semua';
          });
        },
        selectedColor: const Color(0xFF2E7D32).withOpacity(0.15),
        backgroundColor: Colors.grey[100],
        checkmarkColor: const Color(0xFF2E7D32),
        side: BorderSide(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
          width: isSelected ? 1.5 : 1,
        ),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
          fontSize: 13,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
