import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/screens/Dashboard.dart';
import 'package:yotsuba_mobile/screens/Login.dart';
import 'package:yotsuba_mobile/services/AuthService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await AuthService().getAccessToken();
  runApp(MyApp(initialRoute: token != null ? '/home' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yotsuba',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => Login(),
        '/home': (context) => const Dashboard(),
      },
    );
  }
}
