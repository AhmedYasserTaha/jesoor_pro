import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/login/domain/repositories/login_repository.dart';

class LoginVerifyOtpUseCase
    implements UseCase<UserEntity, LoginVerifyOtpParams> {
  final LoginRepository repository;

  LoginVerifyOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(LoginVerifyOtpParams params) {
    return repository.loginVerifyOtp(
      params.phone,
      params.otp,
      params.deviceToken,
      params.deviceLabel,
    );
  }
}

class LoginVerifyOtpParams extends Equatable {
  final String phone;
  final String otp;
  final String deviceToken;
  final String deviceLabel;

  const LoginVerifyOtpParams({
    required this.phone,
    required this.otp,
    required this.deviceToken,
    required this.deviceLabel,
  });

  @override
  List<Object> get props => [phone, otp, deviceToken, deviceLabel];
}
