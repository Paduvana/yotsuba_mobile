import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yotsuba_mobile/HomePage.dart'; // Import the HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yotsuba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Yotsuba'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Controllers for text input
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // To show loading indicator

  // Function to make API call for login
  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Check if username or password is empty
    if (username.isEmpty || password.isEmpty) {
      _showErrorDialog('Please enter both username and password.');
      return;
    }

    const String url = 'http://10.0.2.2:8000/api/v1/login/';

    setState(() {
      _isLoading = true; // Show loading indicator when starting API call
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': username,
          'password': password,
        }),
      );

      // Ensure the response body is properly decoded using UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedBody);

      print('Response body decoded: $decodedBody');

// Inside your _login method
      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = jsonDecode(decodedBody);

        // Debugging: Print the entire response data
        print('Response data: $data');

        // Check if tokens are present
        final String? accessToken = data['access_token'];
        final String? refreshToken = data['refresh_token'];

        if (accessToken != null && refreshToken != null) {
          // Navigate to HomePage with the accessToken
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(accessToken: accessToken),
            ),
          );
        } else {
          // Tokens are missing, show error
          _showErrorDialog('Failed to retrieve authentication tokens.');
        }
      } else {
        _showErrorDialog('Login failed. Please check your credentials.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog('An error occurred during login.');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading indicator after the API call
      });
    }
  }

  // Function to show an error dialog
  void _showErrorDialog(String message) {
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

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white);

    return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/images/login_banner.png"),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0), // Uniform radius
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'レンタルシステム',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const Text(
                          'ログインID/Passを入力してください',
                        ),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'ID',
                          ),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            hintText: 'Pass',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        _isLoading
                            ? const CircularProgressIndicator() // Show loading indicator
                            : ElevatedButton(
                          onPressed: _login, // Trigger the API call on login
                          style: style,
                          child: const Text(
                            'Sign In',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.all(30.0),
                      child: Image.asset('asset/images/logo.png'))
                ],
              ),
            ),
          ),
        ));
  }
}