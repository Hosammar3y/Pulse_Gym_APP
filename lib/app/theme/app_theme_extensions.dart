import 'package:flutter/material.dart';

@immutable
class PulseCoachThemeExtension extends ThemeExtension<PulseCoachThemeExtension> {
  const PulseCoachThemeExtension({required this.successSurface, required this.warningSurface});

  final Color successSurface;
  final Color warningSurface;

  @override
  PulseCoachThemeExtension copyWith({Color? successSurface, Color? warningSurface}) {
    return PulseCoachThemeExtension(
      successSurface: successSurface ?? this.successSurface,
      warningSurface: warningSurface ?? this.warningSurface,
    );
  }

  @override
  PulseCoachThemeExtension lerp(covariant ThemeExtension<PulseCoachThemeExtension>? other, double t) {
    if (other is! PulseCoachThemeExtension) return this;
    return PulseCoachThemeExtension(
      successSurface: Color.lerp(successSurface, other.successSurface, t) ?? successSurface,
      warningSurface: Color.lerp(warningSurface, other.warningSurface, t) ?? warningSurface,
    );
  }
}
