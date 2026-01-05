import 'package:flutter/material.dart';
import 'produk_provider.dart';
import 'pesanan_provider.dart';
import '../model/produk.dart'; // Asumsi impor model Produk
import '../model/pesanan.dart'; // Asumsi impor model Pesanan

class AdminProvider with ChangeNotifier {
  final ProdukProvider produkProvider;
  final PesananProvider pesananProvider;

  AdminProvider({
    required this.produkProvider,
    required this.pesananProvider,
  });

  // ================= PRODUK =================

  Future<bool> tambahProduk({
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
  }) async {
    try {
      await produkProvider.tambahProduk(
        nama: nama,
        harga: harga,
        gambar: gambar,
        stok: stok,
        kategori: kategori,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error tambah produk: $e');
      return false;
    }
  }

  Future<bool> editProduk({
    required int id,
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
  }) async {
    try {
      await produkProvider.editProduk(
        id: id,
        nama: nama,
        harga: harga,
        gambar: gambar,
        stok: stok,
        kategori: kategori,
      );
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error edit produk: $e');
      return false;
    }
  }

  Future<bool> hapusProduk(int id) async {
    try {
      await produkProvider.hapusProduk(id);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error hapus produk: $e');
      return false;
    }
  }

  Future<bool> updateStock(int id, int stokBaru) async {
    try {
      await produkProvider.updateStock(id, stokBaru);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error update stock: $e');
      return false;
    }
  }

  // ================= PESANAN =================

  Future<void> loadOrders() async {
    try {
      await pesananProvider.fetchPesanan();
      notifyListeners();
    } catch (e) {
      debugPrint('Error load orders: $e');
    }
  }

  Future<bool> updateStatus(int orderId, String statusBaru) async {
    try {
      await pesananProvider.updateStatus(orderId, statusBaru);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error update status: $e');
      return false;
    }
  }

  // ================= GETTER HELPERS =================
  
  // Akses mudah ke produk list dari ProdukProvider.
  // Getter ini mengubah List<dynamic> menjadi List<Produk> yang type-safe.
  List<Produk> get produkList {
    // Pengecekan `== null` tidak lagi diperlukan karena provider 
    // menginisialisasi list sebagai list kosong `[]`.
    return produkProvider.listProduk
        .map((item) => Produk.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  
  // Akses mudah ke pesanan list dari PesananProvider.
  // Getter ini mengubah List<dynamic> menjadi List<Pesanan> yang type-safe.
  List<Pesanan> get pesananList {
    // Menggunakan getter 'semuaPesanan' dari PesananProvider yang sudah diperbaiki.
    final dataPesanan = pesananProvider.semuaPesanan;
    // Pengecekan `== null` juga tidak diperlukan di sini.
    return dataPesanan
        .map((item) => Pesanan.fromJson(item as Map<String, dynamic>))
        .toList();
  }
  
  // Getter untuk status loading dari masing-masing provider.
  bool get isProdukLoading => produkProvider.isLoading;
  bool get isPesananLoading => pesananProvider.isLoading;
}