import 'package:flutter/material.dart';
import 'package:pokedex_serasa/core/theme/app_colors.dart';

abstract class AppTextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
    height: 1.2,
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.greyText,
    height: 1.5,
  );

  static const TextStyle pokemonCounter = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryRed,
    height: 1.2,
  );

  static const TextStyle pokemonCounterLabel = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
    height: 1.2,
  );

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}
