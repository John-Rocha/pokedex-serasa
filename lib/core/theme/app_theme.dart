import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';
import 'package:pokedex_serasa/core/theme/app_text_styles.dart';

abstract class AppTheme {
  static ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryRed,
        primary: AppColors.primaryRed,
        secondary: AppColors.primaryRed,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.appBarTitle,
        iconTheme: IconThemeData(
          color: AppColors.white,
          size: 24,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: AppTextStyles.headline1,
        titleMedium: AppTextStyles.subtitle1,
        displayLarge: AppTextStyles.pokemonCounter,
        bodyLarge: AppTextStyles.pokemonCounterLabel,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryRed,
        size: 24,
      ),
    );
  }
}
