import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for authentication tokens
class TokenStorage {
  static const String _tokenKey = 'access_token';
  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  /// Save access token securely
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
    } catch (e) {
      // If secure storage fails, log error but don't crash
      // In production, you might want to use a fallback storage
      print('Error saving token to secure storage: $e');
      rethrow;
    }
  }

  /// Get access token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      // If secure storage fails, return null
      print('Error reading token from secure storage: $e');
      return null;
    }
  }

  /// Delete access token (for logout)
  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      print('Error deleting token from secure storage: $e');
      // Don't rethrow for delete operations
    }
  }

  /// Check if token exists
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
