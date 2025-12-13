import 'package:flutter/material.dart';
import 'package:jesoor_pro/core/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onSignup;

  const SignupForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onSignup,
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
              controller: nameController,
              hintText: 'Enter Full Name',
            ),
            const SizedBox(height: AppDimensions.fieldSpacing),
            CustomTextField(
              controller: emailController,
              hintText: 'Phone number',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppDimensions.fieldSpacing),
            const SizedBox(height: 40),
            CustomButton(text: 'SIGNUP', onPressed: onSignup),
          ],
        ),
      ),
    );
  }
}
