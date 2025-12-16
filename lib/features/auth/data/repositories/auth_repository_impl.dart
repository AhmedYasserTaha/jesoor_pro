import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/domain/entities/user_entity.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final InternetConnectionChecker networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        final remoteUser = await remoteDataSource.login(email, password);
        // TODO: Cache user token/data locally
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(SignupParams params) async {
    if (await networkInfo.hasConnection) {
      try {
        final remoteUser = await remoteDataSource.signup(params);
        return Right(remoteUser);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "No Internet Connection"));
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
      return const Left(CacheFailure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    if (await networkInfo.hasConnection) {
      try {
        await remoteDataSource.verifyOtp(phone, otp, deviceToken, deviceLabel);
        return const Right(null);
      } on ServerException catch (failure) {
        return Left(ServerFailure(message: failure.message));
      }
    } else {
      return const Left(CacheFailure(message: "No Internet Connection"));
    }
  }
}
