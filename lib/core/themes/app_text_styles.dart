import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle s13w600clGreen;
  final TextStyle s16w600clBlack;
  final TextStyle s13w600clBlack;
  const AppTextStyles({
    required this.s13w600clGreen,
    required this.s16w600clBlack,

    required this.s13w600clBlack,
  });

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? s13w600clGreen,
    TextStyle? s16w600clBlack,
  }) {
    return AppTextStyles(
      s13w600clGreen: s13w600clGreen ?? this.s13w600clGreen,
      s16w600clBlack: s16w600clBlack ?? this.s16w600clBlack,

      s13w600clBlack: s13w600clBlack ?? this.s13w600clBlack,
    );
  }

  @override
  ThemeExtension<AppTextStyles> lerp(
    covariant ThemeExtension<AppTextStyles>? other,
    double t,
  ) {
    if (other is! AppTextStyles) {
      return this;
    }
    return AppTextStyles(
      s13w600clGreen: TextStyle.lerp(s13w600clGreen, other.s13w600clGreen, t)!,
      s16w600clBlack: TextStyle.lerp(s16w600clBlack, other.s16w600clBlack, t)!,
      s13w600clBlack: TextStyle.lerp(s13w600clBlack, other.s13w600clBlack, t)!,
    );
  }
}
