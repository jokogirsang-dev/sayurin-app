import 'package:flutter/foundation.dart';
import '../model/produk.dart';
import '../model/pesanan.dart';

class AdminProvider extends ChangeNotifier {
  final List<Produk> _products = [];
  final List<Pesanan> _orders = [];
  bool _loading = false;
  String _selectedTab =
      'dashboard'; // dashboard, products, orders, stock, reports, analytics

  // ==================== GETTERS ====================
  List<Produk> get products => List.unmodifiable(_products);
  List<Pesanan> get orders => List.unmodifiable(_orders);
  bool get loading => _loading;
  String get selectedTab => _selectedTab;

  int get totalProducts => _products.length;
  int get totalOrders => _orders.length;

  double get totalRevenue => _orders.fold<double>(
        0,
        (sum, order) => sum + order.totalHarga,
      );

  int get totalOrdersCompleted =>
      _orders.where((o) => o.status == 'completed').length;
  int get totalOrdersPending =>
      _orders.where((o) => o.status == 'pending').length;

  // ==================== PRODUCT MANAGEMENT ====================

  /// Add produk without async (for initialization)
  void addProductToAdmin({
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
  }) {
    final newProduct = Produk(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nama: nama,
      harga: harga,
      gambar: gambar,
      stok: stok,
      kategori: kategori,
    );
    _products.add(newProduct);
    notifyListeners();
  }

  /// Add produk baru
  Future<bool> addProduct({
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final newProduct = Produk(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nama: nama,
        harga: harga,
        gambar: gambar,
        stok: stok,
        kategori: kategori,
      );

      _products.add(newProduct);
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Edit produk
  Future<bool> editProduct({
    required String id,
    required String nama,
    required double harga,
    required String gambar,
    required int stok,
    required String kategori,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = Produk(
          id: id,
          nama: nama,
          harga: harga,
          gambar: gambar,
          stok: stok,
          kategori: kategori,
        );
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete produk
  Future<bool> deleteProduct(String id) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _products.removeWhere((p) => p.id == id);

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update stok produk
  Future<bool> updateStock(String productId, int newStock) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final product = _products[index];
        _products[index] = product.copyWith(stok: newStock);
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get produk by id
  Produk? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // ==================== ORDER MANAGEMENT ====================

  /// Load orders (simulasi dari pesanan_service)
  Future<void> loadOrders(List<Pesanan> orders) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _orders.clear();
      _orders.addAll(orders);
      _loading = false;
      notifyListeners();
    } catch (e) {
      _loading = false;
      notifyListeners();
    }
  }

  /// Update order status
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final order = _orders[index];
        _orders[index] = order.copyWith(status: newStatus);
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ==================== TAB MANAGEMENT ====================

  void selectTab(String tabName) {
    _selectedTab = tabName;
    notifyListeners();
  }

  // ==================== SEARCH & FILTER ====================

  List<Produk> searchProducts(String query) {
    if (query.isEmpty) return products;
    return products
        .where((p) =>
            p.nama.toLowerCase().contains(query.toLowerCase()) ||
            p.kategori.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Pesanan> filterOrders(String status) {
    if (status.isEmpty) return orders;
    return orders.where((o) => o.status == status).toList();
  }

  // ==================== ANALYTICS ====================

  Map<String, dynamic> getAnalytics() {
    return {
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      'completedOrders': totalOrdersCompleted,
      'pendingOrders': totalOrdersPending,
      'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
      'lowStockProducts': _products.where((p) => p.stok < 5).toList(),
    };
  }

  Map<String, int> getProductsByCategory() {
    final Map<String, int> categoryCount = {};
    for (var product in _products) {
      categoryCount[product.kategori] =
          (categoryCount[product.kategori] ?? 0) + 1;
    }
    return categoryCount;
  }
}
