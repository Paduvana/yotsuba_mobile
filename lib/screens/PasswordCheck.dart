import 'package:flutter/material.dart';
import 'Login.dart'; // Import your login page

class PasswordCheck extends StatefulWidget {
  @override
  _PasswordCheckState createState() => _PasswordCheckState();
}

class _PasswordCheckState extends State<PasswordCheck> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.white,  // Set background color to white
      body: Stack(
        children: [
          Positioned(
            top: 50, // Adjusted the logo position to be lower
            left: 20,
            child: Row(
              children: [
                Image.asset(
                  'asset/images/logo.png',
                  width: 100, // Adjust the size as needed
                ),
                const SizedBox(width: 10), // Space between logo and title
                Text(
                  'パスワード再発行',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    height: 450,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: 5.0,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: '登録メールアドレス',
                          ),
                        ),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            hintText: '新しいパスワード',
                          ),
                          obscureText: true,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            hintText: '新しいパスワード（確認）',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                          onPressed: () {
                            // Redirect to login page on success
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(),
                              ),
                            );
                          },
                          style: style,
                          child: const Text('Reissue Password'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}