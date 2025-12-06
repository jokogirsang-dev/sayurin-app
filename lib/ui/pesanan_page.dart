import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pesanan_provider.dart';
import '../widget/sidebar.dart'; // kalau kamu pakai drawer

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pesananProv = Provider.of<PesananProvider>(context);

    return Scaffold(
      drawer: const AppSidebar(), // kalau pakai sidebar
      appBar: AppBar(
        title: const Text('Pesanan Saya'),
      ),
      body: pesananProv.semuaPesanan.isEmpty
          ? const Center(child: Text('Belum ada pesanan.'))
          : ListView.builder(
              itemCount: pesananProv.semuaPesanan.length,
              itemBuilder: (context, index) {
                final p = pesananProv.semuaPesanan[index];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      'Pesanan #${p.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${p.items.length} item • '
                      'Total Rp ${p.totalHarga.toStringAsFixed(0)}\n'
                      '${p.tanggal}',
                    ),
                    trailing: Text(
                      p.status,
                      style: const TextStyle(color: Colors.green),
                    ),
                    onTap: () {
                      // nanti kalau mau bisa dibikin detail pesanan
                    },
                  ),
                );
              },
            ),
    );
  }
}
