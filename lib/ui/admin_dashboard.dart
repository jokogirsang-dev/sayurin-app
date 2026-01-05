import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Load data saat halaman dibuka
    Future.microtask(() {
      final adminProvider = context.read<AdminProvider>();
      adminProvider.produkProvider.fetchProduk();
      adminProvider.loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: Consumer<AdminProvider>(
        builder: (context, adminProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Contoh: Tambah Produk
                ElevatedButton(
                  onPressed: () async {
                    await adminProvider.tambahProduk(
                      nama: 'Produk Baru',
                      harga: 50000,
                      gambar: 'url_gambar',
                      stok: 10,
                      kategori: 'Elektronik',
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Produk berhasil ditambahkan')),
                      );
                    }
                  },
                  child: const Text('Tambah Produk'),
                ),
                
                const SizedBox(height: 20),
                
                // List Produk
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: adminProvider.produkProvider.listProduk.length,
                  itemBuilder: (context, index) {
                    final produk = adminProvider.produkProvider.listProduk[index];
                    return ListTile(
                      title: Text(produk.nama),
                      subtitle: Text('Rp ${produk.harga} - Stok: ${produk.stok}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Edit produk
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await adminProvider.hapusProduk(produk.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}