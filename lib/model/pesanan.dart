// lib/model/pesanan.dart

class Pesanan {
  final String id; // 🔴 ID sebaiknya String (aman utk API)
  final double totalHarga;
  final DateTime tanggal;
  final String status;
  final List<PesananItem> items; // 🔴 WAJIB ADA (dipakai di UI)

  Pesanan({
    required this.id,
    required this.totalHarga,
    required this.tanggal,
    required this.status,
    required this.items,
  });

  factory Pesanan.fromJson(Map<String, dynamic> json) {
    return Pesanan(
      id: json['id']?.toString() ?? '',
      totalHarga: (json['total_harga'] ?? 0).toDouble(),
      tanggal: DateTime.tryParse(json['tanggal'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'UNKNOWN',
      items: (json['items'] is List)
          ? (json['items'] as List)
              .map((e) => PesananItem.fromJson(e))
              .toList()
          : [], // 🔥 FIX UTAMA (ANTI NULL)
    );
  }
}

// =======================================================
// MODEL ITEM PESANAN
// =======================================================

class PesananItem {
  final String nama;
  final int jumlah;
  final double harga;
  final String gambar;

  PesananItem({
    required this.nama,
    required this.jumlah,
    required this.harga,
    required this.gambar,
  });

  factory PesananItem.fromJson(Map<String, dynamic> json) {
    return PesananItem(
      nama: json['nama'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      harga: (json['harga'] ?? 0).toDouble(),
      gambar: json['gambar'] ?? '',
    );
  }
}
