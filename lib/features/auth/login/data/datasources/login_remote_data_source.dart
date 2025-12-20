import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/features/auth/login/data/models/user_model.dart';

abstract class LoginRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> loginSendOtp(String phone);
  Future<UserModel> loginVerifyOtp(
    String phone,
    String otp,
    String deviceToken,
    String deviceLabel,
  );
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  final ApiConsumer apiConsumer;

  LoginRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> loginSendOtp(String phone) async {
    await apiConsumer.post(EndPoints.loginSendOtp, body: {'phone': phone});
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
}
