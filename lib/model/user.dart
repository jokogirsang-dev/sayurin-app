// lib/model/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin' atau 'user'

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  // Factory constructor dari JSON (jika pakai API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }

  // Helper untuk check role
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}