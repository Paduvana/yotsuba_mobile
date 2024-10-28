import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yotsuba_mobile/screens/Login.dart';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'dart:typed_data';

class AuthService {
  // Create storage
  final _storage = const FlutterSecureStorage();
  final String refreshTokenUrl = ApiConstants.refreshTokenEndpoint;
  // Save token
  Future<void> storeToken(String accessToken, String refreshToken) async {
    await _storage.write(key: 'access_token', value: accessToken);
    await _storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<void> storeUser(String userCd) async {
    await _storage.write(key: 'cd', value: userCd);
  }

  Future<String?> getUserCd() async {
    return await _storage.read(key: 'cd');
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

  Future<dynamic> makeAuthenticatedRequest(
    Uri url,
    BuildContext context, {
    String method = 'GET',
    Map<String, dynamic>? body,
    Map<String, File>? files,
  }) async {
    String? accessToken = await getAccessToken();

    final response = await _makeHttpRequest(
      url,
      method,
      accessToken,
      body,
      files,
    );

    if ((response.statusCode == 401 || response.statusCode == 403) &&
        response.body.contains('"token_not_valid"') &&
        response.body.contains('"token_type":"access"')) {
      try {
        await refreshAccessToken();
        accessToken = await getAccessToken();
        return await _makeHttpRequest(url, method, accessToken, body, files);
      } catch (e) {
        await deleteTokens();
        _redirectToLoginPage(context);
        throw Exception('Session expired. Please login again.');
      }
    }

    return response;
  }

    Future<dynamic> _makeHttpRequest(
    Uri url,
    String method,
    String? accessToken,
    Map<String, dynamic>? body,
    Map<String, File>? files,
  ) async {
    // If there are files, use multipart request
    if (files != null && files.isNotEmpty) {
      var request = http.MultipartRequest(method, url);
      
      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      });

      // Add text fields
      if (body != null) {
        body.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value.toString();
          }
        });
      }

      // Add files
      for (var entry in files.entries) {
        if (entry.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      // Send request and convert to Response
      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } 
    // Regular JSON request
    else {
      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        if (accessToken != null) 'Authorization': 'Bearer $accessToken',
      };

      switch (method) {
        case 'POST':
          return await http.post(
            url,
            headers: headers,
            body: jsonEncode(body),
            encoding: Encoding.getByName('utf-8'),
          );
        case 'PUT':
          return await http.put(
            url,
            headers: headers,
            body: jsonEncode(body),
            encoding: Encoding.getByName('utf-8'),
          );
        default:
          return await http.get(url, headers: headers);
      }
    }
  }
  void _redirectToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
