import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Auth Screen Styles
  static TextStyle appTitleStyle = GoogleFonts.cairo(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 6,
  );

  static TextStyle buttonTextStyle = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static TextStyle tabLabelStyle = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle tabUnselectedLabelStyle = GoogleFonts.cairo(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle forgotPasswordStyle = GoogleFonts.cairo(
    color: AppColors.accentYellow,
    fontSize: 14,
  );

  AppTextStyles._();
}
