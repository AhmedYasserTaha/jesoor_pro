import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordResetUseCase
    implements UseCase<void, ForgotPasswordResetParams> {
  final ForgotPasswordRepository repository;

  ForgotPasswordResetUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ForgotPasswordResetParams params) {
    return repository.forgotPasswordReset(
      params.phone,
      params.otp,
      params.newPassword,
      params.confirmPassword,
    );
  }
}

class ForgotPasswordResetParams extends Equatable {
  final String phone;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  const ForgotPasswordResetParams({
    required this.phone,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [phone, otp, newPassword, confirmPassword];
}
