import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/features/auth/login/domain/entities/user_entity.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final LoginStatus loginSendOtpStatus;
  final LoginStatus loginVerifyOtpStatus;
  final String? loginPhone;
  final bool isPasswordVisible;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
    this.loginSendOtpStatus = LoginStatus.initial,
    this.loginVerifyOtpStatus = LoginStatus.initial,
    this.loginPhone,
    this.isPasswordVisible = true,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserEntity? user,
    String? errorMessage,
    LoginStatus? loginSendOtpStatus,
    LoginStatus? loginVerifyOtpStatus,
    String? loginPhone,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      loginSendOtpStatus: loginSendOtpStatus ?? this.loginSendOtpStatus,
      loginVerifyOtpStatus: loginVerifyOtpStatus ?? this.loginVerifyOtpStatus,
      loginPhone: loginPhone ?? this.loginPhone,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    loginSendOtpStatus,
    loginVerifyOtpStatus,
    loginPhone,
    isPasswordVisible,
  ];
}
