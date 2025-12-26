// lib/helpers/format_currency.dart

class FormatCurrency {
  // ✅ Accept both int and double, return String without "Rp"
  static String toRupiah(num value) {
    // Convert to int to remove decimals
    final intValue = value.toInt();
    
    // Format with thousand separator (dot)
    return intValue.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // ✅ Alternative: return dengan "Rp" prefix
  static String toRupiahWithPrefix(num value) {
    return 'Rp ${toRupiah(value)}';
  }

  // ✅ Parse dari string ke double
  static double fromRupiah(String value) {
    // Remove "Rp", spaces, and dots
    final cleaned = value
        .replaceAll('Rp', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .trim();
    
    return double.tryParse(cleaned) ?? 0.0;
  }
}