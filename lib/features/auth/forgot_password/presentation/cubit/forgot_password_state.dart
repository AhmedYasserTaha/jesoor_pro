import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus forgotPasswordSendOtpStatus;
  final ForgotPasswordStatus forgotPasswordResetStatus;
  final String? errorMessage;
  final String? phone;

  const ForgotPasswordState({
    this.forgotPasswordSendOtpStatus = ForgotPasswordStatus.initial,
    this.forgotPasswordResetStatus = ForgotPasswordStatus.initial,
    this.errorMessage,
    this.phone,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? forgotPasswordSendOtpStatus,
    ForgotPasswordStatus? forgotPasswordResetStatus,
    String? errorMessage,
    String? phone,
  }) {
    return ForgotPasswordState(
      forgotPasswordSendOtpStatus:
          forgotPasswordSendOtpStatus ?? this.forgotPasswordSendOtpStatus,
      forgotPasswordResetStatus:
          forgotPasswordResetStatus ?? this.forgotPasswordResetStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      phone: phone ?? this.phone,
    );
  }

  @override
  List<Object?> get props => [
    forgotPasswordSendOtpStatus,
    forgotPasswordResetStatus,
    errorMessage,
    phone,
  ];
}
