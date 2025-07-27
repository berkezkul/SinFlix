import 'package:flutter/material.dart';
import 'package:sinflix/views/login.dart';
import 'utils/constants/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SinFlix',
      theme: appTheme,
      home: const LoginView(),
      debugShowCheckedModeBanner: false,
    );
  }
}