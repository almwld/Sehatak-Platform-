import 'package:flutter/material.dart';

class AppColors {
  // ==============================================
  // 🎨 الألوان الرئيسية - Primary Colors
  // ==============================================
  static const Color primary = Color(0xFF0077B6);
  static const Color secondary = Color(0xFF00B4D8);
  static const Color primaryDark = Color(0xFF023E8A);
  
  // ==============================================
  // 🎨 الألوان الثانوية - Secondary Colors
  // ==============================================
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  
  // ==============================================
  // 🎨 ألوان الخلفية - Background Colors
  // ==============================================
  static const Color background = Color(0xFFF5F7FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1A2E);
  
  // ==============================================
  // 🎨 ألوان النصوص - Text Colors
  // ==============================================
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFFFFFFFF);
  
  // ==============================================
  // 🎨 التدرجات - Gradients
  // ==============================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, Color(0xFF27AE60)],
  );
}
