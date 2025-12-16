import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> signup(SignupParams params);
  Future<Either<Failure, void>> sendOtp(String name, String phone);
  Future<Either<Failure, void>> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
}
