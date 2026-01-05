import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/pesanan_provider.dart';
import '../../model/pesanan.dart';
import '../../helpers/format_currency.dart';
import '../../widget/custom_app_bar.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  String _filterStatus = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const CustomAppBar(
        title: 'Manajemen Pesanan',
        backgroundColor: Color(0xFF1565C0),
        titleColor: Colors.white,
      ),
      body: Consumer<PesananProvider>(
        builder: (context, pesananProv, _) {
          final orders = _filterStatus.isEmpty
              ? (pesananProv.semuaPesanan ?? []) // Null safety
              : (pesananProv.semuaPesanan ?? []).where((o) => o.status == _filterStatus).toList();

          if (orders.isEmpty) {
            return const Center(child: Text('Tidak ada pesanan'));
          }

          return Column(
            children: [
              _buildFilterBar(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: orders.length,
                  itemBuilder: (_, i) => _buildOrderCard(context, orders[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ================= FILTER =================

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          _filterBtn('Semua', ''),
          _filterBtn('Diproses', 'Diproses'),
          _filterBtn('Dikemas', 'Dikemas'),
          _filterBtn('Dikirim', 'Dikirim'),
          _filterBtn('Selesai', 'Selesai'),
        ],
      ),
    );
  }

  Widget _filterBtn(String label, String value) {
    final selected = _filterStatus == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () => setState(() => _filterStatus = value),
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.green : Colors.grey[300],
          foregroundColor: selected ? Colors.white : Colors.black,
        ),
        child: Text(label),
      ),
    );
  }

  // ================= CARD =================

  Widget _buildOrderCard(BuildContext context, Pesanan order) {
    final statusColor = _statusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.tanggal),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                _statusBadge(order.status, statusColor),
              ],
            ),

            const SizedBox(height: 12),

            // ITEMS
            const Text(
              'Item',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),

            ...order.items.take(3).map((item) => Text(
                  '• ${item.namaProduk} x${item.jumlah} - Rp ${FormatCurrency.toRupiah(item.harga * item.jumlah)}',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                )),

            if (order.items.length > 3)
              Text(
                '+ ${order.items.length - 3} item lainnya',
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),

            const SizedBox(height: 12),

            // TOTAL & ACTION
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp ${FormatCurrency.toRupiah(order.totalHarga)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _showDetail(context, order),
                      child: const Text('Detail'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _showUpdateStatus(context, order),
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================= DIALOG =================

  void _showDetail(BuildContext context, Pesanan order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Order #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tanggal: ${_formatDate(order.tanggal)}'),
              Text('Status: ${order.status}'),
              const SizedBox(height: 12),
              const Text(
                'Items:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...order.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${item.namaProduk} x${item.jumlah} Rp ${FormatCurrency.toRupiah(item.harga * item.jumlah)}',
                    ),
                  )),
              const Divider(height: 24),
              Text(
                'Total: Rp ${FormatCurrency.toRupiah(order.totalHarga)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
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

  void _showUpdateStatus(BuildContext context, Pesanan order) {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ubah Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusOption(adminProv, order, 'Diproses'),
            _statusOption(adminProv, order, 'Dikemas'),
            _statusOption(adminProv, order, 'Dikirim'),
            _statusOption(adminProv, order, 'Selesai'),
          ],
        ),
      ),
    );
  }

  Widget _statusOption(
      AdminProvider prov, Pesanan order, String status) {
    return ListTile(
      title: Text(status),
      leading: Icon(
        Icons.circle,
        color: _statusColor(status),
        size: 12,
      ),
      onTap: () {
        prov.updateStatus(order.id, status);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status order #${order.id} diubah ke $status'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  // ================= UTIL =================

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15), // Fix deprecated
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses':
        return Colors.blue;
      case 'Dikemas':
        return Colors.purple;
      case 'Dikirim':
        return Colors.orange;
      case 'Selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime d) {
    return '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }
}