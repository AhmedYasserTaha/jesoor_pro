import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;

  const CustomText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      textScaler: TextScaler.linear(1),
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      style: TextStyle(
        fontFamily: 'Roboto', // Fixed font
        color: color ?? AppColors.textPrimary,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? FontWeight.normal,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
