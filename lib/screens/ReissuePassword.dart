import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/services/PasswordReissueService.dart';
import 'package:yotsuba_mobile/screens/Login.dart';

class ReissuePassword extends StatefulWidget {
  @override
  _ReissuePasswordState createState() => _ReissuePasswordState();
}

class _ReissuePasswordState extends State<ReissuePassword> {
  final TextEditingController _emailController = TextEditingController();
  final PasswordReissueService _passwordResetService = PasswordReissueService();
  bool _isLoading = false;
  String? _message; // Store success or error message

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _handlePasswordReset(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _message = 'メールアドレスを入力してください';
      });
      return;
    }

    setLoading(true);
    final response = await _passwordResetService.requestPasswordReset(email, context);
    setLoading(false);

    if (response['success']) {
      setState(() {
        _message = response['message'];
      });
    } else {
      setState(() {
        _message = response['message'];
      });
    }
  }

  void _navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      backgroundColor: Colors.teal,
      foregroundColor: Colors.white,
    );

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/login_banner.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _message == null
                    ? Container(
                        padding: const EdgeInsets.all(10.0),
                        height: 350,
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
                            Text(
                              'パスワード再発行',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const Text(
                              'メールアドレスを入力してください',
                            ),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'メールアドレス',
                              ),
                            ),
                            const SizedBox(height: 24),
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () => _handlePasswordReset(context),
                                    style: style,
                                    child: const Text('再発行'),
                                  ),
                          ],
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white, // White background for readability
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _message!,
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => _navigateToLogin(context),
                              style: style,
                              child: const Text('ログインに戻る'),
                            ),
                          ],
                        ),
                      ),
                Container(
                  padding: const EdgeInsets.all(30.0),
                  child: Image.asset('asset/images/logo.png'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
