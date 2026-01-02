// lib/ui/produk_detail_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/produk.dart';
import '../providers/cart_provider.dart';
import '../widget/custom_app_bar.dart';
import '../widget/custom_buttons.dart';

class ProdukDetailPage extends StatefulWidget {
  final Produk produk;
  const ProdukDetailPage({super.key, required this.produk});

  @override
  State<ProdukDetailPage> createState() => _ProdukDetailPageState();
}

class _ProdukDetailPageState extends State<ProdukDetailPage> {
  int _quantity = 1;
  bool _isAddingToCart = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: widget.produk.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Product Image
            _buildProductImage(),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name & Price
                  _buildProductHeader(),
                  const SizedBox(height: 20),

                  // Rating & Reviews
                  _buildRatingSection(),
                  const SizedBox(height: 24),

                  // Description
                  _buildDescriptionSection(),
                  const SizedBox(height: 24),

                  // Quantity Selector
                  _buildQuantitySelector(),
                  const SizedBox(height: 24),

                  // Add to Cart Button
                  PrimaryButton(
                    text: 'Tambah ke Keranjang',
                    onPressed: () => _addToCart(cart),
                    isLoading: _isAddingToCart,
                    height: 56,
                    icon: Icons.shopping_cart_rounded,
                  ),
                  const SizedBox(height: 12),

                  // Continue Shopping Button
                  SecondaryButton(
                    text: 'Lanjut Belanja',
                    onPressed: () => Navigator.pop(context),
                    icon: Icons.arrow_back_rounded,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          widget.produk.image.isNotEmpty
              ? Image.network(
                  widget.produk.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[300],
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      size: 64,
                      color: Color(0xFFCCCCCC),
                    ),
                  ),
                )
              : Container(
                  height: 300,
                  width: double.infinity,
                  color: Colors.grey[300],
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.shopping_basket_rounded,
                    size: 64,
                    color: Color(0xFF2E7D32),
                  ),
                ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_border_rounded,
                  color: Color(0xFFFF6F00),
                  size: 24,
                ),
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
      ),
    );
  }

  Widget _buildProductHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.produk.name,
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
              child: const Text(
                'PRODUK SEGAR',
                style: TextStyle(
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
          'Rp${widget.produk.price.toStringAsFixed(0).replaceAllMapped(
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

  Widget _buildRatingSection() {
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
            value: '4.8',
            color: const Color(0xFFFFB400),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          _buildRatingItem(
            icon: Icons.shopping_bag_rounded,
            label: 'Terjual',
            value: '245',
            color: const Color(0xFF2E7D32),
          ),
          Container(
            width: 1,
            height: 50,
            color: Colors.grey[300],
          ),
          _buildRatingItem(
            icon: Icons.visibility_rounded,
            label: 'Dilihat',
            value: '1.2K',
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
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi Produk',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
          child: Text(
            widget.produk.description.isNotEmpty
                ? widget.produk.description
                : 'Produk segar pilihan dari petani lokal berkualitas premium.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Color(0xFF666666),
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Jumlah:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDEDEDE)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  iconSize: 20,
                  onPressed:
                      _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    _quantity.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  iconSize: 20,
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(CartProvider cart) async {
    setState(() => _isAddingToCart = true);

    // Simulate adding to cart
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < _quantity; i++) {
      cart.tambah(widget.produk);
    }

    if (!mounted) return;

    setState(() => _isAddingToCart = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_quantity item berhasil ditambahkan ke keranjang'),
        backgroundColor: const Color(0xFF2E7D32),
        action: SnackBarAction(
          label: 'Lihat',
          onPressed: () {
            // Navigate to cart
          },
        ),
      ),
    );

    // Reset quantity
    setState(() => _quantity = 1);
  }
}
