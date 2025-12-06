// helpers/alert_helper.dart
import 'package:flutter/material.dart';

class AlertHelper {
  static void showSnackBar(
    BuildContext context,
    String message, {
    Color color = Colors.green,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ✅ Menampilkan pesan error (merah)
  static void showError(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.red);
  }

  // ✅ Menampilkan pesan sukses (hijau)
  static void showSuccess(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.green);
  }

  // ✅ Menampilkan pesan informasi (biru)
  static void showInfo(BuildContext context, String message) {
    showSnackBar(context, message, color: Colors.blue);
  }
}
