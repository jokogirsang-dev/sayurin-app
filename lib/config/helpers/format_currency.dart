// Helper Format Rupiah
// Pertemuan 8 & 12 - Digunakan untuk menampilkan harga dan total penjualan

import 'package:intl/intl.dart';

class FormatCurrency {
  static String toRupiah(double value) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
