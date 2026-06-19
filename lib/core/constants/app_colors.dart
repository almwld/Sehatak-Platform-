import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color secondary = Color(0xFF0288D1);
  static const Color secondaryDark = Color(0xFF01579B);
  static const Color secondaryLight = Color(0xFF03A9F4);

  // الألوان المحايدة
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color darkGrey = Color(0xFF424242);
  static const Color lightGrey = Color(0xFFBDBDBD);
  static const Color surfaceContainerLow = Color(0xFFF5F5F5);

  // ألوان الحالة
  static const Color success = Color(0xFF388E3C);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // ألوان التدرج
  static const List<Color> primaryGradient = [
    Color(0xFF2E7D32),
    Color(0xFF1B5E20),
  ];
  static const List<Color> secondaryGradient = [
    Color(0xFF0288D1),
    Color(0xFF01579B),
  ];

  // ألوان الخلفية
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);

  // ألوان البطاقات
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1E1E1E);

  // ألوان النصوص
  static const Color textLight = Color(0xFF1A1A1A);
  static const Color textDark = Color(0xFFE0E0E0);
  static const Color textHint = Color(0xFF757575);
}
