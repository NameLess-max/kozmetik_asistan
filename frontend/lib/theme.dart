import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Renk Tanımlamaları (Proje Tasarım Gereksinim Dökümanı'na göre)
  static const Color primaryNavy = Color(0xFF2C3E50);    // Otorite ve güven
  static const Color secondaryGreen = Color(0xFF7FB069); // Doğallık ve sağlık
  static const Color backgroundWhite = Color(0xFFF8F9FA); // Minimalizm, beyaz boşluk
  static const Color warningOrange = Color(0xFFE67E22);  // Bilgi verici uyarı

  static ThemeData get lightTheme {
    return ThemeData(
      // Ana arka plan rengi
      scaffoldBackgroundColor: backgroundWhite,
      primaryColor: primaryNavy,

      // Modern Flutter projelerinde renk şeması (ColorScheme) kullanımı zorunludur
      colorScheme: const ColorScheme.light(
        primary: primaryNavy,
        secondary: secondaryGreen,
        surface: backgroundWhite,
        error: warningOrange,
      ),

      // Yazı Tipi Ailesi: Inter (Google Fonts üzerinden çekiyoruz)
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(color: primaryNavy, fontWeight: FontWeight.bold),
        bodyLarge: const TextStyle(color: primaryNavy, fontSize: 16),
        bodyMedium: const TextStyle(color: Colors.black87, fontSize: 14),
      ),

      // Üst bar (AppBar) genel tasarımı
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundWhite,
        elevation: 0, // Gölgeyi kaldırarak ferah bir görünüm (minimalizm) sağlıyoruz
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryNavy),
        titleTextStyle: TextStyle(
          color: primaryNavy,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Genel Buton Tasarımı
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondaryGreen, // Butonlar varsayılan olarak yeşil
          foregroundColor: Colors.white, // Buton içindeki yazı beyaz
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Yumuşak köşeler
          ),
        ),
      ),
    );
  }
}