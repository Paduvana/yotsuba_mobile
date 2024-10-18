import 'package:flutter/material.dart';

import 'PasswordCheck.dart';

class ReissuePassword extends StatefulWidget {
  @override
  _ReissuePasswordState createState() => _ReissuePasswordState();
}

class _ReissuePasswordState extends State<ReissuePassword> {
  final TextEditingController _emailController = TextEditingController();
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
                Container(
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
                        onPressed: () {
                          // Navigate to the PasswordCheck screen when the button is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PasswordCheck()),
                          );
                        },
                        style: style,
                        child: const Text('Reissue Password'),
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