import 'package:dio/dio.dart';
import 'package:jesoor_pro/core/storage/token_storage.dart';

/// Interceptor that automatically adds Authorization Bearer token to requests
/// Only adds token to protected endpoints (not public endpoints like categories, governorates)
class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final List<String> publicEndpoints = [
    'auth/register/send-otp',
    'auth/register/verify-otp',
    'auth/login',
    'auth/login/send-otp',
    'auth/login/verify-otp',
    'auth/categories',
    'auth/governorates',
    'auth/forgot-password/send-otp',
    'auth/forgot-password/reset',
  ];

  AuthInterceptor({required this.tokenStorage});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add Accept header
    options.headers['Accept'] = 'application/json';

    // Check if this is a public endpoint
    final isPublicEndpoint = publicEndpoints.any(
      (endpoint) => options.path.contains(endpoint),
    );

    // Only add Authorization header for protected endpoints
    if (!isPublicEndpoint) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    super.onRequest(options, handler);
  }
}
