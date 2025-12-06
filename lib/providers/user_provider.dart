import 'package:flutter/foundation.dart';
import '../model/user.dart';
import '../service/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service = UserService();

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  // LOGIN
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _currentUser = await _service.login(
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      // bisa kamu print kalau mau debug:
      // debugPrint('Login error: $e');
      return false;
    }
  }

  // REGISTER
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _currentUser = await _service.register(
        name: name,
        email: email,
        password: password,
      );
      notifyListeners();
      return true;
    } catch (e) {
      // debugPrint('Register error: $e');
      return false;
    }
  }

  // LOGOUT
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
