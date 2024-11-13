import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages',
            style:
                GoogleFonts.ultra(fontWeight: FontWeight.w400, fontSize: 22)),
        backgroundColor: const Color.fromARGB(225, 29, 29, 29),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
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
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'No new messages at this time.',
              style: GoogleFonts.ultra(color: Colors.white, fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
