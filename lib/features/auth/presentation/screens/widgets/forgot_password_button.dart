import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_text_styles.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/forgot_password_dialog.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            backgroundColor: Colors.white,
            builder: (context) => const ForgotPasswordDialog(),
          );
        },
        child: const Text(
          Strings.forgotPassword,
          style: AppTextStyles.forgotPasswordStyle,
        ),
      ),
    );
  }
}
