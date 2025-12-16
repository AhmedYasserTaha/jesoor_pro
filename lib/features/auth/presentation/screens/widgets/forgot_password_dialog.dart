import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/widgets/custom_button.dart';
import 'package:jesoor_pro/core/widgets/custom_text_field.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import 'package:jesoor_pro/features/auth/presentation/screens/widgets/otp_verification_dialog.dart';

enum ForgotPasswordStep { enterPhone, enterOtp, enterNewPassword }

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ForgotPasswordStep _currentStep = ForgotPasswordStep.enterPhone;
  String? _otp;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    if (_phoneController.text.isEmpty) return;
    context.read<AuthCubit>().forgotPasswordSendOtp(_phoneController.text);
  }

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      if (_otp == null) return;
      context.read<AuthCubit>().forgotPasswordReset(
        _otp!,
        _newPasswordController.text,
        _confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Handle forgot password send OTP
        if (state.forgotPasswordSendOtpStatus == AuthStatus.success) {
          setState(() {
            _currentStep = ForgotPasswordStep.enterOtp;
          });
          // Show OTP Dialog - use verifyOtp directly for forgot password
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => OtpVerificationDialog(
              phone: _phoneController.text,
              onVerify: (otp) {
                // Store OTP and move to next step
                setState(() {
                  _otp = otp;
                  _currentStep = ForgotPasswordStep.enterNewPassword;
                });
                Navigator.pop(context); // Close OTP dialog
              },
            ),
          );
        } else if (state.forgotPasswordSendOtpStatus == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error sending OTP'),
              backgroundColor: Colors.red,
            ),
          );
        }

        // Handle forgot password reset
        if (state.forgotPasswordResetStatus == AuthStatus.success) {
          Navigator.pop(context); // Close forgot password dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تغيير كلمة السر بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.forgotPasswordResetStatus == AuthStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Error resetting password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                  _currentStep == ForgotPasswordStep.enterPhone
                      ? "نسيت كلمة السر"
                      : _currentStep == ForgotPasswordStep.enterOtp
                      ? "تحقق من الكود"
                      : "إعادة تعيين كلمة السر",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 20),
                if (_currentStep == ForgotPasswordStep.enterPhone) ...[
                  const Text(
                    "أدخل رقم هاتفك لتلقي كود التحقق",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _phoneController,
                    hintText: "رقم الهاتف",
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value)) {
                        return 'أدخل رقم هاتف مصري صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state.forgotPasswordSendOtpStatus ==
                          AuthStatus.loading;
                      return CustomButton(
                        text: "إرسال الكود",
                        onPressed: isLoading ? () {} : _sendOtp,
                      );
                    },
                  ),
                ] else if (_currentStep ==
                    ForgotPasswordStep.enterNewPassword) ...[
                  const Text(
                    "أدخل كلمة سر جديدة",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: "كلمة السر الجديدة",
                    obscureText: _obscureNewPassword,
                    showPasswordToggle: true,
                    isPasswordVisible: !_obscureNewPassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'كلمة السر مطلوبة';
                      }
                      if (value.length < 6) {
                        return 'كلمة السر يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: "تأكيد كلمة السر",
                    obscureText: _obscureConfirmPassword,
                    showPasswordToggle: true,
                    isPasswordVisible: !_obscureConfirmPassword,
                    onTogglePassword: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'تأكيد كلمة السر مطلوب';
                      }
                      if (value != _newPasswordController.text) {
                        return 'كلمة السر غير متطابقة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state.forgotPasswordResetStatus == AuthStatus.loading;
                      return CustomButton(
                        text: "تغيير كلمة السر",
                        onPressed: isLoading ? () {} : _resetPassword,
                      );
                    },
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
