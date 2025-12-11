import 'package:flutter/material.dart';
import 'package:jesoor_pro/features/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jesoor Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF092032),
      ),
      home: const SplashScreen(),
    );
  }
}
