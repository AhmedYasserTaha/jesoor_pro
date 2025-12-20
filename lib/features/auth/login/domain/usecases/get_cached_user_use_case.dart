import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/login/domain/repositories/login_repository.dart';

class GetCachedUserUseCase implements UseCase<UserEntity?, NoParams> {
  final LoginRepository repository;

  GetCachedUserUseCase({required this.repository});

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCachedUser();
  }
}
