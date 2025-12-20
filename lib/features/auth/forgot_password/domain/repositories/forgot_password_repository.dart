import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, void>> forgotPasswordSendOtp(String phone);
  Future<Either<Failure, void>> forgotPasswordReset(
    String phone,
    String otp,
    String newPassword,
    String confirmPassword,
  );
}
