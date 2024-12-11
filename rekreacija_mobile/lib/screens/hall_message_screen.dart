import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';

class HallMessageScreen extends StatefulWidget {
  const HallMessageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HallMessageScreenState();
}

class _HallMessageScreenState extends State<HallMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Message'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'To : ',
                      style: GoogleFonts.suezOne(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      'Hall Name',
                      style: GoogleFonts.suezOne(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 400.0,
                  child: TextField(
                    maxLines: 15,
                    decoration: InputDecoration(
                      hintText: "Enter your message",
                      hintStyle: GoogleFonts.suezOne(
                        color: Colors.grey,
                        fontSize: 18.0,
                      ),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: GoogleFonts.suezOne(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      print('object');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    child: const Text(
                      'Send message',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
