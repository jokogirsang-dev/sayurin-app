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

      produkList =
          await _service.fetchProduk(); // atau getProduk() tergantung service
    } catch (e) {
      error = "Gagal memuat produk";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
