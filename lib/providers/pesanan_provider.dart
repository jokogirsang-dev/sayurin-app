import 'package:flutter/foundation.dart';
import '../model/produk.dart';
import '../model/pesanan.dart';

class PesananProvider extends ChangeNotifier {
  final List<Pesanan> _pesanan = [];

  List<Pesanan> get semuaPesanan => List.unmodifiable(_pesanan);

  void tambahPesanan({
    required List<Produk> items,
    required double totalHarga,
  }) {
    final pesananBaru = Pesanan(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tanggal: DateTime.now(),
      items: List<Produk>.from(items),
      totalHarga: totalHarga,
      status: 'Diproses',
    );

    _pesanan.insert(0, pesananBaru); // masuk paling atas
    notifyListeners();
  }

  void updateStatus(String id, String statusBaru) {
    final index = _pesanan.indexWhere((p) => p.id == id);
    if (index != -1) {
      final p = _pesanan[index];
      _pesanan[index] = Pesanan(
        id: p.id,
        tanggal: p.tanggal,
        items: p.items,
        totalHarga: p.totalHarga,
        status: statusBaru,
      );
      notifyListeners();
    }
  }
}
