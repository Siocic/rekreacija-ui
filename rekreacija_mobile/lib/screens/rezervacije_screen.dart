import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RezervacijaScreen();
}

class _RezervacijaScreen extends State<RezervacijeScreen> {
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
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Rezervacije',
                    style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
