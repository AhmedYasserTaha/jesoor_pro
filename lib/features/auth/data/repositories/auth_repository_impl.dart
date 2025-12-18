import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/storage/token_storage.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/domain/entities/category_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/governorate_entity.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final InternetConnectionChecker networkInfo;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        // Store token securely
        await tokenStorage.saveToken(remoteUser.token);
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, void>> loginSendOtp(String phone) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.loginSendOtp(phone);
        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginVerifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        final remoteUser = await remoteDataSource.loginVerifyOtp(
          phone,
          otp,
          deviceToken,
          deviceLabel,
        );
        // Store token securely
        await tokenStorage.saveToken(remoteUser.token);
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(SignupParams params) async {
    if (await networkInfo.hasConnection) {
      try {
        final remoteUser = await remoteDataSource.signup(params);
        // Store token securely
        await tokenStorage.saveToken(remoteUser.token);
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp(String name, String phone) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.sendOtp(name, phone);
        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        final token = await remoteDataSource.verifyOtp(
          phone,
          otp,
          deviceToken,
          deviceLabel,
        );
        // Store token securely
        await tokenStorage.saveToken(token);
        return Right(token);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, void>> completeStep2(
    CompleteStep2Params params,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.completeStep2(params);
        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, void>> completeStep3(
    CompleteStep3Params params,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.completeStep3(params);
        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.hasConnection) {
      try {
        final categories = await remoteDataSource.getCategories();
        return Right(categories);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategoryChildren(
    int categoryId,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        final children = await remoteDataSource.getCategoryChildren(categoryId);
        return Right(children);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, List<GovernorateEntity>>> getGovernorates() async {
    if (await networkInfo.hasConnection) {
      try {
        final governorates = await remoteDataSource.getGovernorates();
        return Right(governorates);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPasswordSendOtp(String phone) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.forgotPasswordSendOtp(phone);
        return const Right(null);
      } on ServerException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } on NotFoundException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } on UnauthorizedException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      }
    } else {
      return Left(CacheFailure(message: Strings.noInternetConnection));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPasswordReset(
    String phone,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.forgotPasswordReset(
          phone,
          otp,
          newPassword,
          confirmPassword,
        );
        return const Right(null);
      } on ServerException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } on NotFoundException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } on UnauthorizedException catch (_) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      } catch (e) {
        return Left(ServerFailure(message: Strings.errorOccurred));
      }
    } else {
      return Left(CacheFailure(message: Strings.noInternetConnection));
    }
  }
}
