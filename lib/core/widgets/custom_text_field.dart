import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final VoidCallback? onTogglePassword;
  final bool isPasswordVisible;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.onTogglePassword,
    this.isPasswordVisible = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText && !isPasswordVisible,
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.hintTextColor),
        filled: true,
        fillColor: AppColors.textFieldFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        suffixIcon: showPasswordToggle && onTogglePassword != null
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.iconSecondary,
                ),
                onPressed: onTogglePassword,
              )
            : null,
      ),
      onTap: () {
        // Move cursor to the end (right) when field is tapped
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        });
      },
      onChanged: (value) {
        // Keep cursor at the end (right) after typing
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          );
        });
      },
    );
  }
}
