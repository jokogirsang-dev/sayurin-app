// lib/model/pesanan.dart

class Pesanan {
  final int id;
  final int userId; // Ditambahkan
  final double totalHarga;
  final DateTime tanggal;
  final String status;
  final List<PesananItem> items;

  Pesanan({
    required this.id,
    required this.userId, // Ditambahkan
    required this.totalHarga,
    required this.tanggal,
    required this.status,
    required this.items,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      totalHarga: (json['total_harga'] ?? 0).toDouble(),
      tanggal: DateTime.tryParse(json['tanggal'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'UNKNOWN',
      items: (json['items'] is List)
          ? (json['items'] as List).map((e) => PesananItem.fromJson(e)).toList()
          : [],
    );
  }

  // Metode copyWith yang hilang, sekarang ditambahkan
  Pesanan copyWith({
    int? id,
    int? userId,
    double? totalHarga,
    DateTime? tanggal,
    String? status,
    List<PesananItem>? items,
  }) {
    return Pesanan(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalHarga: totalHarga ?? this.totalHarga,
      tanggal: tanggal ?? this.tanggal,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }
}

// =======================================================
// MODEL ITEM PESANAN
// =======================================================

class PesananItem {
  final int produkId; // Ditambahkan
  final String namaProduk; // Diganti dari 'nama'
  final int jumlah;
  final double harga;
  final String gambar;

  PesananItem({
    required this.produkId, // Ditambahkan
    required this.namaProduk, // Diganti dari 'nama'
    required this.jumlah,
    required this.harga,
    required this.gambar,
  });

  factory PesananItem.fromJson(Map<String, dynamic> json) {
    return PesananItem(
      produkId: json['produk_id'] ?? 0, // Ditambahkan
      namaProduk: json['nama_produk'] ?? json['nama'] ?? '', // Diperbarui
      jumlah: json['jumlah'] ?? 0,
      harga: (json['harga'] ?? 0).toDouble(),
      gambar: json['gambar'] ?? '',
    );
  }
}
