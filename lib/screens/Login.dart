import 'package:flutter/material.dart';
import '../services/LoginService.dart';
import 'ReissuePassword.dart'; // Import the API service

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Call the login service and handle navigation or error display
    final result = await loginService(context, username, password, setLoading);
    if (result == LoginResult.success) {
      Navigator.pushReplacementNamed(context, '/home');
    }
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
                            onPressed: () => _login(), // Trigger the API call on login
                            style: style,
                            child: const Text(
                              'Sign In',
                            ),
                          ),
                    const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReissuePassword()),
                    );
                  },
                  child: const Text(
                    'パスワードを再発行する',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline, // Underline to indicate it's clickable
                    ),
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
