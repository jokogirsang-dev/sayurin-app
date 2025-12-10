// lib/providers/cart_provider.dart

import 'package:flutter/material.dart';
import '../model/produk.dart';

class CartProvider with ChangeNotifier {
  List<Produk> _items = [];

  List<Produk> get items => [..._items];

  int get totalItems => _items.length;

  void tambah(Produk produk) {
    final existingIndex = _items.indexWhere((item) => item.id == produk.id);
    if (existingIndex != -1) {
      // Item sudah ada, tambahkan jumlah
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(jumlah: existing.jumlah + 1);
    } else {
      // Item baru
      _items.add(Produk(
        id: produk.id,
        nama: produk.nama,
        harga: produk.harga,
        gambar: produk.gambar,
        stok: produk.stok,
        kategori: produk.kategori,
        jumlah: 1,
      ));
    }
    notifyListeners();
  }

  void hapus(Produk produk) {
    _items.removeWhere((item) => item.id == produk.id);
    notifyListeners();
  }

  void perbaruiJumlah(Produk produk, int newQty) {
    final index = _items.indexWhere((item) => item.id == produk.id);
    if (index != -1) {
      final item = _items[index];
      _items[index] = item.copyWith(jumlah: newQty);
      notifyListeners();
    }
  }

  double getTotal() {
    return _items.fold<double>(0, (sum, p) => sum + (p.harga * p.jumlah));
  }

  int getSelectedCount(Set<String> selectedIds) {
    return _items.where((item) => selectedIds.contains(item.id)).length;
  }

  double getSelectedTotal(Set<String> selectedIds) {
    return _items
        .where((item) => selectedIds.contains(item.id))
        .fold<double>(0, (sum, p) => sum + (p.harga * p.jumlah));
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}