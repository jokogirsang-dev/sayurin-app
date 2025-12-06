import 'produk.dart';

class Pesanan {
  final String id;                 // pakai String biar gampang
  final DateTime tanggal;
  final List<Produk> items;
  final double totalHarga;
  final String status;

  Pesanan({
    required this.id,
    required this.tanggal,
    required this.items,
    required this.totalHarga,
    this.status = 'Diproses',
  });
}
