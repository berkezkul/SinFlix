import 'package:flutter/material.dart';
import 'colors.dart';
import 'fonts.dart';

class AppTextStyles {
  static const TextStyle headline = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 16,
    color: AppColors.white,
  );
  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
  static const TextStyle input = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 16,
    color: AppColors.white,
  );
  static const TextStyle hint = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 16,
    color: AppColors.border,
  );
  static final TextStyle link = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 14,
    color: AppColors.white,
    decoration: TextDecoration.underline,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.primaryFont,
    fontSize: 12,
    color: AppColors.lightGreyText,
  );
}