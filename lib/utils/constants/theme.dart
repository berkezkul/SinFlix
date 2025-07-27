import 'package:flutter/material.dart';
import 'colors.dart';
import 'fonts.dart';
import 'text_styles.dart';

final ThemeData appTheme = ThemeData(
  fontFamily: AppFonts.primaryFont,
  primaryColor: AppColors.red,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    titleLarge: AppTextStyles.headline,
    bodyLarge: AppTextStyles.body,
    labelLarge: AppTextStyles.button,
    bodySmall: AppTextStyles.caption,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBackground,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.red),
    ),
    hintStyle: AppTextStyles.hint,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: AppTextStyles.button,
      minimumSize: Size(double.infinity, 56),
    ),
  ),
);