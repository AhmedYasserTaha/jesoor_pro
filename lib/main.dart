import 'package:flutter/material.dart';
import 'features/roots_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jesoor Pro',
      debugShowCheckedModeBanner: false,
      home: const RootsView(),
    );
  }
}
