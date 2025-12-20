import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/login/domain/entities/user_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, void>> loginSendOtp(String phone);
  Future<Either<Failure, UserEntity>> loginVerifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
  Future<Either<Failure, UserEntity?>> getCachedUser();
}
