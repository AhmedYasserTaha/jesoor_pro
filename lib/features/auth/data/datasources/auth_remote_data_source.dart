import 'package:jesoor_pro/core/api/api_consumer.dart';
import 'package:jesoor_pro/core/api/end_points.dart';
import 'package:jesoor_pro/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup(String username, String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await apiConsumer.post(
      EndPoints.baseUrl + 'auth/login', // Update endpoint as needed
      body: {'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signup(
    String username,
    String email,
    String password,
  ) async {
    final response = await apiConsumer.post(
      EndPoints.baseUrl + 'auth/signup', // Update endpoint as needed
      body: {'username': username, 'email': email, 'password': password},
    );
    return UserModel.fromJson(response);
  }
}
