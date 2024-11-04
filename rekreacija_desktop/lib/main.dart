import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/home_page.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: ' App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: RegisterScreen()
    );
  }
}