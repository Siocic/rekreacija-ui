import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';

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
      decoration: customDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Reservations',
                  style: GoogleFonts.suezOne(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Card(
                  color: const Color.fromRGBO(49, 49, 49, 0.8),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
                  child: SizedBox(
                    width: 400.0,
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(0.0),
                              child: Container(
                                width: 100.0,
                                height: 120.0,
                                color: Colors.grey[300],
                                child: const Icon(Icons.person,
                                    size: 30, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hall Name',
                                    style: GoogleFonts.suezOne(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Hall Adress',
                                    style: GoogleFonts.suezOne(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Date',
                                    style: GoogleFonts.suezOne(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Hour',
                                    style: GoogleFonts.suezOne(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.near_me_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
