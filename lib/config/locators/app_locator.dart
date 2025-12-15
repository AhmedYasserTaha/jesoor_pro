import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/dio_consumer.dart';
import 'package:jesoor_pro/core/api/interceptors.dart';
import 'package:jesoor_pro/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), signupUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignupUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(networkInfo: sl(), remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl()),
  );

  //! Core
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  sl.registerLazySingleton(() => AppInterceptors());
  sl.registerLazySingleton(
    () => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ),
  );
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton(() => Dio());
}
