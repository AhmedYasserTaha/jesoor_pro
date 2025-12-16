import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_dimensions.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/custom_button.dart';
import 'forgot_password_button.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
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
              controller: emailController,
              hintText: 'Enter Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppDimensions.fieldSpacing),
            CustomTextField(
              controller: passwordController,
              hintText: 'Enter Password',
              obscureText: true,
              showPasswordToggle: true,
              isPasswordVisible: !obscurePassword,
              onTogglePassword: onTogglePassword,
            ),
            const SizedBox(height: 12),
            const ForgotPasswordButton(),
            const SizedBox(height: 30),
            CustomButton(text: 'LOGIN', onPressed: onLogin),
          ],
        ),
      ),
    );
  }
}
