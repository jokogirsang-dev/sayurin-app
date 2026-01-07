import 'dart:async';
import 'package:flutter/material.dart';
import '../model/pesanan.dart';
import '../model/produk.dart';

class PesananProvider with ChangeNotifier {
  List<Pesanan> _semuaPesanan = [];
  bool _isLoading = false;

  // Stream untuk broadcast update status pesanan agar UI user dapat mendengarnya
  final StreamController<Map<String, dynamic>> _statusUpdates =
      StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get statusUpdates => _statusUpdates.stream;

  List<Pesanan> get semuaPesanan => _semuaPesanan;
  bool get isLoading => _isLoading;

  /// ================= FETCH PESANAN =================
  Future<void> fetchPesanan() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    final List<Map<String, dynamic>> dummyData = [
      {
        'id': 1,
        'user_id': 1,
        'tanggal': DateTime.now().toIso8601String(),
        'total_harga': 75000,
        'status': 'Diproses',
        'items': [
          {'produk_id': 1, 'nama_produk': 'Bayam', 'harga': 5000, 'jumlah': 3},
        ]
      },
      {
        'id': 2,
        'user_id': 2,
        'tanggal':
            DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'total_harga': 120000,
        'status': 'Selesai',
        'items': [
          {'produk_id': 2, 'nama_produk': 'Wortel', 'harga': 8000, 'jumlah': 5},
          {
            'produk_id': 3,
            'nama_produk': 'Kangkung',
            'harga': 4000,
            'jumlah': 10
          },
        ]
      }
    ];

    // Convert dummy data to model list
    final fetched = dummyData.map((data) => Pesanan.fromJson(data)).toList();

    // If we have no orders yet (fresh app), set fetched as initial data.
    // Otherwise merge new fetched orders (avoid overwriting runtime orders created during session).
    if (_semuaPesanan.isEmpty) {
      _semuaPesanan = fetched;
    } else {
      final existingIds = _semuaPesanan.map((e) => e.id).toSet();
      for (final p in fetched) {
        if (!existingIds.contains(p.id)) _semuaPesanan.add(p);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ================= TAMBAH PESANAN =================
  Future<void> tambahPesanan({
    required int userId, // ✅ ambil dari login
    required List<Produk> items,
    required double totalHarga,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final pesananItems = items
        .map((produk) => PesananItem(
              produkId: produk.id,
              namaProduk: produk.nama,
              harga: produk.harga,
              jumlah: produk.jumlah,
              gambar: produk.gambar,
            ))
        .toList();

    final pesananBaru = Pesanan(
      id: DateTime.now().millisecondsSinceEpoch, // ✅ INT ID
      userId: userId, // ✅ INT userId
      tanggal: DateTime.now(),
      totalHarga: totalHarga,
      status: 'Diproses',
      items: pesananItems,
    );

    _semuaPesanan.insert(0, pesananBaru);
    notifyListeners();
  }

  /// ================= UPDATE STATUS =================
  Future<void> updateStatus(int orderId, String statusBaru) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));

    final index = _semuaPesanan.indexWhere((p) => p.id == orderId);
    if (index != -1) {
      _semuaPesanan[index] = _semuaPesanan[index].copyWith(status: statusBaru);

      // Emit event update agar UI pengguna(tersangkut) bisa menampilkan notifikasi
      try {
        _statusUpdates.add({
          'orderId': orderId,
          'status': statusBaru,
          'userId': _semuaPesanan[index].userId,
        });
      } catch (_) {}
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    try {
      _statusUpdates.close();
    } catch (_) {}
    super.dispose();
  }
}
