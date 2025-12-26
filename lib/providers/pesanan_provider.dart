// lib/providers/pesanan_provider.dart

import 'package:flutter/foundation.dart';
import '../model/produk.dart';
import '../model/pesanan.dart';

class PesananProvider extends ChangeNotifier {
  final List<Pesanan> _pesanan = [];

  List<Pesanan> get semuaPesanan => List.unmodifiable(_pesanan);

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
      status: 'Diproses', // Status awal setelah bayar
    );

    _pesanan.insert(0, pesananBaru); // Masuk paling atas (terbaru)
    notifyListeners();
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