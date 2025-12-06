// helpers/format_currency.dart
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
