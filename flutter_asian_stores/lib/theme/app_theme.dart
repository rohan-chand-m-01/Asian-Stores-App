import 'package:flutter/material.dart';

class AppColors {
  static const Color green = Color(0xFF1F7A3A);
  static const Color greenDark = Color(0xFF145C2A);
  static const Color greenSoft = Color(0xFFE8F5EC);
  static const Color greenMid = Color(0xFF2E9A4C);
  static const Color cream = Color(0xFFF7FBF8);
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF102018);
  static const Color muted = Color(0xFF5B6B62);
  static const Color line = Color(0xFFD7E5DB);
  static const Color gold = Color(0xFFE8B923);
  static const Color danger = Color(0xFFC45C26);
  static const Color amberBg = Color(0xFFFFF4E5);
  static const Color navy = Color(0xFF0E1C14);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.cream,
      primaryColor: AppColors.green,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.green,
        primary: AppColors.green,
        secondary: AppColors.greenDark,
        surface: AppColors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.greenDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
    );
  }
}
