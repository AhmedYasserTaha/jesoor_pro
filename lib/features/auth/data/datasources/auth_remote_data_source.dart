import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/features/auth/data/models/user_model.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(SignupParams params);
  Future<void> sendOtp(String name, String phone);
  Future<void> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signup(SignupParams params) async {
    final response = await apiConsumer.post(
      EndPoints.signup,
      body: {
        'username': params.username,
        'email': params.email,
        'password': params.password,
        'phone': params.parentPhone,
        'school_name': params.schoolName,
        'governorate': params.governorate,
        'education_system': params.educationSystem,
        'education_stage': params.educationStage,
        'education_grade': params.educationGrade,
      },
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> sendOtp(String name, String phone) async {
    await apiConsumer.post(
      EndPoints.sendOtp,
      body: {'name': name, 'phone': phone},
    );
  }

  @override
  Future<void> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    await apiConsumer.post(
      EndPoints.verifyOtp,
      body: {
        'phone': phone,
        'otp': otp,
        'device_token': deviceToken,
        'device_label': deviceLabel,
      },
    );
  }
}
