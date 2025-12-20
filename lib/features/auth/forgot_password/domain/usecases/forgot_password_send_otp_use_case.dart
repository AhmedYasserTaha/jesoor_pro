import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordSendOtpUseCase
    implements UseCase<void, ForgotPasswordSendOtpParams> {
  final ForgotPasswordRepository repository;

  ForgotPasswordSendOtpUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(ForgotPasswordSendOtpParams params) {
    return repository.forgotPasswordSendOtp(params.phone);
  }
}

class ForgotPasswordSendOtpParams extends Equatable {
  final String phone;

  const ForgotPasswordSendOtpParams({required this.phone});

  @override
  List<Object> get props => [phone];
}
