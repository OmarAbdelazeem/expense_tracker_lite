import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xff1d55f3);
  static const Color primaryLight = Color(0xff496ef3);
  static const Color primaryDark = Color(0xFF4A56E2);
  
  // Background Colors
  static const Color background = Color(0xFFF5F6FA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceBackground = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.grey;
  static const Color textOnPrimary = Colors.white;
  static const Color textLight = Colors.white70;
  
  // Gradient Colors
  static const Color gradientStart = Color(0xFF6B73FF);
  static const Color gradientEnd = Color(0xFF4ECDC4);
  
  // Category Colors
  static const Color groceries = Color(0xFF6B73FF);
  static const Color entertainment = Color(0xFF9D50DD);
  static const Color gas = Color(0xFFFF6B6B);
  static const Color shopping = Color(0xFFFFD93D);
  static const Color newspaper = Color(0xFF6BCF7F);
  static const Color transport = Color(0xFF4ECDC4);
  static const Color rent = Color(0xFFFF8A65);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.04);
  static Color shadowMedium = Colors.black.withOpacity(0.08);
  static Color shadowDark = Colors.black.withOpacity(0.12);
  static Color shadowPrimary = primary.withOpacity(0.3);
  
  // Border Colors
  static Color borderLight = Colors.white.withOpacity(0.2);
  static Color borderMedium = Colors.white.withOpacity(0.3);
  static Color borderDark = Colors.grey.withOpacity(0.2);
}

class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
} 