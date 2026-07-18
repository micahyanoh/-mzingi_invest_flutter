import 'package:flutter/material.dart';

/// M-Zingi Invest brand tokens — carried over from the pitch deck.
class Palette {
  Palette._();

  static const deepGreen = Color(0xFF1F4D2C);
  static const navGreen = Color(0xFF0B3D2E);
  static const paleGreen = Color(0xFFEAF1E7);
  static const gold = Color(0xFFE9B759);
  static const tan = Color(0xFFF7ECD9);
  static const ink = Color(0xFF1B2B1E);
  static const muted = Color(0xFF5C6B5E);
  static const cream = Color(0xFFFDFBF6);
  static const white = Color(0xFFFFFFFF);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.deepGreen,
        primary: Palette.deepGreen,
        secondary: Palette.gold,
        surface: Palette.cream,
      ),
      scaffoldBackgroundColor: Palette.cream,
    );

    return base.copyWith(
      textTheme: base.textTheme
          .copyWith(
            displayLarge: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 56,
              height: 1.05,
              letterSpacing: -0.5,
              color: Palette.ink,
            ),
            displayMedium: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 40,
              height: 1.1,
              letterSpacing: -0.3,
              color: Palette.ink,
            ),
            headlineMedium: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 28,
              height: 1.15,
              color: Palette.ink,
            ),
            titleLarge: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Palette.ink,
            ),
            bodyLarge: const TextStyle(
              fontSize: 17,
              height: 1.5,
              color: Palette.muted,
            ),
            bodyMedium: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Palette.muted,
            ),
            labelLarge: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              letterSpacing: 1.2,
              color: Palette.gold,
            ),
          )
          .apply(fontFamily: null),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.gold,
          foregroundColor: Palette.ink,
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Palette.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        hintStyle: const TextStyle(color: Palette.muted, fontSize: 13.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Palette.paleGreen, width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Palette.paleGreen, width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Palette.deepGreen, width: 1.6),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.white,
          side: const BorderSide(color: Colors.white54, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
    );
  }
}

/// Eyebrow label style used throughout (e.g. "THE NUMBERS").
class Eyebrow extends StatelessWidget {
  final String text;
  final Color color;
  const Eyebrow(this.text, {super.key, this.color = Palette.gold});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.w800,
        fontSize: 13,
        letterSpacing: 2.2,
      ),
    );
  }
}
