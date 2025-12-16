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
      // Don't dismiss OTP dialog on error, just show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            state.errorMessage ?? 'Invalid OTP',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
