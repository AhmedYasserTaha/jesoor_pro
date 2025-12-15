import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) {
    return repository.signup(params.username, params.email, params.password);
  }
}

class SignupParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const SignupParams({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
