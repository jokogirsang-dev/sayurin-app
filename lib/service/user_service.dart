import 'dart:async';
import '../model/user.dart';

class UserService {
  // Simulasi login - data hardcoded
  Future<User> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@hortasima.com' && password == '12345') {
      return User(
        id: 1,
        name: 'Admin hortasima',
        email: email,
        role: 'admin',
      );
    } else if (email == 'Jokog@gmail.com' && password == '12345') {
      return User(
        id: 2,
        name: 'Pembeli Sayur',
        email: email,
        role: 'user',
      );
    } else {
      throw Exception('Email atau password salah');
    }
  }

  // Simulasi register
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return User(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      email: email,
      role: 'user',
    );
  }
}
