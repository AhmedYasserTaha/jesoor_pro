import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/repositories/signup_repository.dart';

class GetGovernoratesUseCase
    implements UseCase<List<GovernorateEntity>, NoParams> {
  final SignupRepository repository;

  GetGovernoratesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<GovernorateEntity>>> call(NoParams params) {
    return repository.getGovernorates();
  }
}
