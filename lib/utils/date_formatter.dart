// lib/utils/date_formatter.dart
// 📅 Sentralisasi semua formatting tanggal & waktu

import 'package:intl/intl.dart';

class DateFormatter {
  /// ============================================
  /// DATE FORMATTING
  /// ============================================

  /// Format: dd/MM/yyyy (e.g., 22/12/2025)
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format: dd MMM yyyy (e.g., 22 Dec 2025)
  static String formatDateWithMonth(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Format: EEEE, dd MMMM yyyy (e.g., Sunday, 22 December 2025)
  static String formatFullDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy').format(date);
  }

  /// Format: MM/dd (e.g., 12/22)
  static String formatMonthDay(DateTime date) {
    return DateFormat('MM/dd').format(date);
  }

  /// Format: yyyy-MM-dd (e.g., 2025-12-22) - ISO format
  static String formatISODate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// ============================================
  /// TIME FORMATTING
  /// ============================================

  /// Format: HH:mm (e.g., 14:30)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format: HH:mm:ss (e.g., 14:30:45)
  static String formatTimeWithSeconds(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// Format: h:mm a (e.g., 2:30 PM)
  static String formatTime12Hour(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  /// Format: h:mm:ss a (e.g., 2:30:45 PM)
  static String formatTime12HourWithSeconds(DateTime dateTime) {
    return DateFormat('h:mm:ss a').format(dateTime);
  }

  /// ============================================
  /// DATE & TIME FORMATTING
  /// ============================================

  /// Format: dd/MM/yyyy HH:mm (e.g., 22/12/2025 14:30)
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Format: dd/MM/yyyy HH:mm:ss (e.g., 22/12/2025 14:30:45)
  static String formatDateTimeWithSeconds(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
  }

  /// Format: dd MMM yyyy, HH:mm (e.g., 22 Dec 2025, 14:30)
  static String formatDateTimeWithMonth(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }

  /// Format: EEEE, dd MMMM yyyy HH:mm
  /// (e.g., Sunday, 22 December 2025 14:30)
  static String formatFullDateTime(DateTime dateTime) {
    return DateFormat('EEEE, dd MMMM yyyy HH:mm').format(dateTime);
  }

  /// Format: yyyy-MM-ddTHH:mm:ss.SSSZ (ISO 8601)
  static String formatISO8601(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// ============================================
  /// RELATIVE TIME FORMATTING
  /// ============================================

  /// Return human readable relative time
  /// (e.g., "2 hours ago", "3 days from now")
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    }

    if (difference.inMinutes < 60) {
      final mins = difference.inMinutes;
      return '$mins ${mins == 1 ? 'menit' : 'menit'} yang lalu';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'jam' : 'jam'} yang lalu';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'hari' : 'hari'} yang lalu';
    }

    if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'minggu' : 'minggu'} yang lalu';
    }

    if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'bulan' : 'bulan'} yang lalu';
    }

    final years = (difference.inDays / 365).floor();
    return '$years ${years == 1 ? 'tahun' : 'tahun'} yang lalu';
  }

  /// ============================================
  /// DURATION FORMATTING
  /// ============================================

  /// Format duration to readable string
  /// (e.g., "2h 30m", "45m", "30s")
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }

    if (minutes > 0) {
      return '${minutes}m';
    }

    return '${seconds}s';
  }

  /// Format countdown timer
  /// (e.g., "02:30:45")
  static String formatCountdown(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// ============================================
  /// PARSING
  /// ============================================

  /// Parse date from various formats
  static DateTime? parseDate(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      try {
        return DateFormat('dd/MM/yyyy').parse(dateString);
      } catch (e) {
        return null;
      }
    }
  }

  /// Parse ISO 8601 date
  static DateTime? parseISO8601(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// ============================================
  /// YEAR/MONTH/DAY GETTERS
  /// ============================================

  static int getYear(DateTime date) => date.year;
  static int getMonth(DateTime date) => date.month;
  static int getDay(DateTime date) => date.day;
  static int getHour(DateTime date) => date.hour;
  static int getMinute(DateTime date) => date.minute;
  static int getSecond(DateTime date) => date.second;

  /// Get month name (e.g., "January", "February")
  static String getMonthName(int month) {
    return DateFormat('MMMM').format(DateTime(2025, month));
  }

  /// Get day name (e.g., "Monday", "Tuesday")
  static String getDayName(int day) {
    // day 1 = Monday, 7 = Sunday
    final days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu'
    ];
    return days[day - 1];
  }

  /// Get day name from DateTime
  static String getDayNameFromDate(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  /// ============================================
  /// DATE COMPARISON & CALCULATION
  /// ============================================

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return date.isBefore(DateTime.now());
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return date.isAfter(DateTime.now());
  }

  /// Check if date is same as another date (ignoring time)
  static bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get days difference between two dates
  static int daysBetween(DateTime from, DateTime to) {
    return to.difference(from).inDays;
  }

  /// ============================================
  /// SPECIAL FORMATTING
  /// ============================================

  /// Format time for orders (e.g., "Pesanan dibuat 2 jam yang lalu")
  static String formatOrderTime(DateTime dateTime) {
    return 'Pesanan dibuat ${formatRelativeTime(dateTime)}';
  }

  /// Format delivery time (e.g., "Estimasi tiba: 22 Dec, 14:30")
  static String formatDeliveryTime(DateTime dateTime) {
    return 'Estimasi tiba: ${formatDateTimeWithMonth(dateTime)}';
  }

  /// Format countdown for flash sale
  /// Returns: "02:30:45" or "00:00:00" if expired
  static String formatFlashSaleCountdown(DateTime expiresAt) {
    final duration = expiresAt.difference(DateTime.now());

    if (duration.isNegative) {
      return '00:00:00';
    }

    return formatCountdown(duration);
  }

  /// Format for invoice (e.g., "INV/20251222/00001")
  static String formatInvoiceNumber(String baseNumber) {
    final now = DateTime.now();
    final date = DateFormat('yyyyMMdd').format(now);
    return 'INV/$date/$baseNumber';
  }
}
