import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/features/auth/data/models/user_model.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(SignupParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiConsumer.post(
      EndPoints.baseUrl + 'auth/login',
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signup(SignupParams params) async {
    final response = await apiConsumer.post(
      EndPoints.baseUrl + 'auth/signup',
      body: {
        'username': params.username,
        'email': params.email,
        'password': params.password,
        'phone': params
            .parentPhone, // Mapping parentPhone to phone? Or maybe there IS a phone field?
        'school_name': params.schoolName,
        'governorate': params.governorate,
        'education_system': params.educationSystem,
        'education_stage': params.educationStage,
        'education_grade': params.educationGrade,
      },
    );
    return UserModel.fromJson(response);
  }
}
