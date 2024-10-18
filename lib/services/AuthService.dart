import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yotsuba_mobile/screens/LoginWidget.dart';
import 'package:yotsuba_mobile/services/APIConstants.dart';

class AuthService {
  // Create storage
  final _storage = const FlutterSecureStorage();
  final String refreshTokenUrl = ApiConstants.refreshTokenEndpoint;
  // Save token
  Future<void> storeToken(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  // Retrieve token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Delete token
  Future<void> deleteTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<void> refreshAccessToken() async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available.');
    }

    final response = await http.post(
      Uri.parse(refreshTokenUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String newAccessToken = data['access'];
      await storeToken(newAccessToken, refreshToken);
    } else {
      throw Exception('Failed to refresh access token.');
    }
  }

  Future<http.Response> makeAuthenticatedRequest(Uri url,BuildContext context,
      {String method = 'GET', Map<String, dynamic>? body}) async {
    String? accessToken = await getAccessToken();

    final response = await _makeHttpRequest(url, method, accessToken, body);

    if ((response.statusCode == 401 || response.statusCode == 403)  &&
        response.body.contains('"token_not_valid"') &&
        response.body.contains('"token_type":"access"')) {
      try {
        await refreshAccessToken();
        accessToken = await getAccessToken();
        return await _makeHttpRequest(url, method, accessToken, body);
      } catch (e) {
        await deleteTokens();
        _redirectToLoginPage(context);
        throw Exception('Session expired. Please login again.');
      }
    }

    return response;
  }

  Future<http.Response> _makeHttpRequest(Uri url, String method,
      String? accessToken, Map<String, dynamic>? body) async {
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    if (method == 'POST') {
      return await http.post(url,
          headers: headers, body: jsonEncode(body));
    } else {
      return await http.get(url, headers: headers);
    }
  }

  void _redirectToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginWidget()),
    );
  }
}
