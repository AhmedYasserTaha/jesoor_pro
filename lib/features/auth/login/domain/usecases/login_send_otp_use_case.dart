import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/repositories/login_repository.dart';

class LoginSendOtpUseCase implements UseCase<void, LoginSendOtpParams> {
  final LoginRepository repository;

  LoginSendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(LoginSendOtpParams params) {
    return repository.loginSendOtp(params.phone);
  }
}

class LoginSendOtpParams extends Equatable {
  final String phone;

  const LoginSendOtpParams({required this.phone});

  @override
  List<Object> get props => [phone];
}
