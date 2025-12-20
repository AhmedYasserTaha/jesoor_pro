import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;
  final LoginSendOtpUseCase loginSendOtpUseCase;
  final LoginVerifyOtpUseCase loginVerifyOtpUseCase;

  LoginCubit({
    required this.loginUseCase,
    required this.loginSendOtpUseCase,
    required this.loginVerifyOtpUseCase,
  }) : super(const LoginState());

  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> login(String phone, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    final result = await loginUseCase(
      LoginParams(
        email: phone,
        password: password,
      ), // Using phone as email for now
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }

  Future<void> loginSendOtp(String phone) async {
    emit(state.copyWith(loginSendOtpStatus: LoginStatus.loading));
    final result = await loginSendOtpUseCase(LoginSendOtpParams(phone: phone));
    result.fold(
      (failure) => emit(
        state.copyWith(
          loginSendOtpStatus: LoginStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
          loginSendOtpStatus: LoginStatus.success,
          loginPhone: phone,
        ),
      ),
    );
  }

  Future<void> loginVerifyOtp(
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (state.loginPhone == null) {
      emit(
        state.copyWith(
          loginVerifyOtpStatus: LoginStatus.error,
          errorMessage: "رقم الهاتف مفقود",
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        loginVerifyOtpStatus: LoginStatus.loading,
        errorMessage: null,
      ),
    );
    final result = await loginVerifyOtpUseCase(
      LoginVerifyOtpParams(
        phone: state.loginPhone!,
        otp: otp,
        deviceToken: deviceToken,
        deviceLabel: deviceLabel,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          loginVerifyOtpStatus: LoginStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          loginVerifyOtpStatus: LoginStatus.success,
          status: LoginStatus.success,
          user: user,
        ),
      ),
    );
  }

  void clearLoginSendOtpError() {
    if (state.loginSendOtpStatus == LoginStatus.error) {
      emit(
        state.copyWith(
          loginSendOtpStatus: LoginStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }

  void clearLoginVerifyOtpError() {
    if (state.loginVerifyOtpStatus == LoginStatus.error) {
      emit(
        state.copyWith(
          loginVerifyOtpStatus: LoginStatus.initial,
          errorMessage: null,
        ),
      );
    }
  }
}
