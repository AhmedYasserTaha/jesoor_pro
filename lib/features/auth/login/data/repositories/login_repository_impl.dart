import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/storage/token_storage.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/auth_local_data_source.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/login/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/login/domain/repositories/login_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final InternetConnectionChecker networkInfo;
  final TokenStorage tokenStorage;

  LoginRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
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
        // Cache user data
        await localDataSource.cacheUser(remoteUser);
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
        // Cache user data
        await localDataSource.cacheUser(remoteUser);
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "لا يوجد اتصال بالإنترنت"));
    }
  }
}
