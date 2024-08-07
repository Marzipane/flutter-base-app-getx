// lib/app/utils/token_storage.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Saves the token to secure storage.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Retrieves the token from secure storage.
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Deletes the token from secure storage.
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Checks if a token exists in secure storage.
  Future<bool> hasToken() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }
}
