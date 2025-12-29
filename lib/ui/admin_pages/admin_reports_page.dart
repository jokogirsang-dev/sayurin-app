import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/pesanan_provider.dart';
import '../../providers/produk_provider.dart';
import '../../helpers/format_currency.dart';

class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        elevation: 0,
      ),
      body: Consumer3<AdminProvider, PesananProvider, ProdukProvider>(
        builder: (context, adminProv, pesananProv, produkProv, _) {
          // Build analytics from real data
          final orders = pesananProv.semuaPesanan;
          final totalOrders = orders.length;
          final completedOrders =
              orders.where((o) => o.status == 'completed').length;
          final pendingOrders =
              orders.where((o) => o.status == 'pending').length;
          final totalRevenue =
              orders.fold<double>(0, (sum, order) => sum + order.totalHarga);
          final averageOrderValue =
              totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
          final totalProducts = produkProv.produkList.length;

          final analytics = {
            'totalOrders': totalOrders,
            'completedOrders': completedOrders,
            'pendingOrders': pendingOrders,
            'totalRevenue': totalRevenue,
            'averageOrderValue': averageOrderValue,
            'totalProducts': totalProducts,
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === PERIOD ===
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Periode Laporan',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _getDateRange(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Filter periode akan ditambahkan di versi berikutnya',
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.calendar_today, size: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // === KEY METRICS ===
                Text(
                  'Metrik Utama',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildMetricCard(
                      title: 'Total Pesanan',
                      value: '${analytics['totalOrders']}',
                      subtitle: 'pesanan',
                      icon: Icons.shopping_cart,
                      color: Colors.blue,
                    ),
                    _buildMetricCard(
                      title: 'Selesai',
                      value: '${analytics['completedOrders']}',
                      subtitle: 'completed',
                      icon: Icons.check_circle,
                      color: Colors.green,
                    ),
                    _buildMetricCard(
                      title: 'Pending',
                      value: '${analytics['pendingOrders']}',
                      subtitle: 'pending',
                      icon: Icons.schedule,
                      color: Colors.orange,
                    ),
                    _buildMetricCard(
                      title: 'Total Produk',
                      value: '${analytics['totalProducts']}',
                      subtitle: 'produk',
                      icon: Icons.inventory_2,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // === REVENUE ===
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pendapatan Penjualan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total Revenue',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${FormatCurrency.toRupiah((analytics['totalRevenue'] as num).toDouble())}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Rata-rata per Pesanan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${FormatCurrency.toRupiah((analytics['averageOrderValue'] as num).toDouble())}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // === TOP ORDERS ===
                Text(
                  'Pesanan Terbesar',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if (orders.isEmpty)
                  const Center(child: Text('Belum ada pesanan'))
                else
                  ...(orders.toList()
                        ..sort((a, b) => b.totalHarga.compareTo(a.totalHarga)))
                      .take(5)
                      .map((order) => _buildOrderRow(order))
                      .toList(),
                const SizedBox(height: 24),

                // === LOW STOCK PRODUCTS ===
                Text(
                  'Produk Stok Rendah (< 5)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                if ((analytics['lowStockProducts'] as List).isEmpty)
                  const Center(
                    child: Text('Semua stok dalam kondisi baik'),
                  )
                else
                  ...(analytics['lowStockProducts'] as List)
                      .take(5)
                      .map((product) {
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.warning, color: Colors.red),
                        title: Text(product.nama),
                        subtitle: Text('Stok: ${product.stok} unit'),
                        trailing: Text(
                          'Rp ${FormatCurrency.toRupiah(product.harga)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
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
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderRow(dynamic order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${order.items.length} items',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              'Rp ${FormatCurrency.toRupiah(order.totalHarga)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDateRange() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return '${startOfMonth.day}/${startOfMonth.month}/${startOfMonth.year} - ${now.day}/${now.month}/${now.year}';
  }
}
