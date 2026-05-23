import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:mbium_mobile_client/core/themes/gradient_theme.dart';
=======
import 'package:mbium_mobile_client/core/themes/app_text_styles.dart';
>>>>>>> 5e7e7111dc73a3b7cc5ca21ba5cd3e96edd87350

import 'app_colors.dart';

extension AppThemeContext on BuildContext {
  AppTextStyles get appTextStyles => Theme.of(this).extension<AppTextStyles>()!;
}

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryGreen,
    onPrimary: Colors.black,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    error: AppColors.errorRed,
    secondary: Colors.white,
    tertiary: AppColors.lightSelectedNavBarItem,
  ),

<<<<<<< HEAD
  extensions: <ThemeExtension<dynamic>>[
    GradientTheme(
      containerGradient: LinearGradient(
        colors: [Color(0xff1A0806), Color(0xff180A07)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
=======
  // Registering dark mode values for your custom text styles
  extensions: const <ThemeExtension<dynamic>>[
    AppTextStyles(
      s13w600clGreen: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      s16w600clBlack: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      s13w600clBlack: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white,
>>>>>>> 5e7e7111dc73a3b7cc5ca21ba5cd3e96edd87350
      ),
    ),
  ],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        inherit: false,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkSurface,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: AppColors.darkTextSecondary),
  ),

  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
    bodyMedium: TextStyle(color: AppColors.darkTextSecondary),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.darkBg,

    type: BottomNavigationBarType.fixed,

    selectedItemColor:
        AppColors.lightSelectedNavBarItem, // softer purple for dark mode
    unselectedItemColor: AppColors.navWhite,

    selectedLabelStyle: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
    ),

    unselectedLabelStyle: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
    ),

    showSelectedLabels: true,
    showUnselectedLabels: true,

    elevation: 0,
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBg,
  colorScheme: const ColorScheme.light(
    primary: AppColors.primaryGreen,
    onPrimary: Colors.black,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    secondary: AppColors.lightNavBarIcon,
    tertiary: AppColors.lightSelectedNavBarItem,
  ),

<<<<<<< HEAD
  extensions: <ThemeExtension<dynamic>>[
    GradientTheme(
      containerGradient: LinearGradient(
        colors: [Color(0xff1A0806), Color(0xff180A07)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
=======
  // Registering light mode values for your custom text styles
  extensions: const <ThemeExtension<dynamic>>[
    AppTextStyles(
      s13w600clGreen: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.bonusBannerTextGreen,
      ),
      s16w600clBlack: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),

      s13w600clBlack: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.aiTextBlack,
>>>>>>> 5e7e7111dc73a3b7cc5ca21ba5cd3e96edd87350
      ),
    ),
  ],
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        inherit: false,
      ),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.navWhite,

    type: BottomNavigationBarType.fixed,

    selectedItemColor: AppColors.lightSelectedNavBarItem,
    unselectedItemColor: AppColors.lightTextPrimary,

    selectedLabelStyle: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
    ),

    unselectedLabelStyle: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
    ),

    showSelectedLabels: true,
    showUnselectedLabels: true,

    elevation: 12,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: AppColors.lightBg,
      fontWeight: FontWeight.bold,
    ),
    bodyLarge: TextStyle(color: AppColors.lightTextPrimary),
    bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
  ),
);
