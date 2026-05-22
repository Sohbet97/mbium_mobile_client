import 'package:flutter/material.dart';

@immutable
class GradientTheme extends ThemeExtension<GradientTheme> {
  final LinearGradient containerGradient;

  const GradientTheme({required this.containerGradient});

  @override
  GradientTheme copyWith({LinearGradient? containerGradient}) {
    return GradientTheme(
      containerGradient: containerGradient ?? this.containerGradient,
    );
  }

  @override
  GradientTheme lerp(ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) return this;
    return GradientTheme(
      containerGradient: LinearGradient.lerp(
        containerGradient,
        other.containerGradient,
        t,
      )!,
    );
  }
}
