// lib/model/produk.dart

class Produk {
  final String id;
  final String nama;
  final double harga;
  final String gambar;
  final int stok;
  final String kategori;
  int jumlah;

  // Getter alias untuk kompatibilitas
  String get name => nama;
  String get image => gambar;
  double get price => harga;
  String get description => "Deskripsi produk $nama"; // Anda bisa ubah ini sesuai kebutuhan

  Produk({
    required this.id,
    required this.nama,
    required this.harga,
    required this.gambar,
    required this.stok,
    required this.kategori,
    this.jumlah = 1,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] as String,
      nama: json['nama'] as String,
      harga: json['harga'] is int ? (json['harga'] as int).toDouble() : (json['harga'] as double),
      gambar: json['gambar'] as String,
      stok: json['stok'] as int,
      kategori: json['kategori'] as String,
      jumlah: 1,
    );
  }

  Produk copyWith({int? jumlah}) {
    return Produk(
      id: id,
      nama: nama,
      harga: harga,
      gambar: gambar,
      stok: stok,
      kategori: kategori,
      jumlah: jumlah ?? this.jumlah,
    );
  }
}