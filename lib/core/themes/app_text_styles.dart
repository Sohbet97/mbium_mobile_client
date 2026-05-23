import 'package:flutter/material.dart';

class AppTextStyles extends ThemeExtension<AppTextStyles> {
  final TextStyle s13w600clGreen;
  final TextStyle s16w600clBlack;
  final TextStyle s13w600clBlack;
  final TextStyle s14w400clWhite;
  final TextStyle s20w700clWhite;
  const AppTextStyles({
    required this.s13w600clGreen,
    required this.s16w600clBlack,
    required this.s13w600clBlack,
    required this.s14w400clWhite,
    required this.s20w700clWhite,
  });

  @override
  ThemeExtension<AppTextStyles> copyWith({
    TextStyle? s13w600clGreen,
    TextStyle? s16w600clBlack,
    TextStyle? s13w600clBlack,
    TextStyle? s14w400clWhite,
    TextStyle? s20w700clWhite,
  }) {
    return AppTextStyles(
      s13w600clGreen: s13w600clGreen ?? this.s13w600clGreen,
      s16w600clBlack: s16w600clBlack ?? this.s16w600clBlack,
      s13w600clBlack: s13w600clBlack ?? this.s13w600clBlack,
      s14w400clWhite: s14w400clWhite ?? this.s14w400clWhite,
      s20w700clWhite: s20w700clWhite ?? this.s20w700clWhite,
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
      s14w400clWhite: TextStyle.lerp(s14w400clWhite, other.s14w400clWhite, t)!,
      s20w700clWhite: TextStyle.lerp(s20w700clWhite, other.s20w700clWhite, t)!,
    );
  }
}
