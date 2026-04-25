import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle badge = TextStyle(
    fontFamily: 'Outfit',
    color: AppColors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Outfit',
    color: AppColors.white,
    fontSize: 32,
    fontWeight: FontWeight.w900,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle bodyDescription = TextStyle(
    fontFamily: 'Outfit',
    color: AppColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: 'Outfit',
    color: AppColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );
}
