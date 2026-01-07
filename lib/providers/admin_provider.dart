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

  // Akses langsung ke daftar produk ( sudah bertipe List<Produk> )
  List<Produk> get produkList => produkProvider.listProduk;

  // Akses langsung ke daftar pesanan ( sudah bertipe List<Pesanan> )
  List<Pesanan> get pesananList => pesananProvider.semuaPesanan;

  // Getter untuk status loading dari masing-masing provider.
  bool get isProdukLoading => produkProvider.isLoading;
  bool get isPesananLoading => pesananProvider.isLoading;
}
