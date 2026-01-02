// lib/providers/pesanan_provider.dart

import 'package:flutter/foundation.dart';
import '../model/produk.dart';
import '../model/pesanan.dart';

class PesananProvider extends ChangeNotifier {
  final List<Pesanan> _pesanan = [];
  bool _loading = false;

  List<Pesanan> get semuaPesanan => List.unmodifiable(_pesanan);
  bool get loading => _loading;

  // ✅ Method tambahPesanan - FIXED dengan PesananItem
  void tambahPesanan({
    required List<Produk> items,
    required double totalHarga,
  }) {
    // ✅ Convert List<Produk> ke List<PesananItem>
    final pesananItems = items.map((produk) {
      return PesananItem.fromProduk(produk);
    }).toList();

    final pesananBaru = Pesanan(
      id: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
      tanggal: DateTime.now(),
      items: pesananItems, // ✅ Gunakan PesananItem, bukan Produk
      totalHarga: totalHarga,
      status:
          'Diproses', // ✅ Sesuai dengan tab: Diproses, Dikemas, Dikirim, Selesai
    );

    _pesanan.insert(0, pesananBaru); // Masuk paling atas (terbaru)
    // Debug log: show what order was created
    try {
      debugPrint(
          '[PesananProvider] tambahPesanan(): created order ${pesananBaru.id} with items: ' +
              pesananBaru.items
                  .map((i) => '${i.nama} x${i.jumlah}')
                  .join(', '));
      debugPrint(
          '[PesananProvider] totalHarga=${pesananBaru.totalHarga} status=${pesananBaru.status}');
    } catch (e) {
      debugPrint('[PesananProvider] tambahPesanan() debug error: $e');
    }

    notifyListeners();
  }

  // Fetch pesanan (simulasi)
  Future<void> fetchPesanan() async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Debug log: indicate fetch start and current orders
      debugPrint(
          '[PesananProvider] fetchPesanan(): starting - current count=${_pesanan.length}');

      // Simulasi: generate dummy data jika kosong
      if (_pesanan.isEmpty) {
        debugPrint(
            '[PesananProvider] fetchPesanan(): _pesanan empty - adding dummy orders');
        _pesanan.addAll([
          Pesanan(
            id: 'ORD-001',
            tanggal: DateTime.now().subtract(const Duration(days: 1)),
            items: [
              PesananItem(
                id: '1',
                nama: 'Sayur Bayam',
                harga: 5000,
                gambar: '',
                jumlah: 2,
                kategori: 'Sayuran',
              ),
            ],
            totalHarga: 10000,
            status: 'Selesai',
          ),
          Pesanan(
            id: 'ORD-002',
            tanggal: DateTime.now(),
            items: [
              PesananItem(
                id: '2',
                nama: 'Tomat Merah',
                harga: 8000,
                gambar: '',
                jumlah: 3,
                kategori: 'Sayuran',
              ),
            ],
            totalHarga: 24000,
            status: 'Diproses',
          ),
        ]);
      }
      debugPrint(
          '[PesananProvider] fetchPesanan(): finished - current count=${_pesanan.length}');
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  // Update status pesanan
  void updateStatus(String id, String statusBaru) {
    final index = _pesanan.indexWhere((p) => p.id == id);
    if (index != -1) {
      _pesanan[index] = _pesanan[index].copyWith(status: statusBaru);
      notifyListeners();
    }
  }

  // Hapus pesanan
  void hapusPesanan(String id) {
    _pesanan.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  // Get pesanan by ID
  Pesanan? getPesananById(String id) {
    try {
      return _pesanan.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get jumlah pesanan per status
  int getCountByStatus(String status) {
    return _pesanan.where((p) => p.status == status).length;
  }

  // Get total semua pesanan
  double getTotalPendapatan() {
    return _pesanan.fold(0.0, (sum, p) => sum + p.totalHarga);
  }

  // Get pesanan berdasarkan status
  List<Pesanan> getPesananByStatus(String status) {
    return _pesanan.where((p) => p.status == status).toList();
  }

  // Get total pesanan
  int get totalPesanan => _pesanan.length;

  // Clear all pesanan (untuk testing/reset)
  void clearAllPesanan() {
    _pesanan.clear();
    notifyListeners();
  }
}
