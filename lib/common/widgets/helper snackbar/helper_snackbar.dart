import 'package:flutter/material.dart';

class AppSnackbar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.85), // شفاف
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.redAccent, width: 1), // إطار رفيع
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black.withOpacity(0.85), // شفاف
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.greenAccent, width: 1), // إطار رفيع
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
