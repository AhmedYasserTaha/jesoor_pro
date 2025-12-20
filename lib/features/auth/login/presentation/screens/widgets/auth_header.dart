import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/widgets/custom_text.dart';
import 'book_icon.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        BookIcon(),
        SizedBox(height: 12),
        CustomText(
          'L M S',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textWhite,
          letterSpacing: 6,
        ),
      ],
    );
  }
}
