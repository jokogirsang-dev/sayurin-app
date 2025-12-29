import 'package:flutter/material.dart';
import '../model/produk.dart';
import '../service/produk_service.dart';

class ProdukProvider extends ChangeNotifier {
  final ProdukService _service = ProdukService();

  bool isLoading = false;
  String? error;
  List<Produk> produkList = [];

  // kompatibilitas: getter yang dipanggil UI
  List<Produk> get listProduk => produkList;

  Future<void> fetchProduk() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      produkList = await _service.fetchProduk();

      // Tambah dummy data jika kosong (untuk testing)
      if (produkList.isEmpty) {
        produkList = [
          Produk(
            id: '1',
            nama: 'Sayur Bayam',
            harga: 5000,
            gambar: 'https://via.placeholder.com/150',
            stok: 20,
            kategori: 'Sayuran',
          ),
          Produk(
            id: '2',
            nama: 'Tomat Merah',
            harga: 8000,
            gambar: 'https://via.placeholder.com/150',
            stok: 15,
            kategori: 'Sayuran',
          ),
          Produk(
            id: '3',
            nama: 'Cabai Merah',
            harga: 12000,
            gambar: 'https://via.placeholder.com/150',
            stok: 3,
            kategori: 'Bumbu',
          ),
          Produk(
            id: '4',
            nama: 'Andaliman',
            harga: 25000,
            gambar: 'https://via.placeholder.com/150',
            stok: 10,
            kategori: 'Bumbu',
          ),
          Produk(
            id: '5',
            nama: 'Rias Sihala',
            harga: 20000,
            gambar: 'https://via.placeholder.com/150',
            stok: 8,
            kategori: 'Bumbu',
          ),
        ];
      }
    } catch (e) {
      error = "Gagal memuat produk";
      // Load dummy data jika fetch error
      produkList = [
        Produk(
          id: '1',
          nama: 'Sayur Bayam',
          harga: 5000,
          gambar: 'https://via.placeholder.com/150',
          stok: 20,
          kategori: 'Sayuran',
        ),
        Produk(
          id: '2',
          nama: 'Tomat Merah',
          harga: 8000,
          gambar: 'https://via.placeholder.com/150',
          stok: 15,
          kategori: 'Sayuran',
        ),
        Produk(
          id: '3',
          nama: 'Cabai Merah',
          harga: 12000,
          gambar: 'https://via.placeholder.com/150',
          stok: 3,
          kategori: 'Bumbu',
        ),
        Produk(
          id: '4',
          nama: 'Andaliman',
          harga: 25000,
          gambar: 'https://via.placeholder.com/150',
          stok: 10,
          kategori: 'Bumbu',
        ),
        Produk(
          id: '5',
          nama: 'Rias Sihala',
          harga: 20000,
          gambar: 'https://via.placeholder.com/150',
          stok: 8,
          kategori: 'Bumbu',
        ),
      ];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
