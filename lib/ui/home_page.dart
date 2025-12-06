import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/produk_provider.dart';
import '../providers/cart_provider.dart';
import '../model/produk.dart';
import 'produk_page.dart';
import 'produk_detail_page.dart';
import 'cart_page.dart';
import '../widget/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _carouselIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.92);

  @override
  void initState() {
    super.initState();
    // ambil produk via provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProdukProvider>(context, listen: false).fetchProduk();
    });
  }

  @override
  Widget build(BuildContext context) {
    final produkProv = Provider.of<ProdukProvider>(context);
    final cartProv = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sayur.in'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartProv.totalItems > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        cartProv.totalItems.toString(),
                        style:
                            const TextStyle(fontSize: 10, color: Colors.white),
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      ),

      // ⬇️ INI YANG DIGANTI
      drawer: const AppSidebar(),

      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ProdukProvider>(context, listen: false)
              .fetchProduk();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(context),
              const SizedBox(height: 12),

              // Carousel / Banner
              SizedBox(
                height: 140,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _carouselIndex = i),
                  children: [
                    _bannerCard(context, 'Segar setiap hari',
                        'assets/images/sayurin.png'),
                    _bannerCard(context, 'Diskon spesial minggu ini',
                        'assets/images/sayurin.png'),
                    _bannerCard(context, 'Kualitas dari petani lokal',
                        'assets/images/sayurin.png'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildDots(),

              const SizedBox(height: 16),

              // Kategori quick-action
              _buildCategoryChips(),

              const SizedBox(height: 16),

              // Featured horizontal list
              const Text('Produk Unggulan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 150,
                child: produkProv.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final p = produkProv.listProduk[index];
                          return _featuredCard(context, p);
                        },
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemCount: produkProv.listProduk.length > 6
                            ? 6
                            : produkProv.listProduk.length,
                      ),
              ),

              const SizedBox(height: 16),

              // Grid produk
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Semua Produk',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProdukPage()));
                      },
                      child: const Text('Lihat Semua'))
                ],
              ),
              const SizedBox(height: 8),

              produkProv.isLoading
                  ? const Center(
                      child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ))
                  : produkProv.error != null
                      ? Center(
                          child: Column(
                            children: [
                              Text(produkProv.error!),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () => produkProv.fetchProduk(),
                                child: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: produkProv.listProduk.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.66,
                          ),
                          itemBuilder: (context, index) {
                            final p = produkProv.listProduk[index];
                            return _productGridCard(context, p);
                          },
                        ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const CartPage()));
        },
        icon: const Icon(Icons.shopping_bag_outlined),
        label: Text('Keranjang (${cartProv.totalItems})'),
      ),

      // optional bottom nav (you can remove if you use Drawer)
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.favorite_border)),
              const Spacer(),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.notifications_none)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        onSubmitted: (v) {
          // implement search or navigate to ProdukPage with query
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const ProdukPage()));
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: 'Cari sayur, buah, atau bahan dapur...',
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          suffixIcon: IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // open filter modal
              showModalBottomSheet(
                  context: context, builder: (_) => _filterSheet());
            },
          ),
        ),
      ),
    );
  }

  Widget _bannerCard(BuildContext context, String title, String assetPath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Stack(
          fit: StackFit.expand,
          children: [
            // banner image (use AssetImage if exists, else placeholder)
            Image(
              image: AssetImage(assetPath),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.green.shade100),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(0.18),
                  Colors.transparent
                ]),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == _carouselIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 12 : 8,
          height: active ? 12 : 8,
          decoration: BoxDecoration(
            color: active ? Colors.green.shade700 : Colors.green.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }

  Widget _buildCategoryChips() {
    final categories = ['Sayur', 'Buah', 'Bumbu', 'Daging', 'Susu'];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          return ActionChip(
            label: Text(categories[i]),
            onPressed: () {
              // contoh: buka ProdukPage dan filter by category
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ProdukPage()));
            },
            elevation: 0,
            backgroundColor: Colors.green.shade50,
            labelStyle: TextStyle(color: Colors.green.shade800),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: categories.length,
      ),
    );
  }

  Widget _featuredCard(BuildContext context, Produk p) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProdukDetailPage(produk: p))),
      child: SizedBox(
        width: 140,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    p.gambar,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) =>
                        Container(color: Colors.green.shade50),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                    Text(p.nama, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text('Rp ${p.harga.toStringAsFixed(0)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productGridCard(BuildContext context, Produk p) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ProdukDetailPage(produk: p))),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  p.gambar,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.green.shade50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(p.nama,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('Rp ${p.harga.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .tambah(p);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Ditambahkan ke keranjang')));
                      },
                      child: const Text('Tambah')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _filterSheet() {
    return SizedBox(
      height: 220,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Filter Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.filter_alt),
              title: const Text('Termurah'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.filter_alt),
              title: const Text('Terlaris'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
