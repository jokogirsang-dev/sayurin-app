// lib/ui/produk_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/produk.dart';
import '../providers/cart_provider.dart';
import '../providers/produk_provider.dart'; // Import ProdukProvider
import '../widget/custom_app_bar.dart';
import '../widget/custom_buttons.dart';
import 'cart_page.dart';

class ProdukDetailPage extends StatefulWidget {
  final int produkId; // Menggunakan ID, bukan objek utuh
  const ProdukDetailPage({super.key, required this.produkId});

  @override
  State<ProdukDetailPage> createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  // Helper untuk format angka (e.g., 1200 -> 1.2K)
  String _formatCompact(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      double n = number / 1000.0;
      return '${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1)}K';
    } else {
      double n = number / 1000000.0;
      return '${n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1)}M';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    // Menggunakan listen: true agar UI bereaksi saat data produk berubah/tersedia
    final produkProvider = Provider.of<ProdukProvider>(context);

    // Mencari produk di dalam provider menggunakan ID yang diterima
    Produk? produk;
    try {
      // firstWhere akan error jika tidak ada, jadi kita pakai try-catch
      produk = produkProvider.listProduk.firstWhere((p) => p.id == widget.produkId);
    } catch (e) {
      // Jika produk tidak ditemukan (misalnya setelah refresh), produk akan null
      produk = null;
    }

    // Jika produk tidak ada, tampilkan halaman error yang informatif
    if (produk == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Error', showBackButton: true),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 20),
              const Text(
                'Produk Tidak Ditemukan',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Produk mungkin sedang tidak tersedia atau telah dihapus. Silakan coba lagi nanti.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                onPressed: () {
                  // Memicu refresh data pada provider
                  Provider.of<ProdukProvider>(context, listen: false).fetchProduk();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, 
                  backgroundColor: const Color(0xFF2E7D32),
                ),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar yang bisa collapse dengan gambar produk
          _buildSliverAppBar(produk),

          // Konten lainnya di bawah app bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductHeader(produk),
                  const SizedBox(height: 20),
                  _buildRatingSection(produk),
                  const SizedBox(height: 24),
                  _buildDescriptionSection(produk),
                  const SizedBox(height: 24),
                  _buildQuantitySelector(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
      // Bottom bar untuk tombol aksi
      bottomNavigationBar: _buildBottomActionBar(produk, cart),
    );
  }

  SliverAppBar _buildSliverAppBar(Produk produk) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 1,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.8),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF333333)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.8),
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded, color: Color(0xFFFF6F00)),
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ditambahkan ke favorit'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
              },
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: produk.gambar.isNotEmpty
            ? Image.network(
                produk.gambar,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildErrorImage(),
              )
            : _buildErrorImage(),
      ),
    );
  }
  
  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[200],
      alignment: Alignment.center,
      child: const Icon(
        Icons.shopping_basket_rounded,
        size: 64,
        color: Color(0xFFCCCCCC),
      ),
    );
  }
  
  Widget _buildProductHeader(Produk produk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          produk.nama,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6F00),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                produk.kategori.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Rp${produk.harga.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
                (match) => '${match.group(1)}.',
              )}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection(Produk produk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildRatingItem(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: produk.rating.toStringAsFixed(1), // Data dari model
            color: const Color(0xFFFFB400),
          ),
          Container(width: 1, height: 50, color: Colors.grey[300]),
          _buildRatingItem(
            icon: Icons.shopping_bag_rounded,
            label: 'Terjual',
            value: _formatCompact(produk.terjual), // Data dari model
            color: const Color(0xFF2E7D32),
          ),
          Container(width: 1, height: 50, color: Colors.grey[300]),
          _buildRatingItem(
            icon: Icons.visibility_rounded,
            label: 'Dilihat',
            value: _formatCompact(produk.dilihat), // Data dari model
            color: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF999999))),
      ],
    );
  }

  Widget _buildDescriptionSection(Produk produk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Deskripsi Produk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Text(
            // Menggunakan deskripsi dari model
            produk.deskripsi.isNotEmpty ? produk.deskripsi : 'Produk segar pilihan dari petani lokal berkualitas premium. Dipanen setiap hari untuk menjaga kesegarannya.',
            style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF666666)),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Jumlah', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
          Container(
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.remove), iconSize: 20, onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null),
                Text(_quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF333333))),
                IconButton(icon: const Icon(Icons.add), iconSize: 20, onPressed: () => setState(() => _quantity++)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(Produk produk, CartProvider cart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: PrimaryButton(
        text: 'Tambah ke Keranjang',
        onPressed: () => _addToCart(produk, cart),
        isLoading: _isAddingToCart,
        height: 56,
        icon: Icons.shopping_cart_checkout_rounded,
      ),
    );
  }

  void _addToCart(Produk produk, CartProvider cart) async {
    setState(() => _isAddingToCart = true);
    await Future.delayed(const Duration(milliseconds: 300));

    // Logika penambahan ke keranjang sudah benar
    for (int i = 0; i < _quantity; i++) {
      cart.tambah(produk);
    }

    if (!mounted) return;
    setState(() => _isAddingToCart = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity "${produk.nama}" ditambahkan ke keranjang'),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: SnackBarAction(label: 'LIHAT', textColor: Colors.white, onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
        }),
      ),
    );

    setState(() => _quantity = 1);
  }
}
