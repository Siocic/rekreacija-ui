import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageScreen();
}

class _HomePageScreen extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [           
              Color.fromARGB(225, 19, 19, 19),
            Color.fromARGB(225, 49, 49, 49),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: const Center(
        child: Text(
          'Your Content Here',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
