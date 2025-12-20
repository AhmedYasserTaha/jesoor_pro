import 'package:dartz/dartz.dart';
import 'package:jesoor_pro/core/error/exceptions.dart';
import 'package:jesoor_pro/core/error/failures.dart';
import 'package:jesoor_pro/core/utils/strings.dart';
import 'package:jesoor_pro/features/auth/forgot_password/data/datasources/forgot_password_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;
  final InternetConnectionChecker networkInfo;

  ForgotPasswordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

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
