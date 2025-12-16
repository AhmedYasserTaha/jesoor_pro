import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/features/auth/data/models/category_model.dart';
import 'package:jesoor_pro/features/auth/data/models/governorate_model.dart';
import 'package:jesoor_pro/features/auth/data/models/user_model.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step2_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/complete_step3_use_case.dart';
import 'package:jesoor_pro/features/auth/domain/usecases/signup_use_case.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> loginSendOtp(String phone);
  Future<UserModel> loginVerifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
  Future<UserModel> signup(SignupParams params);
  Future<void> sendOtp(String name, String phone);
  Future<void> verifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
  Future<void> forgotPasswordSendOtp(String phone);
  Future<void> forgotPasswordReset(
    String phone,
    String otp,
    String newPassword,
    String confirmPassword,
  );
  Future<void> completeStep2(CompleteStep2Params params);
  Future<void> completeStep3(CompleteStep3Params params);
  Future<List<CategoryModel>> getCategories();
  Future<List<CategoryModel>> getCategoryChildren(int categoryId);
  Future<List<GovernorateModel>> getGovernorates();
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

  @override
  Future<void> completeStep2(CompleteStep2Params params) async {
    final body = <String, dynamic>{
      'guardian_phone': params.guardianPhone,
      'school_name': params.schoolName,
      'governorate': params.governorate,
    };
    if (params.secondGuardianPhone != null &&
        params.secondGuardianPhone!.isNotEmpty) {
      body['second_guardian_phone'] = params.secondGuardianPhone;
    }
    await apiConsumer.post(EndPoints.completeStep2, body: body);
  }

  @override
  Future<void> completeStep3(CompleteStep3Params params) async {
    await apiConsumer.post(
      EndPoints.completeStep3,
      body: {'category_id': params.categoryId},
    );
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiConsumer.get(EndPoints.categories);
    // Handle response structure: {status, message, data: [...]}
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        return data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<List<CategoryModel>> getCategoryChildren(int categoryId) async {
    final response = await apiConsumer.get(EndPoints.categoryChildren(categoryId));
    // Handle response structure: {status, message, data: [...]}
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        return data
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<List<GovernorateModel>> getGovernorates() async {
    final response = await apiConsumer.get(EndPoints.governorates);
    // Handle response structure: {status, message, data: [...]}
    if (response is Map<String, dynamic> && response.containsKey('data')) {
      final data = response['data'];
      if (data is List) {
        return data
            .map((json) =>
                GovernorateModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }

  @override
  Future<void> loginSendOtp(String phone) async {
    await apiConsumer.post(
      EndPoints.loginSendOtp,
      body: {'phone': phone},
    );
  }

  @override
  Future<UserModel> loginVerifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  ) async {
    final response = await apiConsumer.post(
      EndPoints.loginVerifyOtp,
      body: {
        'phone': phone,
        'otp': otp,
        'device_token': deviceToken,
        'device_label': deviceLabel,
      },
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> forgotPasswordSendOtp(String phone) async {
    await apiConsumer.post(
      EndPoints.forgotPasswordSendOtp,
      body: {'phone': phone},
    );
  }

  @override
  Future<void> forgotPasswordReset(
    String phone,
    String otp,
    String newPassword,
    String confirmPassword,
  ) async {
    await apiConsumer.post(
      EndPoints.forgotPasswordReset,
      body: {
        'phone': phone,
        'otp': otp,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
      },
    );
  }
}
