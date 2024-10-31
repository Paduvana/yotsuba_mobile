// services/dashboard_service.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

class UserProfileService {
  final authService = AuthService();

  Future<Map<String, dynamic>> fetchUserProfileData(
      BuildContext context) async {
    String? userCd = await authService.getUserCd();
    if (userCd != null) {
      final url = Uri.parse(ApiConstants.userProfile(userCd));
      final response = await authService.makeAuthenticatedRequest(url, context);
      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception(
            'Failed to load user data. Status code: ${response.statusCode}');
      }
    } else {
      throw Exception('Failed to load user data.');
    }
  }

  Future<void> updateUserProfile(
    BuildContext context, {
    required String name,
    required String email,
    String? password,
    File? avatar,
  }) async {
    String? userCd = await authService.getUserCd();
    if (userCd == null) {
      throw Exception('User not found');
    }

    final url = Uri.parse(ApiConstants.userProfile(userCd));

    // Prepare body data
    Map<String, dynamic> body = {
      'name': name,
      'email': email,
    };
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    Map<String, File>? files;
    if (avatar != null) {
      files = {'avatar': avatar};
    }

    try {
      final response = await authService.makeAuthenticatedRequest(
        url,
        context,
        method: 'PUT',
        body: body,
        files: files,
      );

      if (response.statusCode != 200) {
        Map<String, dynamic> errorData = jsonDecode(response.body);
        throw Exception(errorData['detail'] ?? 'Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }
}
