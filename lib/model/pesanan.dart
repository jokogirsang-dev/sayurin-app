// lib/model/pesanan.dart

import 'produk.dart';

// ✅ Class PesananItem - untuk item di dalam pesanan
class PesananItem {
  final String id;
  final String nama;
  final double harga;
  final String gambar;
  final int jumlah;
  final String kategori;

  PesananItem({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.jumlah,
    required this.kategori,
  });

  // Factory dari Produk
  factory PesananItem.fromProduk(Produk produk) {
    return PesananItem(
      id: produk.id,
      nama: produk.nama,
      harga: produk.harga,
      gambar: produk.gambar,
      jumlah: produk.jumlah,
      kategori: produk.kategori,
    );
  }

  // Factory dari JSON
  factory PesananItem.fromJson(Map<String, dynamic> json) {
    return PesananItem(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      harga: _parseToDouble(json['harga'] ?? json['price'] ?? 0),
      gambar: json['gambar']?.toString() ?? json['image']?.toString() ?? '',
      jumlah: _parseToInt(json['jumlah'] ?? json['quantity'] ?? 1),
      kategori: json['kategori']?.toString() ?? json['category']?.toString() ?? 'Umum',
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseToInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'harga': harga,
      'gambar': gambar,
      'jumlah': jumlah,
      'kategori': kategori,
    };
  }

  // CopyWith
  PesananItem copyWith({
    String? id,
    String? nama,
    double? harga,
    String? gambar,
    int? jumlah,
    String? kategori,
  }) {
    return PesananItem(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
      gambar: gambar ?? this.gambar,
      jumlah: jumlah ?? this.jumlah,
      kategori: kategori ?? this.kategori,
    );
  }

  // Subtotal
  double get subtotal => harga * jumlah;
}

// ✅ Class Pesanan - untuk pesanan lengkap
class Pesanan {
  final String id;
  final DateTime tanggal;
  final List<PesananItem> items;
  final double totalHarga;
  final String status;

  Pesanan({
    required this.id,
    required this.tanggal,
    required this.items,
    required this.totalHarga,
    required this.status,
  });

  // ✅ Method copyWith
  Pesanan copyWith({
    String? id,
    DateTime? tanggal,
    List<PesananItem>? items,
    double? totalHarga,
    String? status,
  }) {
    return Pesanan(
      id: id ?? this.id,
      tanggal: tanggal ?? this.tanggal,
      items: items ?? this.items,
      totalHarga: totalHarga ?? this.totalHarga,
      status: status ?? this.status,
    );
  }

  // Factory constructor dari JSON
  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id']?.toString() ?? '',
      tanggal: json['tanggal'] != null 
          ? DateTime.parse(json['tanggal'])
          : DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => PesananItem.fromJson(item))
              .toList() ?? [],
      totalHarga: _parseToDouble(json['totalHarga'] ?? json['total_harga'] ?? 0),
      status: json['status']?.toString() ?? 'Diproses',
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
      'totalHarga': totalHarga,
      'status': status,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pesanan && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}