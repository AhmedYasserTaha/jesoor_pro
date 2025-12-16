import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/dio_consumer.dart';
import 'package:jesoor_pro/core/api/interceptors.dart';
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
