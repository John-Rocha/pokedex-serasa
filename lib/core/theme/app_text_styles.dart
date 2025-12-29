import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';

abstract class AppTextStyles {
  static const String fontFamily = 'Roboto';

  static const TextStyle bodySmallRegular = TextStyle(
    fontSize: 14,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    letterSpacing: 0.28,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
    letterSpacing: 0.32,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.greyText,
  );

  static const TextStyle pokemonCounter = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    color: AppColors.primaryRed,
  );

  static const TextStyle pokemonCounterLabel = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: AppColors.primaryRed,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
