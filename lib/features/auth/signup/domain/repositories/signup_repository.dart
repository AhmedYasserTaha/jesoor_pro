import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/signup_use_case.dart';

abstract class SignupRepository {
  Future<Either<Failure, UserEntity>> signup(SignupParams params);
  Future<Either<Failure, void>> sendOtp(String name, String phone);
  Future<Either<Failure, String>> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
  Future<Either<Failure, void>> completeStep2(CompleteStep2Params params);
  Future<Either<Failure, void>> completeStep3(CompleteStep3Params params);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<CategoryEntity>>> getCategoryChildren(
    int categoryId,
  );
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates();
}
