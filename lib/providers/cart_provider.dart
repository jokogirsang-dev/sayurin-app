import 'package:flutter/material.dart';
import '../model/produk.dart';

class CartProvider with ChangeNotifier {
  final List<Produk> _items = [];
  final Set<int> _favoriteIds = {};

  // ======================
  // GETTERS
  // ======================
  List<Produk> get items => List.unmodifiable(_items);
  int get totalItems => _items.length;
  int get itemCount => _items.length;
  Set<int> get favoriteIds => _favoriteIds;

  // ======================
  // FAVORITE (WISHLIST)
  // ======================
  bool isFavorite(int productId) {
    return _favoriteIds.contains(productId);
  }

  void toggleFavorite(int productId) {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  // ======================
  // ADD ITEM
  // ======================
  void tambah(Produk produk) {
    final index = _items.indexWhere((item) => item.id == produk.id);

    if (index != -1) {
      final existing = _items[index];
      _items[index] = existing.copyWith(
        jumlah: existing.jumlah + 1,
      );
    } else {
      _items.add(produk.copyWith(jumlah: 1));
    }
    notifyListeners();
  }

  // ======================
  // REMOVE ITEM
  // ======================
  void hapus(Produk produk) {
    _items.removeWhere((item) => item.id == produk.id);
    notifyListeners();
  }

  void hapusById(int productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  // ======================
  // UPDATE QUANTITY
  // ======================
  void perbaruiJumlah(Produk produk, int newQty) {
    if (newQty <= 0) {
      hapus(produk);
      return;
    }

    final index = _items.indexWhere((item) => item.id == produk.id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(jumlah: newQty);
      notifyListeners();
    }
  }

  void tambahJumlah(int productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      final item = _items[index];
      _items[index] = item.copyWith(jumlah: item.jumlah + 1);
      notifyListeners();
    }
  }

  void kurangiJumlah(int productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      final item = _items[index];
      if (item.jumlah > 1) {
        _items[index] = item.copyWith(jumlah: item.jumlah - 1);
        notifyListeners();
      } else {
        hapusById(productId);
      }
    }
  }

  // ======================
  // TOTAL & SUBTOTAL
  // ======================
  double getTotal() {
    return _items.fold<double>(
      0.0,
      (sum, item) => sum + item.subtotal,
    );
  }

  // ✅ METHOD YANG KAMU MINTA (FINAL & BENAR)
  double getSelectedTotal(Set<int> selectedIds) {
    return _items
        .where((item) => selectedIds.contains(item.id))
        .fold<double>(
          0.0,
          (sum, item) => sum + (item.harga * item.jumlah),
        );
  }

  int getSelectedCount(Set<int> selectedIds) {
    return _items.where((item) => selectedIds.contains(item.id)).length;
  }

  List<Produk> getSelectedItems(Set<int> selectedIds) {
    return _items.where((item) => selectedIds.contains(item.id)).toList();
  }

  // ======================
  // CLEAR CART
  // ======================
  void clear() {
    _items.clear();
    notifyListeners();
  }

  void clearSelected(Set<int> selectedIds) {
    _items.removeWhere((item) => selectedIds.contains(item.id));
    notifyListeners();
  }

  // ======================
  // CHECKS
  // ======================
  bool isEmpty() => _items.isEmpty;

  bool isInCart(int productId) {
    return _items.any((item) => item.id == productId);
  }

  int getProductQuantity(int productId) {
    try {
      return _items.firstWhere((item) => item.id == productId).jumlah;
    } catch (_) {
      return 0;
    }
  }
}
