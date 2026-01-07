import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';
import '../providers/user_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Schedule loading after first frame to avoid notifyListeners during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adminProvider = context.read<AdminProvider>();
      adminProvider.produkProvider.fetchProduk();
      adminProvider.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Guard: pastikan user adalah admin
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!userProvider.isAdmin) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Logout and go to login
              Provider.of<UserProvider>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          final produkCount = adminProvider.produkProvider.listProduk.length;
          final orderCount = adminProvider.pesananList.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick stats
                Row(
                  children: [
                    Expanded(
                        child: _buildStatCard('Produk', produkCount.toString(),
                            Icons.inventory_2)),
                    const SizedBox(width: 12),
                    Expanded(
                        child: _buildStatCard('Pesanan', orderCount.toString(),
                            Icons.receipt_long)),
                  ],
                ),
                const SizedBox(height: 16),

                const Text('Admin Features',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  children: [
                    _featureCard(context, 'Analytics', Icons.analytics, () {
                      debugPrint('Navigating to analytics');
                      Future.microtask(() =>
                          Navigator.pushNamed(context, '/admin/analytics'));
                    }),
                    _featureCard(context, 'Products', Icons.inventory_2, () {
                      debugPrint('Navigating to products');
                      Future.microtask(() =>
                          Navigator.pushNamed(context, '/admin/products'));
                    }),
                    _featureCard(context, 'Stock', Icons.storage, () {
                      debugPrint('Navigating to stock');
                      Future.microtask(
                          () => Navigator.pushNamed(context, '/admin/stock'));
                    }),
                    _featureCard(context, 'Orders', Icons.receipt_long, () {
                      debugPrint('Navigating to orders');
                      Future.microtask(
                          () => Navigator.pushNamed(context, '/admin/orders'));
                    }),
                    _featureCard(context, 'Reports', Icons.bar_chart, () {
                      debugPrint('Navigating to reports');
                      Future.microtask(
                          () => Navigator.pushNamed(context, '/admin/reports'));
                    }),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.green),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey)),
                Text(value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blue),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
