import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/usecases/forgot_password_reset_use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/usecases/forgot_password_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/presentation/cubit/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordSendOtpUseCase forgotPasswordSendOtpUseCase;
  final ForgotPasswordResetUseCase forgotPasswordResetUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordSendOtpUseCase,
    required this.forgotPasswordResetUseCase,
  }) : super(const ForgotPasswordState());

  Future<void> forgotPasswordSendOtp(String phone) async {
    emit(
      state.copyWith(forgotPasswordSendOtpStatus: ForgotPasswordStatus.loading),
    );
    final result = await forgotPasswordSendOtpUseCase(
      ForgotPasswordSendOtpParams(phone: phone),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          forgotPasswordSendOtpStatus: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          forgotPasswordSendOtpStatus: ForgotPasswordStatus.success,
          phone: phone,
        ),
      ),
    );
  }

  Future<void> forgotPasswordReset(
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    if (state.phone == null) {
      emit(
        state.copyWith(
          forgotPasswordResetStatus: ForgotPasswordStatus.error,
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    emit(
      state.copyWith(forgotPasswordResetStatus: ForgotPasswordStatus.loading),
    );
    final result = await forgotPasswordResetUseCase(
      ForgotPasswordResetParams(
        phone: state.phone!,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          forgotPasswordResetStatus: ForgotPasswordStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(forgotPasswordResetStatus: ForgotPasswordStatus.success),
      ),
    );
  }
}
