import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/theme/app_colors.dart';
import 'package:jesoor_pro/core/widgets/custom_button.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';

class OtpVerificationDialog extends StatefulWidget {
  final String phone;
  final Function(String) onVerify;
  final bool isLogin;

  const OtpVerificationDialog({
    super.key,
    required this.phone,
    required this.onVerify,
    this.isLogin = false,
  });

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
  }

  void _verify() {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length == 6) {
      widget.onVerify(otp);
    }
  }

  void _clearError(AuthCubit cubit) {
    // Clear error when user starts typing
    if (widget.isLogin) {
      if (cubit.state.loginVerifyOtpStatus == AuthStatus.error) {
        cubit.clearLoginVerifyOtpError();
      }
    } else {
      if (cubit.state.verifyOtpStatus == AuthStatus.error) {
        cubit.clearVerifyOtpError();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isLoading = widget.isLogin
            ? state.loginVerifyOtpStatus == AuthStatus.loading
            : state.verifyOtpStatus == AuthStatus.loading;
        final hasError = widget.isLogin
            ? state.loginVerifyOtpStatus == AuthStatus.error
            : state.verifyOtpStatus == AuthStatus.error;
        final errorMessage = state.errorMessage ?? Strings.otpIncorrect;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  Strings.verifyOtp,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${Strings.enterOtpCode}${widget.phone}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return SizedBox(
                      width: 40,
                      height: 50,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hasError ? Colors.red : Colors.grey,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hasError ? Colors.red : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: hasError ? Colors.red : AppColors.primary,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                          counterText: "",
                        ),
                        onChanged: (value) {
                          _onDigitChanged(index, value);
                          if (value.isNotEmpty) {
                            _clearError(context.read<AuthCubit>());
                          }
                        },
                        enabled: !isLoading,
                      ),
                    );
                  }),
                ),
                if (hasError) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (isLoading)
                  const CircularProgressIndicator(color: AppColors.primary)
                else
                  CustomButton(text: Strings.verify, onPressed: _verify),
              ],
            ),
          ),
        );
      },
    );
  }
}
