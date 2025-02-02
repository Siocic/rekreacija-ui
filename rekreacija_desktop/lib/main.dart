import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/sport_category_provider.dart';
import 'package:rekreacija_desktop/screens/login.dart';

void main() async{
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>ObjectProvider()),
      ChangeNotifierProvider(create: (_)=>SportCategoryProvider()),
    ],
     child:const MyApp()
    ),
    
   
    );
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
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}