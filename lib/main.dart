import 'package:flutter/material.dart';
import 'package:flutter_test_app/presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ПРИВЕТ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const MyHomePage(title: 'Проконов Кирилл ПИбд-31'),
    );
  }
}
