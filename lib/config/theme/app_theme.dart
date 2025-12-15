import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
    ),
    brightness: Brightness.light,
  );
}
