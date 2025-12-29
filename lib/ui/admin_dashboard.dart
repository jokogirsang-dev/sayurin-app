import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/pesanan_provider.dart';
import '../providers/produk_provider.dart';
import '../model/produk.dart';
import '../helpers/format_currency.dart';
import 'admin_pages/admin_products_page.dart';
import 'admin_pages/admin_orders_page.dart';
import 'admin_pages/admin_stock_page.dart';
import 'admin_pages/admin_analytics_page.dart';
import 'admin_pages/admin_reports_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load data
      final produkProv = Provider.of<ProdukProvider>(context, listen: false);
      final pesananProv = Provider.of<PesananProvider>(context, listen: false);
      final adminProv = Provider.of<AdminProvider>(context, listen: false);

      produkProv.fetchProduk();
      pesananProv.fetchPesanan();

      // Sync data to AdminProvider for use in admin pages
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          // Sync products
          for (var product in produkProv.produkList) {
            adminProv.addProductToAdmin(
              nama: product.nama,
              harga: product.harga,
              gambar: product.gambar,
              stok: product.stok,
              kategori: product.kategori,
            );
          }
          // Sync orders
          adminProv.loadOrders(pesananProv.semuaPesanan);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        elevation: 2,
        backgroundColor: Colors.green[700],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProv, _) {
          switch (_selectedIndex) {
            case 0:
              return _buildDashboardOverview(context);
            case 1:
              return const AdminProductsPage();
            case 2:
              return const AdminOrdersPage();
            case 3:
              return const AdminStockPage();
            case 4:
              return const AdminReportsPage();
            case 5:
              return const AdminAnalyticsPage();
            default:
              return _buildDashboardOverview(context);
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Pesanan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: 'Stok',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardOverview(BuildContext context) {
    return Consumer3<AdminProvider, ProdukProvider, PesananProvider>(
      builder: (context, adminProv, produkProv, pesananProv, _) {
        // Build analytics from real data
        final totalProducts = produkProv.produkList.length;
        final totalOrders = pesananProv.semuaPesanan.length;
        final completedOrders = pesananProv.semuaPesanan
            .where((o) => o.status == 'completed')
            .length;
        final pendingOrders =
            pesananProv.semuaPesanan.where((o) => o.status == 'pending').length;
        final totalRevenue = pesananProv.semuaPesanan
            .fold<double>(0, (sum, order) => sum + order.totalHarga);
        final averageOrderValue =
            totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
        final lowStockProducts =
            produkProv.produkList.where((p) => p.stok < 5).toList();

        // Create analytics map
        final analytics = {
          'totalProducts': totalProducts,
          'totalOrders': totalOrders,
          'completedOrders': completedOrders,
          'pendingOrders': pendingOrders,
          'totalRevenue': totalRevenue,
          'averageOrderValue': averageOrderValue,
          'lowStockProducts': lowStockProducts,
        };

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === STATS CARDS ===
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildStatCard(
                    title: 'Total Produk',
                    value: '${analytics['totalProducts']}',
                    icon: Icons.inventory_2,
                    color: Colors.blue,
                  ),
                  _buildStatCard(
                    title: 'Total Pesanan',
                    value: '${analytics['totalOrders']}',
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                  _buildStatCard(
                    title: 'Selesai',
                    value: '${analytics['completedOrders']}',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                  _buildStatCard(
                    title: 'Pending',
                    value: '${analytics['pendingOrders']}',
                    icon: Icons.schedule,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === REVENUE CARD ===
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Revenue',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp ${FormatCurrency.toRupiah(analytics['totalRevenue'] as double)}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rata-rata per pesanan: Rp ${FormatCurrency.toRupiah(analytics['averageOrderValue'] as double)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // === LOW STOCK WARNING ===
              if ((analytics['lowStockProducts'] as List).isNotEmpty)
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            const Text(
                              'Produk Stok Rendah',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...((analytics['lowStockProducts'] as List)
                            .cast<Produk>()
                            .take(3)
                            .map((p) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(p.nama),
                                Text(
                                  'Stok: ${p.stok}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList()),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // === QUICK ACTIONS ===
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedIndex = 1),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah Produk'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() => _selectedIndex = 2),
                      icon: const Icon(Icons.visibility),
                      label: const Text('Lihat Pesanan'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
