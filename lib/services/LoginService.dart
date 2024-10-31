// lib/services/LoginService.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AuthService.dart';
import 'package:flutter/material.dart';
import 'APIConstants.dart';

enum LoginResult { success, failure, error }

Future<LoginResult> loginService(
  BuildContext context,
  String username,
  String password,
  Function(bool) setLoading,
) async {
  if (username.isEmpty || password.isEmpty) {
    _showErrorDialog(context, 'IDとパスワードを入力してください。');
    return LoginResult.failure;
  }

  print('Login URL: ${ApiConstants.loginEndpoint}'); // Debug print

  setLoading(true);

  try {
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );

    print('Response status: ${response.statusCode}'); // Debug print
    print('Response body: ${response.body}'); // Debug print

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));

      // Debug prints
      print('Decoded data: $data');
      print('Access token: ${data['access_token']}');
      print('Refresh token: ${data['refresh_token']}');
      print('User CD: ${data['cd']}');

      final String? accessToken = data['access_token'];
      final String? refreshToken = data['refresh_token'];
      final String? userCd = data['cd'];

      if (accessToken != null && refreshToken != null && userCd != null) {
        final authService = AuthService();
        await authService.storeToken(accessToken, refreshToken);
        await authService.storeUser(userCd);
        return LoginResult.success;
      } else {
        _showErrorDialog(
          context,
          '認証に失敗しました。もう一度お試しください。',
        );
      }
    } else if (response.statusCode == 401) {
      _showErrorDialog(
        context,
        'IDまたはパスワードが間違っています。',
      );
    } else {
      try {
        final errorData = jsonDecode(utf8.decode(response.bodyBytes));
        _showErrorDialog(
          context,
          errorData['detail'] ?? 'ログインに失敗しました。',
        );
      } catch (e) {
        _showErrorDialog(
          context,
          'ログインに失敗しました。もう一度お試しください。',
        );
      }
    }
  } catch (e) {
    print('Login error: $e'); // Debug print
    _showErrorDialog(
      context,
      'ネットワークエラーが発生しました。インターネット接続を確認してください。',
    );
  } finally {
    setLoading(false);
  }

  return LoginResult.error;
}

void _showErrorDialog(BuildContext context, String message) {
  if (!context.mounted) return;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('エラー'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

// Extension to check if a BuildContext is mounted
extension BuildContextExt on BuildContext {
  bool get mounted {
    try {
      widget;
      return true;
    } catch (e) {
      return false;
    }
  }
}
