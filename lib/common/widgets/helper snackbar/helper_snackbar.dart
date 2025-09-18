import 'dart:ui';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void showError(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.error_outline,
      textColor: Colors.red,
    );
  }

  static void showSuccess(BuildContext context, String message) {
    _showCustomSnackBar(
      context,
      message: message,
      icon: Icons.check_circle_outline,
      textColor: Colors.green,
    );
  }

  static void _showCustomSnackBar(
      BuildContext context, {
        required String message,
        required IconData icon,
        required Color textColor,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        duration: const Duration(seconds: 2),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05), // شبه شفاف جداً
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: textColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
