import 'package:flutter/material.dart';
import '../model/produk.dart';

class CartProvider extends ChangeNotifier {
  final List<Produk> _items = [];

  /// daftar produk di keranjang
  List<Produk> get items => List.unmodifiable(_items);

  /// jumlah item (dipakai untuk badge di icon keranjang)
  int get totalItems => _items.length;

  /// total harga semua produk di keranjang
  double get totalHarga => _items.fold(0.0, (sum, p) => sum + p.price);

  /// tambah produk ke keranjang
  void tambah(Produk p) {
    _items.add(p);
    notifyListeners();
  }

  /// hapus satu produk
  void remove(Produk p) {
    _items.remove(p);
    notifyListeners();
  }

  /// kosongkan keranjang
  void clear() {
    _items.clear();
    notifyListeners();
  }

  /// alias nama Indonesia yang dipakai di UI lama
  void kosongkanKeranjang() => clear();
}
