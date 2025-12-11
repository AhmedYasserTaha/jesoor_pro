import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/theme/app_text_styles.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {},
        child: const Text(
          'Forgot password ?',
          style: AppTextStyles.forgotPasswordStyle,
        ),
      ),
    );
  }
}
