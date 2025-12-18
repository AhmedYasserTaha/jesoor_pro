import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/forgot_password_button.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/utils/strings.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.phoneController,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.formPadding),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppDimensions.fieldSpacing),
            CustomTextField(
              controller: phoneController,
              hintText: Strings.phoneNumber,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Strings.phoneNumberRequired;
                }
                if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                  return Strings.enterValidEgyptianPhone;
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            const ForgotPasswordButton(),
            const SizedBox(height: 30),

            CustomButton(text: Strings.loginButton, onPressed: onLogin),
          ],
        ),
      ),
    );
  }
}
