import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/admin_provider.dart';
import '../../providers/pesanan_provider.dart';
import '../../model/pesanan.dart';
import '../../helpers/format_currency.dart';

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
      appBar: AppBar(
        title: const Text('Manajemen Pesanan'),
        elevation: 0,
      ),
      body: Consumer2<AdminProvider, PesananProvider>(
        builder: (context, adminProv, pesananProv, _) {
          final orders = _filterStatus.isEmpty
              ? pesananProv.semuaPesanan
              : pesananProv.semuaPesanan
                  .where((o) =>
                      o.status.toLowerCase() == _filterStatus.toLowerCase())
                  .toList();

          // ✅ DEBUG: Show total orders count
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (pesananProv.semuaPesanan.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '📊 Total Pesanan: ${pesananProv.semuaPesanan.length} | Filtered: ${orders.length}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          });

          return Column(
            children: [
              // === FILTER BUTTONS ===
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _buildFilterButton(
                      label: 'Semua',
                      selected: _filterStatus.isEmpty,
                      onTap: () => setState(() => _filterStatus = ''),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      label: 'Pending',
                      selected: _filterStatus == 'pending',
                      onTap: () => setState(() => _filterStatus = 'pending'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      label: 'Completed',
                      selected: _filterStatus == 'completed',
                      onTap: () => setState(() => _filterStatus = 'completed'),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterButton(
                      label: 'Cancelled',
                      selected: _filterStatus == 'cancelled',
                      onTap: () => setState(() => _filterStatus = 'cancelled'),
                    ),
                  ],
                ),
              ),

              // === ORDERS LIST ===
              Expanded(
                child: orders.isEmpty
                    ? const Center(child: Text('Tidak ada pesanan'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return _buildOrderCard(context, order, adminProv);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.green : Colors.grey[300],
        foregroundColor: selected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  Widget _buildOrderCard(
      BuildContext context, Pesanan order, AdminProvider adminProv) {
    final statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === HEADER ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(order.tanggal),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // === ITEMS INFO ===
            Text(
              'Items (${order.items.length}):',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            ...order.items.take(3).map((item) {
              return Text(
                '• ${item.nama} x${item.jumlah} - Rp ${FormatCurrency.toRupiah(item.subtotal)}',
                style: const TextStyle(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }).toList(),
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

            // === TOTAL & ACTION ===
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      'Rp ${FormatCurrency.toRupiah(order.totalHarga)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => _showOrderDetails(context, order),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Detail'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (order.status != 'completed')
                      ElevatedButton.icon(
                        onPressed: () =>
                            _showStatusChangeDialog(context, order, adminProv),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Update'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          backgroundColor: Colors.blue,
                        ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showOrderDetails(BuildContext context, Pesanan order) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detail Order #${order.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Tanggal: ${_formatDate(order.tanggal)}'),
                const SizedBox(height: 8),
                Text('Status: ${order.status}'),
                const SizedBox(height: 12),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.nama} x${item.jumlah}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'Rp ${FormatCurrency.toRupiah(item.subtotal)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Rp ${FormatCurrency.toRupiah(order.totalHarga)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                  ],
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
        );
      },
    );
  }

  void _showStatusChangeDialog(
      BuildContext context, Pesanan order, AdminProvider adminProv) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ubah Status Pesanan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Pending'),
                onTap: () async {
                  await adminProv.updateOrderStatus(order.id, 'pending');
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Completed'),
                onTap: () async {
                  await adminProv.updateOrderStatus(order.id, 'completed');
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Cancelled'),
                onTap: () async {
                  await adminProv.updateOrderStatus(order.id, 'cancelled');
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
