import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Create storage
  final _storage = const FlutterSecureStorage();

  // Save token
  Future<void> storeToken(String accessToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
  }

  // Retrieve token
  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'access_token');
  }
}