import 'package:flutter/material.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get screenTitle => const TextStyle(
        fontWeight: FontWeight.bold,
      );

  static TextStyle get sectionTitle => const TextStyle(
        fontWeight: FontWeight.w600,
      );

  static TextStyle get summaryValue => const TextStyle(
        fontWeight: FontWeight.bold,
      );
}
