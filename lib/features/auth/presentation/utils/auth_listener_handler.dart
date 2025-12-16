import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import '../screens/widgets/loading_dialog.dart';
import '../screens/widgets/success_dialog.dart';
import '../screens/widgets/otp_verification_dialog.dart';

/// Handles all BlocListener logic for auth state changes
class AuthListenerHandler {
  static void handleStateChange(BuildContext context, AuthState state) {
    // Handle main auth status (login/signup success/error)
    if (state.status == AuthStatus.success) {
      // TODO: Navigate to Home/Root screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Auth Success! Navigating to Home...'),
        ),
      );
    } else if (state.status == AuthStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage ?? 'Unknown Error')),
      );
    }

    // Handle send OTP status
    if (state.sendOtpStatus == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.sendOtpStatus == AuthStatus.success) {
      LoadingDialog.hide(context);

      // Show OTP Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OtpVerificationDialog(
          phone: state.phone ?? '',
          onVerify: (otp) {
            context.read<AuthCubit>().verifyOtp(
                  otp,
                  "test-device-token",
                  "test-device-label",
                );
          },
        ),
      );
    } else if (state.sendOtpStatus == AuthStatus.error) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Error sending OTP',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Handle verify OTP status
    if (state.verifyOtpStatus == AuthStatus.success) {
      Navigator.pop(context); // Dismiss OTP Dialog

      // Show Success Dialog then move to step 2
      showDialog(
        context: context,
        builder: (context) => SuccessDialog(
          onNext: () {
            context.read<AuthCubit>().setSignupStep(2);
          },
        ),
      );
    } else if (state.verifyOtpStatus == AuthStatus.error) {
      // Don't dismiss OTP dialog on error
      // Error message will be shown inside the dialog
      // Optionally show snackbar as well
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'كود التحقق غير صحيح',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }

    // Handle complete step 2 status
    if (state.completeStep2Status == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.completeStep2Status == AuthStatus.success) {
      LoadingDialog.hide(context);
      // Step 2 completed, move to step 3 (categories) is handled by cubit
      // Load categories if step 3 is reached
      if (state.signupStep == 3 && state.categories.isEmpty) {
        context.read<AuthCubit>().getCategories();
      }
    } else if (state.completeStep2Status == AuthStatus.error) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Error completing step 2',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Handle get categories status
    if (state.getCategoriesStatus == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.getCategoriesStatus == AuthStatus.success) {
      LoadingDialog.hide(context);
      // Categories loaded successfully, UI will display them
    } else if (state.getCategoriesStatus == AuthStatus.error) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Error loading categories',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Handle complete step 3 status
    if (state.completeStep3Status == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.completeStep3Status == AuthStatus.success) {
      LoadingDialog.hide(context);
      // Registration complete, handled by main status success
    } else if (state.completeStep3Status == AuthStatus.error) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Error completing step 3',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Handle login send OTP status
    if (state.loginSendOtpStatus == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.loginSendOtpStatus == AuthStatus.success) {
      LoadingDialog.hide(context);

      // Show OTP Dialog for login
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OtpVerificationDialog(
          phone: state.loginPhone ?? '',
          onVerify: (otp) {
            context.read<AuthCubit>().loginVerifyOtp(
                  otp,
                  "test-device-token",
                  "test-device-label",
                );
          },
        ),
      );
    } else if (state.loginSendOtpStatus == AuthStatus.error) {
      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Error sending OTP',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }

    // Handle login verify OTP status
    if (state.loginVerifyOtpStatus == AuthStatus.success) {
      Navigator.pop(context); // Dismiss OTP Dialog
      // Login success is handled by main status success
    } else if (state.loginVerifyOtpStatus == AuthStatus.error) {
      // Error message shown in dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'كود التحقق غير صحيح',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
