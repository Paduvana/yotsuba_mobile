// services/password_reset_service.dart
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:yotsuba_mobile/services/APIConstants.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';
import 'package:http/http.dart' as http;

class PasswordReissueService {
  final authService = AuthService();

  Future<Map<String, dynamic>> requestPasswordReset(String email, BuildContext context) async {
    final url = Uri.parse(ApiConstants.passwordReissueEndpoint);

    try {
      final response = await authService.makeAuthenticatedRequest(
        url,
        context,
        method: 'POST',
        body: {'email': email},
      );

      // Decode response explicitly using UTF-8 to handle special characters
      final decodedBody = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = jsonDecode(decodedBody);
        return {'success': true, 'message': data['message']};
      } else if (response.statusCode == 404) {
        final data = jsonDecode(decodedBody);
        return {'success': false, 'message': data['error']};
      } else if (response.statusCode == 503) {
        final data = jsonDecode(decodedBody);
        return {'success': false, 'message': data['error']};
      } else {
        return {
          'success': false,
          'message': 'Failed to send password reset request. Status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred. Please try again later.'};
    }
  }
}
