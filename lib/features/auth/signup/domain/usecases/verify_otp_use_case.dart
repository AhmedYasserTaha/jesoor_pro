import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/signup/domain/repositories/signup_repository.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';

class VerifyOtpUseCase implements UseCase<String, VerifyOtpParams> {
  final SignupRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(
      params.phone,
      params.otp,
      params.deviceToken,
      params.deviceLabel,
    );
  }
}

class VerifyOtpParams {
  final String phone;
  final String otp;
  final String deviceToken;
  final String deviceLabel;

  VerifyOtpParams({
    required this.phone,
    required this.otp,
    required this.deviceToken,
    required this.deviceLabel,
  });
}
