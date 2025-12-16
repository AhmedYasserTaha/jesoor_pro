import 'package:flutter/material.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/widgets/custom_button.dart';
import 'package:jesoor_pro/core/widgets/custom_text_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isCodeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // Mock API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _isCodeSent = true;
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code was resent successfully!")),
      );
    }
  }

  void _verifyCode() {
    // Mock verification
    Navigator.pop(context);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Verified (Mock)")));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _isCodeSent ? "Verify Code" : "Forgot Password",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            if (!_isCodeSent) ...[
              const Text(
                "Enter your email to receive a verification code.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                hintText: "Enter Email",
                keyboardType: TextInputType.emailAddress,
              ),
            ] else ...[
              const Text(
                "Please wait until email is sent...",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: _otpController,
                hintText: "Enter OTP code",
                keyboardType: TextInputType.number,
              ),
            ],
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              CustomButton(
                text: _isCodeSent ? "Verify" : "Send Code",
                onPressed: _isCodeSent ? _verifyCode : _sendCode,
              ),
            if (_isCodeSent && !_isLoading)
              TextButton(
                onPressed: _resendCode,
                child: const Text("Resend Code"),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
