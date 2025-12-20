import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_cubit.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_state.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/loading_dialog.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/otp_verification_dialog.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/screens/widgets/error_dialog.dart';

/// Handles all BlocListener logic for signup state changes
class SignupListenerHandler {
  static void handleStateChange(BuildContext context, SignupState state) {
    // Handle main signup status (success/error)
    // Only handle main status if it's not related to step operations
    if (state.status == SignupStatus.success) {
      // Navigate to Roots screen after successful signup
      Future.microtask(() {
        if (context.mounted) {
          context.go(Routes.roots);
        }
      });
    } else if (state.status == SignupStatus.error &&
        state.completeStep2Status != SignupStatus.error &&
        state.completeStep3Status != SignupStatus.error &&
        state.getCategoriesStatus != SignupStatus.error) {
      // Show error dialog only for main signup errors, not step-specific errors
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }

    // Handle send OTP status
    if (state.sendOtpStatus == SignupStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.sendOtpStatus == SignupStatus.success) {
      LoadingDialog.hide(context);

      // Show OTP Dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => OtpVerificationDialog(
          phone: state.phone ?? '',
          onVerify: (otp) {
            context.read<SignupCubit>().verifyOtp(
              otp,
              "test-device-token",
              "test-device-label",
            );
          },
        ),
      );
    } else if (state.sendOtpStatus == SignupStatus.error) {
      LoadingDialog.hide(context);
      final errorMessage = state.errorMessage ?? Strings.errorOccurred;
      // Clear error after showing it to prevent it from showing again
      context.read<SignupCubit>().clearSendOtpError();
      ErrorDialog.show(context: context, message: errorMessage);
    }

    // Handle verify OTP status
    if (state.verifyOtpStatus == SignupStatus.success) {
      Navigator.pop(context); // Dismiss OTP Dialog
      // Move directly to step 2 without showing success dialog
      context.read<SignupCubit>().setSignupStep(2);
    } else if (state.verifyOtpStatus == SignupStatus.error) {
      // Error message will be shown inside the OTP dialog
      // No need to show additional dialog here
    }

    // Handle complete step 2 status
    // No loading dialog for step 2 - loading is handled by button state
    if (state.completeStep2Status == SignupStatus.success) {
      // Step 2 completed, step 3 is already set by cubit
      // Categories are loaded automatically by cubit.completeStep2()
      // No need to load here to avoid duplicate calls
    } else if (state.completeStep2Status == SignupStatus.error) {
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }

    // Handle get categories status
    // No loading dialog for step 3 - loading is handled by CircularProgressIndicator in the form
    if (state.getCategoriesStatus == SignupStatus.success) {
      // Categories loaded successfully, UI will display them
    } else if (state.getCategoriesStatus == SignupStatus.error) {
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }

    // Handle complete step 3 status
    // Loading overlay is handled in SignupForm widget, not here
    if (state.completeStep3Status == SignupStatus.success) {
      // Registration complete, handled by main status success
    } else if (state.completeStep3Status == SignupStatus.error) {
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }
  }
}
