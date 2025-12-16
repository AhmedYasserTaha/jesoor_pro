import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/usecases/use_case.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';

class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, NoParams> {
  final AuthRepository repository;

  GetCategoriesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(NoParams params) {
    return repository.getCategories();
  }
}
