import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_state.dart';
import 'package:jesoor_pro/features/auth/login/presentation/screens/widgets/loading_dialog.dart';
import 'package:jesoor_pro/features/auth/login/presentation/screens/widgets/otp_verification_dialog.dart';
import 'package:jesoor_pro/features/auth/login/presentation/screens/widgets/error_dialog.dart';

/// Handles all BlocListener logic for login state changes
class LoginListenerHandler {
  static void handleStateChange(BuildContext context, LoginState state) {
    // Handle main login status (success/error)
    if (state.status == LoginStatus.success) {
      // Navigate to Roots screen after successful login
      Future.microtask(() {
        if (context.mounted) {
          context.go(Routes.roots);
        }
      });
    } else if (state.status == LoginStatus.error) {
      // Show error dialog for login errors
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }

    // Handle login send OTP status
    if (state.loginSendOtpStatus == LoginStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.loginSendOtpStatus == LoginStatus.success) {
      LoadingDialog.hide(context);

      // Show OTP Dialog for login
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OtpVerificationDialog(
          phone: state.loginPhone ?? '',
          isLogin: true,
          onVerify: (otp) {
            context.read<LoginCubit>().loginVerifyOtp(
              otp,
              "test-device-token",
              "test-device-label",
            );
          },
        ),
      );
    } else if (state.loginSendOtpStatus == LoginStatus.error) {
      LoadingDialog.hide(context);
      final errorMessage = state.errorMessage ?? Strings.errorOccurred;
      // Clear error after showing it to prevent it from showing again
      context.read<LoginCubit>().clearLoginSendOtpError();
      ErrorDialog.show(context: context, message: errorMessage);
    }

    // Handle login verify OTP status
    if (state.loginVerifyOtpStatus == LoginStatus.loading) {
      // Loading is handled inside the OTP dialog
    } else if (state.loginVerifyOtpStatus == LoginStatus.success) {
      Navigator.pop(context); // Dismiss OTP Dialog
      // Login success is handled by main status success which navigates to roots
    } else if (state.loginVerifyOtpStatus == LoginStatus.error) {
      // Error message will be shown inside the OTP dialog
      // No need to show additional dialog here
    }
  }
}
