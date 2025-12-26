import 'package:flutter/foundation.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _loading = false;

  // ======================
  // GETTERS
  // ======================
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';
  bool get isUser => _currentUser?.role == 'user';
  bool get loading => _loading;

  int? get userId => _currentUser?.id;
  String get name => _currentUser?.name ?? 'User'; // ✅ FIX ERROR
  String get userEmail => _currentUser?.email ?? '';
  String get userRole => _currentUser?.role ?? 'user';

  // ======================
  // LOGIN (SIMULASI)
  // ======================
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));

      // 👑 DEMO ADMIN
      if (email == 'admin@hortasima.com' && password == '12345') {
        _currentUser = User(
          id: 1,
          name: 'Admin Hortasima',
          email: email,
          role: 'admin',
        );
      }
      // 🛒 DEMO USER
      else if (email == 'jokog@gmail.com' && password == '12345') {
        _currentUser = User(
          id: 2,
          name: 'Joko',
          email: email,
          role: 'user',
        );
      } else {
        throw Exception('Login gagal');
      }

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _currentUser = null;
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ======================
  // REGISTER (DARI SEBELUMNYA)
  // ======================
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _loading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2));

      _loading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  // ======================
  // LOGOUT
  // ======================
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
