import 'package:flutter/material.dart';
import '../service/pesanan_service.dart';
import '../model/pesanan.dart';
import '../helpers/format_currency.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({super.key});

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late Future<List<Pesanan>> _future;

  @override
  void initState() {
    super.initState();
    _future = PesananService().listOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Penjualan'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: FutureBuilder<List<Pesanan>>(
        future: _future,
        builder: (context, snap) {
          // 🔹 Loading
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 🔹 Error
          if (snap.hasError) {
            return Center(
              child: Text(
                'Gagal memuat laporan\n${snap.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final list = snap.data ?? [];

          // 🔹 Data kosong
          if (list.isEmpty) {
            return const Center(
              child: Text('Belum ada data penjualan'),
            );
          }

          // 🔹 Total penjualan
          final total = list.fold<double>(0, (sum, p) => sum + p.totalHarga);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOTAL
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Penjualan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        FormatCurrency.toRupiah(total),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // LIST LAPORAN
                Expanded(
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final p = list[i];
                      return ListTile(
                        leading: const Icon(Icons.receipt_long),
                        title: Text(
                          'Order #${p.id}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${_formatDate(p.tanggal)}\n'
                          'Rp ${FormatCurrency.toRupiah(p.totalHarga)}',
                        ),
                        trailing: Text(
                          p.status,
                          style: TextStyle(
                            color: _statusColor(p.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===================== HELPERS =====================

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
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
}
I