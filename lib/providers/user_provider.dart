import 'package:flutter/foundation.dart';
import '../model/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;
  bool _loading = false;

  // Demo user list for admin management (analytics)
  List<User> _allUsers = [
    User(
        id: 1,
        name: 'Admin Hortasima',
        email: 'admin@hortasima.com',
        role: 'admin',
        alamat: 'Jl. Kebon Raya No.1'),
    User(
        id: 2,
        name: 'Joko',
        email: 'jokog@gmail.com',
        role: 'user',
        alamat: ''),
    User(
        id: 3,
        name: 'Siti',
        email: 'siti@example.com',
        role: 'user',
        alamat: ''),
  ];

  List<User> get allUsers => _allUsers;
  int get totalUsers => _allUsers.length;

  /// Simulated fetch for users (in real app call API)
  Future<void> fetchUsers() async {
    _loading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 400));
    // For demo we already have _allUsers, but we call notify to refresh listeners
    _loading = false;
    notifyListeners();
  }

  /// Toggle admin/user role for a user
  Future<void> toggleAdmin(int userId) async {
    final idx = _allUsers.indexWhere((u) => u.id == userId);
    if (idx == -1) return;
    final current = _allUsers[idx];
    final newRole = current.role == 'admin' ? 'user' : 'admin';
    _allUsers[idx] = User(
      id: current.id,
      name: current.name,
      email: current.email,
      role: newRole,
      alamat: current.alamat,
    );
    // If the current logged-in user was changed, update _currentUser
    if (_currentUser?.id == userId) _currentUser = _allUsers[idx];
    notifyListeners();
  }

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
  String get userAlamat => _currentUser?.alamat ?? '';

  // ======================
  // UPDATE PROFILE
  // ======================
  void updateProfile({String? name, String? email, String? alamat}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      email: email,
      alamat: alamat,
    );

    // update in _allUsers if exists
    final idx = _allUsers.indexWhere((u) => u.id == _currentUser!.id);
    if (idx != -1) _allUsers[idx] = _currentUser!;

    notifyListeners();
  }

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
          alamat: 'Jl. Kebon Raya No.1',
        );
      }
      // 🛒 DEMO USER
      else if (email == 'jokog@gmail.com' && password == '12345') {
        _currentUser = User(
          id: 2,
          name: 'Joko',
          email: email,
          role: 'user',
          alamat: '',
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
