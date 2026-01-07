import 'package:flutter/material.dart';
import '../model/produk.dart'; // Import model Produk

class ProdukProvider with ChangeNotifier {
  // Gunakan List<Produk> untuk type safety
  List<Produk> _listProduk = [];
  bool _isLoading = false;
  String? _error; // Tambahkan state untuk error message

  // Ganti nama getter agar lebih sesuai
  List<Produk> get listProduk => _listProduk;
  bool get isLoading => _isLoading;
  String? get error => _error; // Getter untuk error

  // fetchProduk yang sudah diperbaiki dengan data dummy dan error handling
  Future<void> fetchProduk() async {
    _isLoading = true;
    _error = null; // Reset error setiap kali fetch dimulai
    notifyListeners();

    try {
      // Simulasi panggilan API dengan delay 2 detik
      await Future.delayed(const Duration(seconds: 2));

      // ===== CONTOH JIKA API GAGAL =====
      // Untuk mengetes skenario error, hapus komentar pada baris di bawah ini:
      // throw Exception('Gagal terhubung ke server. Silakan coba lagi.');

      // Data dummy untuk ditampilkan di UI
      final List<Map<String, dynamic>> dummyData = [
        {
          'id': '1',
          'nama': 'Andaliman',
          'harga': 25000,
          'gambar':
              'https://via.placeholder.com/150/FFC107/000000?Text=Andaliman',
          'stok': 50,
          'kategori': 'Bumbu',
          'deskripsi':
              'Merica batak yang khas, memberikan sensasi getir di lidah.',
        },
        {
          'id': '2',
          'nama': 'Daun Kunyit',
          'harga': 5000,
          'gambar':
              'https://via.placeholder.com/150/4CAF50/FFFFFF?Text=Daun+Kunyit',
          'stok': 100,
          'kategori': 'Sayur',
          'deskripsi': 'Daun kunyit segar untuk menambah aroma masakan Anda.',
        },
        {
          'id': '3',
          'nama': 'Bawang Batak',
          'harga': 15000,
          'gambar':
              'https://via.placeholder.com/150/8BC34A/FFFFFF?Text=Bawang+Batak',
          'stok': 80,
          'kategori': 'Bumbu',
          'deskripsi':
              'Bawang batak atau lokio, cocok untuk arsik dan masakan lainnya.',
        },
        {
          'id': '4',
          'nama': 'Sihala',
          'harga': 12000,
          'gambar': 'https://via.placeholder.com/150/F44336/FFFFFF?Text=Sihala',
          'stok': 30,
          'kategori': 'Bumbu',
          'deskripsi': 'Buah khas Tapanuli yang asam dan segar.',
        },
        {
          'id': '5',
          'nama': 'Jeruk Manis',
          'harga': 20000,
          'gambar':
              'https://via.placeholder.com/150/FF9800/FFFFFF?Text=Jeruk+Manis',
          'stok': 120,
          'kategori': 'Buah',
          'deskripsi': 'Jeruk manis hasil panen dari kebun Simalungun.',
        },
        {
          'id': '6',
          'nama': 'Tomat Merah',
          'harga': 18000,
          'gambar':
              'https://via.placeholder.com/150/E91E63/FFFFFF?Text=Tomat+Merah',
          'stok': 200,
          'kategori': 'Sayur',
          'deskripsi': 'Tomat merah segar, kaya vitamin dan antioksidan.',
        },
        {
          'id': '7',
          'nama': 'Cabai Rawit',
          'harga': 45000,
          'gambar':
              'https://via.placeholder.com/150/D32F2F/FFFFFF?Text=Cabai+Rawit',
          'stok': 60,
          'kategori': 'Bumbu',
          'deskripsi': 'Cabai rawit super pedas untuk sambal andalan.',
        },
        {
          'id': '8',
          'nama': 'Kangkung',
          'harga': 3000,
          'gambar':
              'https://via.placeholder.com/150/388E3C/FFFFFF?Text=Kangkung',
          'stok': 150,
          'kategori': 'Sayur',
          'deskripsi': 'Kangkung segar, cocok untuk ditumis.',
        }
      ];

      // Parsing data dummy menjadi List<Produk>
      _listProduk = dummyData.map((json) => Produk.fromJson(json)).toList();
    } catch (e) {
      // Jika terjadi error, simpan pesan error
      _error = e.toString();
    } finally {
      // Apapun hasilnya, set _isLoading menjadi false
      _isLoading = false;
      notifyListeners();
    }
  }

  // ================= METODE UNTUK ADMIN =================

  /// Menambah produk baru ke daftar.
  /// Dipanggil oleh [AdminProvider].
  Future<void> tambahProduk({
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
    String deskripsi = 'Deskripsi belum tersedia.',
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulasi API call

    final produkBaru = Produk(
      id: DateTime.now().millisecondsSinceEpoch, // ID unik sementara
      nama: nama,
      harga: harga,
      gambar: gambar,
      stok: stok,
      kategori: kategori,
      deskripsi: deskripsi,
    );

    _listProduk.insert(0, produkBaru);
    _isLoading = false;
    notifyListeners();
  }

  /// Mengedit data produk yang sudah ada berdasarkan ID.
  /// Dipanggil oleh [AdminProvider].
  Future<void> editProduk({
    required int id,
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
    String? deskripsi,
  }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulasi API call

    final index = _listProduk.indexWhere((p) => p.id == id);
    if (index != -1) {
      final produkLama = _listProduk[index];
      _listProduk[index] = produkLama.copyWith(
        nama: nama,
        harga: harga,
        gambar: gambar,
        stok: stok,
        kategori: kategori,
        deskripsi: deskripsi ?? produkLama.deskripsi,
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Menghapus produk dari daftar berdasarkan ID.
  /// Dipanggil oleh [AdminProvider].
  Future<void> hapusProduk(int id) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulasi API call

    _listProduk.removeWhere((p) => p.id == id);

    _isLoading = false;
    notifyListeners();
  }

  /// Memperbarui jumlah stok produk berdasarkan ID.
  /// Jika `notify` false, tidak akan memanggil notifyListeners (digunakan saat batch update)
  Future<void> updateStock(int id, int stokBaru, {bool notify = true}) async {
    final index = _listProduk.indexWhere((p) => p.id == id);
    if (index != -1) {
      _listProduk[index] = _listProduk[index].copyWith(stok: stokBaru);
      if (notify) notifyListeners();
    }
  }

  /// Memperbarui banyak stok sekaligus, hanya memanggil notifyListeners sekali.
  Future<void> updateStocks(Map<int, int> updates) async {
    var changed = false;
    for (final entry in updates.entries) {
      final index = _listProduk.indexWhere((p) => p.id == entry.key);
      if (index != -1) {
        _listProduk[index] = _listProduk[index].copyWith(stok: entry.value);
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }
}
