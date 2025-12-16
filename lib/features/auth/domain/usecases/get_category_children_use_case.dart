import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';

class GetCategoryChildrenUseCase
    implements UseCase<List<CategoryEntity>, GetCategoryChildrenParams> {
  final AuthRepository repository;

  GetCategoryChildrenUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
    GetCategoryChildrenParams params,
  ) {
    return repository.getCategoryChildren(params.categoryId);
  }
}

class GetCategoryChildrenParams extends Equatable {
  final int categoryId;

  const GetCategoryChildrenParams({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

