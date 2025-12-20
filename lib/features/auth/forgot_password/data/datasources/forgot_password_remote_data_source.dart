import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<void> forgotPasswordSendOtp(String phone);
  Future<void> forgotPasswordReset(
    String phone,
    String otp,
    String newPassword,
    String confirmPassword,
  );
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final ApiConsumer apiConsumer;

  ForgotPasswordRemoteDataSourceImpl({required this.apiConsumer});

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
