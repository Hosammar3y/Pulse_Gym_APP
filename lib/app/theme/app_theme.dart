import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_extensions.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: AppTypography.textTheme(AppColors.textPrimary),
      cardTheme: const CardThemeData(
        elevation: 0,
        color: AppColors.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          side: BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
      extensions: const <ThemeExtension<dynamic>>[
        PulseCoachThemeExtension(
          successSurface: Color(0xFFE8F8EF),
          warningSurface: Color(0xFFFFF4DD),
        ),
      ],
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      extensions: const <ThemeExtension<dynamic>>[
        PulseCoachThemeExtension(
          successSurface: Color(0xFF123D2D),
          warningSurface: Color(0xFF4B3714),
        ),
      ],
    );
  }
}
