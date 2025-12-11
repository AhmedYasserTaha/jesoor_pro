import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Auth Screen Styles
  static const TextStyle appTitleStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 6,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static const TextStyle tabLabelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle tabUnselectedLabelStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle forgotPasswordStyle = TextStyle(
    color: AppColors.accentYellow,
    fontSize: 14,
  );

  AppTextStyles._();
}
