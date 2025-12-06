// lib/model/produk.dart

class Produk {
  final String id;
  final String name;
  final double price;
  final String image;
  final int stok;
  final String kategori;
  final String description; // opsional, dari API bisa kosong

  Produk({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stok,
    required this.kategori,
    required this.description,
  });

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'].toString(), // MockAPI kirim id string
      name: json['name'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String? ?? '',
      stok: (json['stok'] as num?)?.toInt() ?? 0,
      kategori: json['kategori'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

  

  // Compatibility getters (Indonesian names used in UI)
  String get nama => name;
  double get harga => price;
  String get gambar => image;
Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'stok': stok,
      'kategori': kategori,
      'description': description,
    };
  }
}
