import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/auth_interceptor.dart';
import 'package:jesoor_pro/core/api/dio_consumer.dart';
import 'package:jesoor_pro/core/api/interceptors.dart';
import 'package:jesoor_pro/core/cache/hive_constants.dart';
import 'package:jesoor_pro/core/cache/hive_helper.dart';
import 'package:jesoor_pro/core/storage/token_storage.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/auth_local_data_source.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/auth_local_data_source_impl.dart';
import 'package:jesoor_pro/features/auth/signup/data/datasources/auth_local_data_source.dart'
    as signup_auth;
import 'package:jesoor_pro/features/auth/signup/data/datasources/auth_local_data_source_impl.dart'
    as signup_auth_impl;
import 'package:jesoor_pro/features/auth/forgot_password/data/datasources/forgot_password_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/login/data/datasources/login_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/signup/data/datasources/signup_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/forgot_password/data/repositories/forgot_password_repository_impl.dart';
import 'package:jesoor_pro/features/auth/login/data/repositories/login_repository_impl.dart';
import 'package:jesoor_pro/features/auth/signup/data/repositories/signup_repository_impl.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/repositories/forgot_password_repository.dart';
import 'package:jesoor_pro/features/auth/login/domain/repositories/login_repository.dart';
import 'package:jesoor_pro/features/auth/signup/domain/repositories/signup_repository.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/usecases/forgot_password_reset_use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/domain/usecases/forgot_password_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_category_children_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/get_governorates_use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/login/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/signup/domain/usecases/verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/forgot_password/presentation/cubit/forgot_password_cubit.dart';
import 'package:jesoor_pro/features/auth/login/presentation/cubit/login_cubit.dart';
import 'package:jesoor_pro/features/auth/signup/presentation/cubit/signup_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Hive Boxes (Hive should be initialized in main.dart before calling init())
  sl.registerLazySingleton<Box<String>>(
    () => HiveHelper.getCategoriesBox(),
    instanceName: HiveConstants.categoriesBox,
  );
  sl.registerLazySingleton<Box<String>>(
    () => HiveHelper.getCategoryChildrenBox(),
    instanceName: HiveConstants.categoryChildrenBox,
  );
  sl.registerLazySingleton<Box<String>>(
    () => HiveHelper.getGovernoratesBox(),
    instanceName: HiveConstants.governoratesBox,
  );
  sl.registerLazySingleton<Box<String>>(
    () => HiveHelper.getUserBox(),
    instanceName: HiveConstants.userBox,
  );

  //! Features - Auth
  // Cubits
  sl.registerFactory(
    () => LoginCubit(
      loginUseCase: sl(),
      loginSendOtpUseCase: sl(),
      loginVerifyOtpUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => SignupCubit(
      signupUseCase: sl(),
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      completeStep2UseCase: sl(),
      completeStep3UseCase: sl(),
      getCategoriesUseCase: sl(),
      getCategoryChildrenUseCase: sl(),
      getGovernoratesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => ForgotPasswordCubit(
      forgotPasswordSendOtpUseCase: sl(),
      forgotPasswordResetUseCase: sl(),
    ),
  );

  // Use cases - Login
  sl.registerLazySingleton(
    () => LoginUseCase(repository: sl<LoginRepository>()),
  );
  sl.registerLazySingleton(
    () => LoginSendOtpUseCase(repository: sl<LoginRepository>()),
  );
  sl.registerLazySingleton(
    () => LoginVerifyOtpUseCase(repository: sl<LoginRepository>()),
  );

  // Use cases - Signup
  sl.registerLazySingleton(
    () => SignupUseCase(repository: sl<SignupRepository>()),
  );
  sl.registerLazySingleton(() => SendOtpUseCase(sl<SignupRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<SignupRepository>()));
  sl.registerLazySingleton(
    () => CompleteStep2UseCase(repository: sl<SignupRepository>()),
  );
  sl.registerLazySingleton(
    () => CompleteStep3UseCase(repository: sl<SignupRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCategoriesUseCase(repository: sl<SignupRepository>()),
  );
  sl.registerLazySingleton(
    () => GetCategoryChildrenUseCase(repository: sl<SignupRepository>()),
  );
  sl.registerLazySingleton(
    () => GetGovernoratesUseCase(repository: sl<SignupRepository>()),
  );

  // Use cases - Forgot Password
  sl.registerLazySingleton(
    () => ForgotPasswordSendOtpUseCase(
      repository: sl<ForgotPasswordRepository>(),
    ),
  );
  sl.registerLazySingleton(
    () =>
        ForgotPasswordResetUseCase(repository: sl<ForgotPasswordRepository>()),
  );

  // Data sources
  sl.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(apiConsumer: sl()),
  );

  sl.registerLazySingleton<SignupRemoteDataSource>(
    () => SignupRemoteDataSourceImpl(apiConsumer: sl()),
  );

  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Local Data Sources
  // Login AuthLocalDataSource
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      categoriesBox: sl<Box<String>>(instanceName: HiveConstants.categoriesBox),
      categoryChildrenBox: sl<Box<String>>(
        instanceName: HiveConstants.categoryChildrenBox,
      ),
      governoratesBox: sl<Box<String>>(
        instanceName: HiveConstants.governoratesBox,
      ),
      userBox: sl<Box<String>>(instanceName: HiveConstants.userBox),
    ),
  );

  // Signup AuthLocalDataSource
  sl.registerLazySingleton<signup_auth.AuthLocalDataSource>(
    () => signup_auth_impl.AuthLocalDataSourceImpl(
      categoriesBox: sl<Box<String>>(instanceName: HiveConstants.categoriesBox),
      categoryChildrenBox: sl<Box<String>>(
        instanceName: HiveConstants.categoryChildrenBox,
      ),
      governoratesBox: sl<Box<String>>(
        instanceName: HiveConstants.governoratesBox,
      ),
      userBox: sl<Box<String>>(instanceName: HiveConstants.userBox),
    ),
  );

  // Repositories
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl<LoginRemoteDataSource>(),
      localDataSource: sl<AuthLocalDataSource>(),
      tokenStorage: sl(),
    ),
  );

  sl.registerLazySingleton<SignupRepository>(
    () => SignupRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl<SignupRemoteDataSource>(),
      localDataSource: sl<signup_auth.AuthLocalDataSource>(),
      tokenStorage: sl(),
    ),
  );

  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl<ForgotPasswordRemoteDataSource>(),
    ),
  );

  //! Core
  // Storage
  sl.registerLazySingleton(() => TokenStorage());

  //! Core
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));

  //! External
  sl.registerLazySingleton(() => AppInterceptors());
  sl.registerLazySingleton(() => AuthInterceptor(tokenStorage: sl()));
  sl.registerLazySingleton(() => CookieJar());
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
  sl.registerLazySingleton(() {
    final dio = Dio();
    // Add interceptors in order: CookieManager first, then AuthInterceptor, then AppInterceptors
    dio.interceptors.add(CookieManager(sl<CookieJar>()));
    dio.interceptors.add(sl<AuthInterceptor>());
    return dio;
  });
}
