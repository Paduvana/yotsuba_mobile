import 'package:http/http.dart' as http;
import 'dart:convert';
import 'AuthService.dart';
import 'package:flutter/material.dart';

enum LoginResult { success, failure, error }

Future<LoginResult> loginService(
    BuildContext context, String username, String password, Function(bool) setLoading) async {
  if (username.isEmpty || password.isEmpty) {
    _showErrorDialog(context, 'Please enter both username and password.');
    return LoginResult.failure;
  }

  const String url = 'http://127.0.0.1:8000/api/v1/login/';

  setLoading(true);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final String? accessToken = data['access_token'];

      if (accessToken != null) {
        await AuthService().storeToken(accessToken);
        return LoginResult.success;
      } else {
        _showErrorDialog(context, 'Failed to retrieve authentication tokens.');
      }
    } else {
      _showErrorDialog(context, 'Login failed. Please check your credentials.');
    }
  } catch (e) {
    _showErrorDialog(context, 'An error occurred during login.');
  } finally {
    setLoading(false);
  }

  return LoginResult.error;
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
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
