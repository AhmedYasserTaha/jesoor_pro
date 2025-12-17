import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/config/routes/routes.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_state.dart';
import '../screens/widgets/loading_dialog.dart';
import '../screens/widgets/otp_verification_dialog.dart';
import '../screens/widgets/error_dialog.dart';

/// Handles all BlocListener logic for auth state changes
class AuthListenerHandler {
  static void handleStateChange(BuildContext context, AuthState state) {
    // Handle main auth status (login/signup success/error)
    // Only handle main status if it's not related to step operations
    if (state.status == AuthStatus.success) {
      // Navigate to Roots screen after successful login or signup
      Future.microtask(() {
        if (context.mounted) {
          context.go(Routes.roots);
        }
      });
    } else if (state.status == AuthStatus.error &&
        state.completeStep2Status != AuthStatus.error &&
        state.completeStep3Status != AuthStatus.error &&
        state.getCategoriesStatus != AuthStatus.error) {
      // Show error dialog only for main auth errors, not step-specific errors
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
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
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }

    // Handle verify OTP status
    if (state.verifyOtpStatus == AuthStatus.success) {
      Navigator.pop(context); // Dismiss OTP Dialog
      // Move directly to step 2 without showing success dialog
      context.read<AuthCubit>().setSignupStep(2);
    } else if (state.verifyOtpStatus == AuthStatus.error) {
      // Error message will be shown inside the OTP dialog
      // No need to show additional dialog here
    }

    // Handle complete step 2 status
    if (state.completeStep2Status == AuthStatus.loading) {
      LoadingDialog.show(context);
    } else if (state.completeStep2Status == AuthStatus.success) {
      LoadingDialog.hide(context);
      // Step 2 completed, step 3 is already set by cubit
      // Load categories only once when step 3 is reached and categories are empty
      if (state.signupStep == 3) {
        final cubit = context.read<AuthCubit>();
        // Only load if categories are empty and not already loading
        if (state.categories.isEmpty &&
            state.getCategoriesStatus != AuthStatus.loading) {
          cubit.getCategories();
        }
      }
    } else if (state.completeStep2Status == AuthStatus.error) {
      LoadingDialog.hide(context);
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
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
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
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
      ErrorDialog.show(
        context: context,
        message: state.errorMessage ?? Strings.errorOccurred,
      );
    }
  }
}
