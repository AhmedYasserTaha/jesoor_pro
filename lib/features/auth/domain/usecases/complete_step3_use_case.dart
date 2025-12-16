import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';

class CompleteStep3UseCase implements UseCase<void, CompleteStep3Params> {
  final AuthRepository repository;

  CompleteStep3UseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(CompleteStep3Params params) {
    return repository.completeStep3(params);
  }
}

class CompleteStep3Params extends Equatable {
  final int categoryId;

  const CompleteStep3Params({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
