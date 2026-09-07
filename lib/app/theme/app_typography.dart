import 'package:flutter/material.dart';

abstract final class AppTypography {
  static TextTheme textTheme(Color foreground) => TextTheme(
        headlineSmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: foreground),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: foreground),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: foreground),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: foreground),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: foreground),
      );
}
