// lib/ui/pesanan_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pesanan_provider.dart';
import '../providers/user_provider.dart';
import '../model/pesanan.dart';
import '../helpers/format_currency.dart';

// Note: Pesanan.items sekarang bertipe List<PesananItem>, bukan List<Produk>

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Pesanan> _filterPesananByStatus(List<Pesanan> allPesanan, String status) {
    return allPesanan.where((p) => p.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isAdmin = userProvider.isAdmin;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAF2),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesanan Saya',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              isAdmin ? '👑 Admin Mode' : '🛒 Mode Pembeli',
              style: TextStyle(
                color: isAdmin ? Colors.orange[700] : Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelColor: Colors.green[700],
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Colors.green[700],
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
          ),
          tabs: const [
            Tab(text: 'Diproses'),
            Tab(text: 'Dikemas'),
            Tab(text: 'Dikirim'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: Consumer<PesananProvider>(
        builder: (context, pesananProvider, child) {
          final allPesanan = pesananProvider.semuaPesanan;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPesananList(_filterPesananByStatus(allPesanan, 'Diproses'), isAdmin),
              _buildPesananList(_filterPesananByStatus(allPesanan, 'Dikemas'), isAdmin),
              _buildPesananList(_filterPesananByStatus(allPesanan, 'Dikirim'), isAdmin),
              _buildPesananList(_filterPesananByStatus(allPesanan, 'Selesai'), isAdmin),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPesananList(List<Pesanan> pesananList, bool isAdmin) {
    if (pesananList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada pesanan',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isAdmin 
                  ? 'Pesanan pelanggan akan muncul di sini'
                  : 'Pesanan Anda akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pesananList.length,
      itemBuilder: (context, index) {
        return _buildPesananCard(pesananList[index], isAdmin);
      },
    );
  }

  Widget _buildPesananCard(Pesanan pesanan, bool isAdmin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.receipt, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      pesanan.id,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(pesanan.status),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // Item Pesanan
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: pesanan.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      // Gambar Produk
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildImage(item.gambar),
                      ),
                      const SizedBox(width: 12),
                      // Detail Produk
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.jumlah} x Rp ${FormatCurrency.toRupiah(item.harga)}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Harga Total Item
                      Text(
                        'Rp ${FormatCurrency.toRupiah(item.harga * item.jumlah)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),

          // Footer
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tanggal Pesanan
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(pesanan.tanggal),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Total Belanja
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Belanja',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Rp ${FormatCurrency.toRupiah(pesanan.totalHarga)}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Action Buttons
                _buildActionButtons(pesanan, isAdmin),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Pesanan pesanan, bool isAdmin) {
    if (isAdmin) {
      return _buildAdminActions(pesanan);
    } else {
      return _buildUserActions(pesanan);
    }
  }

  Widget _buildAdminActions(Pesanan pesanan) {
    return Row(
      children: [
        if (pesanan.status == 'Diproses') ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDetailDialog(context, pesanan),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(context, pesanan.id, 'Dikemas'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Proses Pesanan',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ),
        ],
        if (pesanan.status == 'Dikemas') ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDetailDialog(context, pesanan),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _updateStatus(context, pesanan.id, 'Dikirim'),
              icon: const Icon(Icons.local_shipping, size: 16),
              label: const Text('Kirim', style: TextStyle(fontSize: 13)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        if (pesanan.status == 'Dikirim') ...[
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDetailDialog(context, pesanan),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[400]!),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Lihat Detail',
                style: TextStyle(color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showTrackingDialog(context, pesanan),
              icon: const Icon(Icons.location_on, size: 18),
              label: const Text('Lacak'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        if (pesanan.status == 'Selesai') ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showDetailDialog(context, pesanan),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text('Lihat Detail'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUserActions(Pesanan pesanan) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showDetailDialog(context, pesanan),
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text('Lihat Detail'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[400]!),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (pesanan.status == 'Dikirim') ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showTrackingDialog(context, pesanan),
              icon: const Icon(Icons.local_shipping, size: 18),
              label: const Text('Lacak Paket'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ] else if (pesanan.status == 'Selesai') ...[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showReorderDialog(context, pesanan),
              icon: const Icon(Icons.shopping_cart, size: 18),
              label: const Text('Beli Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 60,
            height: 60,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.green[50],
          child: Icon(Icons.eco, color: Colors.green[300], size: 32),
        ),
      );
    } else {
      return Image.asset(
        url.isNotEmpty ? url : 'assets/images/default.png',
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 60,
          height: 60,
          color: Colors.green[50],
          child: Icon(Icons.eco, color: Colors.green[300], size: 32),
        ),
      );
    }
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Diproses':
        bgColor = Colors.blue[50]!;
        textColor = Colors.blue[700]!;
        icon = Icons.hourglass_empty;
        break;
      case 'Dikemas':
        bgColor = Colors.purple[50]!;
        textColor = Colors.purple[700]!;
        icon = Icons.inventory;
        break;
      case 'Dikirim':
        bgColor = Colors.orange[50]!;
        textColor = Colors.orange[700]!;
        icon = Icons.local_shipping;
        break;
      case 'Selesai':
        bgColor = Colors.green[50]!;
        textColor = Colors.green[700]!;
        icon = Icons.check_circle;
        break;
      default:
        bgColor = Colors.grey[50]!;
        textColor = Colors.grey[700]!;
        icon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatus(BuildContext context, String id, String newStatus) {
    final pesananProvider = Provider.of<PesananProvider>(context, listen: false);
    pesananProvider.updateStatus(id, newStatus);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status pesanan diupdate menjadi: $newStatus'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTrackingDialog(BuildContext context, Pesanan pesanan) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAdmin = userProvider.isAdmin;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lacak Paket'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nomor Pesanan: ${pesanan.id}'),
            const SizedBox(height: 16),
            const Text('Status Pengiriman:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTrackingStep('Pesanan diterima kurir', true),
            _buildTrackingStep('Dalam perjalanan', true),
            _buildTrackingStep('Tiba di kota tujuan', false),
            _buildTrackingStep('Pesanan diantar', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          if (!isAdmin)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _updateStatus(context, pesanan.id, 'Selesai');
              },
              child: const Text('Terima Pesanan'),
            ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(String text, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 20,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isCompleted ? Colors.black87 : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, Pesanan pesanan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pesanan'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nomor: ${pesanan.id}'),
              Text('Tanggal: ${_formatDate(pesanan.tanggal)}'),
              Text('Status: ${pesanan.status}'),
              const SizedBox(height: 12),
              const Text('Produk:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...pesanan.items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('• ${item.nama} (${item.jumlah}x)'),
              )),
              const SizedBox(height: 12),
              Text(
                'Total: Rp ${FormatCurrency.toRupiah(pesanan.totalHarga)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showReorderDialog(BuildContext context, Pesanan pesanan) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Beli Lagi'),
        content: const Text('Tambahkan produk dari pesanan ini ke keranjang?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Produk ditambahkan ke keranjang!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Ya, Tambahkan'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays == 0) {
      return 'Hari ini, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else {
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green[700],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.eco, color: Colors.green, size: 32),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sayur.in',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Segar dari Petani Lokal',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.green),
            title: const Text('Beranda'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag, color: Colors.green),
            title: const Text('Produk'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.local_shipping, color: Colors.green),
            title: const Text('Pesanan'),
            selected: true,
            selectedTileColor: Colors.green[50],
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.green),
            title: const Text('Profil'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.green),
            title: const Text('Tentang'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}