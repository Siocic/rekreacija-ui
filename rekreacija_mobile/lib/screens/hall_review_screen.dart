import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';

class HallReviewScreen extends StatefulWidget {
  const HallReviewScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HallReviewScreenState();
}

class _HallReviewScreenState extends State<HallReviewScreen> {
  int _selectedStars = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Review'),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Review for:',
                        style: GoogleFonts.suezOne(
                            color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(width: 5.0),
                      Text(
                        'Hall Name',
                        style: GoogleFonts.suezOne(
                            color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedStars = index + 1;
                            });
                          },
                          child: Icon(
                            _selectedStars > index
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.yellow,
                            size: 35,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 400.0,
                    child: TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: "Enter you comment",
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
              )),
        ),
      ),
    );
  }
}
