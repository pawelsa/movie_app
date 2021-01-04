import 'package:flutter/material.dart';

class AppColors {
  static const Color splashScreenGreen = Color(0xFFBDE7DF);
  static const Color accent = Color(0xFFF9BD04);
  static const Color selected = accent;
  static const Color unselected = Color(0xFFD6D6D6);
  static const Color background = Colors.white;
  static const Color _backgroundGradientStart = Colors.white;
  static const Color _backgroundGradientEnd = Color(0xFFE7E7E7);
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [_backgroundGradientStart, _backgroundGradientEnd],
  );
}
