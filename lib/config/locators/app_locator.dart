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
import 'package:jesoor_pro/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:jesoor_pro/features/auth/data/datasources/auth_local_data_source_impl.dart';
import 'package:jesoor_pro/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:jesoor_pro/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:jesoor_pro/features/auth/domain/repositories/auth_repository.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/forgot_password_reset_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/forgot_password_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_categories_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_category_children_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/get_governorates_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/login_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/send_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:jesoor_pro/features/auth/presentation/cubit/auth_cubit.dart';

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
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      loginSendOtpUseCase: sl(),
      loginVerifyOtpUseCase: sl(),
      signupUseCase: sl(),
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      forgotPasswordSendOtpUseCase: sl(),
      forgotPasswordResetUseCase: sl(),
      completeStep2UseCase: sl(),
      completeStep3UseCase: sl(),
      getCategoriesUseCase: sl(),
      getCategoryChildrenUseCase: sl(),
      getGovernoratesUseCase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginSendOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => LoginVerifyOtpUseCase(repository: sl()));
  sl.registerLazySingleton(() => SignupUseCase(repository: sl()));
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(
    () => ForgotPasswordSendOtpUseCase(repository: sl()),
  );
  sl.registerLazySingleton(() => ForgotPasswordResetUseCase(repository: sl()));
  sl.registerLazySingleton(() => CompleteStep2UseCase(repository: sl()));
  sl.registerLazySingleton(() => CompleteStep3UseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetCategoryChildrenUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetGovernoratesUseCase(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      networkInfo: sl(),
      remoteDataSource: sl(),
      localDataSource: sl(),
      tokenStorage: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Local Data Source
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
