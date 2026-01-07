// lib/model/user.dart

class User {
  final int id;
  final String name;
  final String email;
  final String role; // 'admin' atau 'user'
  final String alamat;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.alamat = '',
  });

  // Factory constructor dari JSON (jika pakai API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      alamat: json['alamat'] ?? '',
    );
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'alamat': alamat,
    };
  }

  // Create a copy with modified fields
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? alamat,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      alamat: alamat ?? this.alamat,
    );
  }

  // Helper untuk check role
  bool get isAdmin => role == 'admin';
  bool get isUser => role == 'user';
}
