import 'package:flutter/material.dart';
import 'package:yotsuba_mobile/widgets/Dashboard.dart';
import 'package:yotsuba_mobile/widgets/Dashboard.dart';
import 'package:yotsuba_mobile/widgets/LoginWidget.dart'; 

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
      initialRoute: '/',
      routes: {
        '/': (context) => LoginWidget(),
        '/home': (context) => const Dashboard(),
      },
    );
  }
}
