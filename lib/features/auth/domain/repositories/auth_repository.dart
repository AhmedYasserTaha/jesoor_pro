import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> signup(
    String username,
    String email,
    String password,
  );
}
