import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/pesanan_provider.dart';
import '../../providers/produk_provider.dart';
import '../../helpers/format_currency.dart';
import '../../widget/custom_app_bar.dart';
import '../../model/pesanan.dart'; // Asumsi impor model
import '../../model/produk.dart'; // Asumsi impor model

class AdminAnalyticsPage extends StatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  State<AdminAnalyticsPage> createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends State<AdminAnalyticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CustomAppBar(
        title: 'Analytics & Insights',
        backgroundColor: const Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      body: Consumer3<AdminProvider, PesananProvider, ProdukProvider>(
        builder: (context, adminProv, pesananProv, produkProv, _) {
          // Build analytics from real data
          final orders = pesananProv.semuaPesanan ?? []; // Null safety
          final totalOrders = orders.length;
          final completedOrders = orders.where((o) => o.status == 'completed').length;
          final pendingOrders = orders.where((o) => o.status == 'pending').length;
          final totalRevenue = orders.fold<double>(0, (sum, order) => sum + (order.totalHarga ?? 0)); // Null safety
          final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;
          final lowStockProducts = produkProv.listProduk?.where((p) => p.stok < 5).toList() ?? []; // Calculate here
          final double completionRate = totalOrders > 0 ? completedOrders / totalOrders : 0.0;

          // Build category data from real products
          final Map<String, int> categoryData = {};
          for (var product in produkProv.listProduk ?? []) { // Null safety
            categoryData[product.kategori] = (categoryData[product.kategori] ?? 0) + 1;
          }

          final analytics = {
            'totalOrders': totalOrders,
            'completedOrders': completedOrders,
            'pendingOrders': pendingOrders,
            'totalRevenue': totalRevenue,
            'averageOrderValue': averageOrderValue,
            'totalProducts': produkProv.listProduk?.length ?? 0, // Tambah ini
            'lowStockProducts': lowStockProducts, // Tambah ini
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === SALES PERFORMANCE ===
                _buildSectionTitle(context, 'Sales Performance'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Orders'),
                            Text(
                              '$totalOrders',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: completionRate,
                            minHeight: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: const AlwaysStoppedAnimation(Colors.green),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Completion Rate: ${(completionRate * 100).toStringAsFixed(1)}%',
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

                // === REVENUE ANALYTICS ===
                _buildSectionTitle(context, 'Revenue Analytics'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _buildAnalyticsCard(
                      title: 'Total Revenue',
                      value: 'Rp ${FormatCurrency.toRupiah((analytics['totalRevenue'] as num?)?.toDouble() ?? 0)}',
                      icon: Icons.attach_money,
                      color: Colors.green,
                    ),
                    _buildAnalyticsCard(
                      title: 'Avg. Order Value',
                      value: 'Rp ${FormatCurrency.toRupiah((analytics['averageOrderValue'] as num?)?.toDouble() ?? 0)}',
                      icon: Icons.trending_up,
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // === PRODUCTS BY CATEGORY ===
                if (categoryData.isNotEmpty) ...[
                  _buildSectionTitle(context, 'Produk per Kategori'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: categoryData.entries.map((entry) {
                          final percentage = (entry.value / (analytics['totalProducts'] as int? ?? 1)) * 100; // Fix undefined
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key),
                                    Text(
                                      '${entry.value} produk',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percentage / 100,
                                    minHeight: 8,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation(
                                      Color.lerp(Colors.blue, Colors.green, percentage / 100) ?? Colors.blue, // Null safety
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${percentage.toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // === ORDER STATUS DISTRIBUTION ===
                _buildSectionTitle(context, 'Order Status Distribution'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatusRow(
                          label: 'Completed',
                          count: analytics['completedOrders'] as int? ?? 0, // Type safety
                          total: analytics['totalOrders'] as int? ?? 0,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildStatusRow(
                          label: 'Pending',
                          count: analytics['pendingOrders'] as int? ?? 0,
                          total: analytics['totalOrders'] as int? ?? 0,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // === TOP INSIGHTS ===
                _buildSectionTitle(context, 'Top Insights'),
                const SizedBox(height: 12),
                ...(analytics['lowStockProducts'] as List<Produk>? ?? []).isNotEmpty // Fix type and undefined
                    ? [
                        Card(
                          color: Colors.red[50],
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.warning, color: Colors.red[700]),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Stok Rendah',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${(analytics['lowStockProducts'] as List<Produk>? ?? []).length} produk memiliki stok < 5 unit',
                                        style: const TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ]
                    : [],
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Total Produk',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${analytics['totalProducts']} produk terdaftar dalam sistem',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAnalyticsCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: color),
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
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final percentage = total > 0 ? (count / total) * 100 : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '$count / $total',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 8,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}