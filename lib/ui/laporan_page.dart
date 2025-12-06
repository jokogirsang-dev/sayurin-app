// Pertemuan 12 - Laporan sederhana (penjualan)

import 'package:flutter/material.dart';
import '../service/pesanan_service.dart';
import '../model/pesanan.dart';

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
      appBar: AppBar(title: const Text('Laporan Penjualan')),
      body: FutureBuilder<List<Pesanan>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data ?? [];
          // 🔹 pakai totalHarga, bukan total
          final total =
              list.fold<double>(0, (sum, p) => sum + p.totalHarga);

          return Padding(
            padding: const EdgeInsets.all(12), // EdgeInsets ✅
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Penjualan: Rp ${total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final p = list[i];
                      final tanggalStr =
                          '${p.tanggal.year}-${p.tanggal.month.toString().padLeft(2, '0')}-${p.tanggal.day.toString().padLeft(2, '0')}';
                      return ListTile(
                        title: Text('Order #${p.id}'),
                        subtitle: Text(
                          'Rp ${p.totalHarga.toStringAsFixed(0)}\n'
                          '$tanggalStr',
                        ),
                        trailing: Text(
                          p.status,
                          style: const TextStyle(color: Colors.green),
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
}
