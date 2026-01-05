import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pesanan_provider.dart';
import '../providers/user_provider.dart';
import '../model/pesanan.dart';
import '../helpers/format_currency.dart';
import '../widget/custom_app_bar.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage>
    with SingleTickerProviderStateMixin {
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

  List<Pesanan> _filterPesananByStatus(
      List<Pesanan> allPesanan, String status) {
    return allPesanan.where((p) => p.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: 'Pesanan Saya',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // TAB BAR
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: const Color(0xFF2E7D32),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF2E7D32),
              tabs: const [
                Tab(text: 'Diproses'),
                Tab(text: 'Dikemas'),
                Tab(text: 'Dikirim'),
                Tab(text: 'Selesai'),
              ],
            ),
          ),

          // TAB VIEW
          Expanded(
            child: Consumer<PesananProvider>(
              builder: (context, provider, _) {
                final allPesanan = provider.semuaPesanan;

                if (allPesanan.isEmpty) {
                  return _buildEmpty();
                }

                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPesananList(
                        _filterPesananByStatus(allPesanan, 'Diproses')),
                    _buildPesananList(
                        _filterPesananByStatus(allPesanan, 'Dikemas')),
                    _buildPesananList(
                        _filterPesananByStatus(allPesanan, 'Dikirim')),
                    _buildPesananList(
                        _filterPesananByStatus(allPesanan, 'Selesai')),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===================== LIST =====================

  Widget _buildPesananList(List<Pesanan> list) {
    if (list.isEmpty) {
      return _buildEmpty();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _buildPesananCard(list[i]),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
          SizedBox(height: 12),
          Text('Belum ada pesanan'),
        ],
      ),
    );
  }

  // ===================== CARD =====================

  Widget _buildPesananCard(Pesanan pesanan) {
    final items = pesanan.items;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // HEADER
          ListTile(
            title: Text(
              'Order #${pesanan.id}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: _buildStatusBadge(pesanan.status),
          ),

          const Divider(),

          // ITEMS
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: items.map((item) {
                return Row(
                  children: [
                    _buildImage(item.gambar ?? ''),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${item.namaProduk} (${item.jumlah}x)',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Text(
                      FormatCurrency.toRupiah(item.harga * item.jumlah),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),

          const Divider(),

          // FOOTER
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    Text(
                      FormatCurrency.toRupiah(pesanan.totalHarga),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildActionButtons(pesanan),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== ACTION =====================

  Widget _buildActionButtons(Pesanan pesanan) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showDetailDialog(context, pesanan),
            child: const Text('Detail'),
          ),
        ),
        if (pesanan.status != 'Selesai') ...[
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _updateStatus(context, pesanan.id, 'Selesai'),
              child: const Text('Terima'),
            ),
          ),
        ],
      ],
    );
  }

  // ===================== STATUS =====================

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Diproses':
        color = Colors.blue;
        break;
      case 'Dikemas':
        color = Colors.purple;
        break;
      case 'Dikirim':
        color = Colors.orange;
        break;
      default:
        color = Colors.green;
    }

    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }

  // ===================== IMAGE =====================

  Widget _buildImage(String url) {
    if (url.startsWith('http')) {
      return Image.network(
        url,
        width: 50,
        height: 50,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported),
      );
    }
    return const Icon(Icons.image);
  }

  // ===================== LOGIC =====================

  void _updateStatus(BuildContext context, int id, String status) {
    Provider.of<PesananProvider>(context, listen: false)
        .updateStatus(id, status);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pesanan diperbarui')),
    );
  }

  void _showDetailDialog(BuildContext context, Pesanan pesanan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detail Pesanan'),
        content: Text(
          'ID: ${pesanan.id}\n'
          'Status: ${pesanan.status}\n'
          'Total: ${FormatCurrency.toRupiah(pesanan.totalHarga)}',
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
}
