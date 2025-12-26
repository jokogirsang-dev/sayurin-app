// lib/model/produk.dart

class Produk {
  final String id;
  final String nama;
  final double harga;
  final String gambar;
  final int stok;
  final String kategori;
  final int jumlah;

  // Alias untuk compatibility dengan API bahasa Inggris
  String get name => nama;
  String get image => gambar;
  double get price => harga;
  String get description => kategori;

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.stok,
    required this.kategori,
    this.jumlah = 1,
  });

  // Factory constructor untuk parsing dari JSON (API)
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id']?.toString() ?? '',
      nama: json['name']?.toString() ?? json['nama']?.toString() ?? '',
      harga: _parseToDouble(json['price'] ?? json['harga'] ?? 0),
      gambar: json['image']?.toString() ?? json['gambar']?.toString() ?? '',
      stok: _parseToInt(json['stok'] ?? json['stock'] ?? 0),
      kategori: json['kategori']?.toString() ?? 
                json['category']?.toString() ?? 
                json['description']?.toString() ?? 
                'Umum',
      jumlah: _parseToInt(json['jumlah'] ?? 1),
    );
  }

  // Helper untuk convert ke double
  static double _parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper untuk convert ke int
  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Convert ke JSON untuk kirim ke API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nama,
      'price': harga,
      'image': gambar,
      'stock': stok,
      'category': kategori,
      'jumlah': jumlah,
    };
  }

  // Method copyWith untuk update data
  Produk copyWith({
    String? id,
    String? nama,
    double? harga,
    String? gambar,
    int? stok,
    String? kategori,
    int? jumlah,
  }) {
    return Produk(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      gambar: gambar ?? this.gambar,
      stok: stok ?? this.stok,
      kategori: kategori ?? this.kategori,
      jumlah: jumlah ?? this.jumlah,
    );
  }

  // Helper untuk calculate subtotal (return double)
  double get subtotal => harga * jumlah;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Produk && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}