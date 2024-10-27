import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContainerHeader extends StatefulWidget {
  const ContainerHeader({super.key, required this.title});
  final String title;

  @override
  State<ContainerHeader> createState() => _ContainerHeaderState();
}

class _ContainerHeaderState extends State<ContainerHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40.0),
      child: Text(
        widget.title,
        style: GoogleFonts.rubik(
          textStyle: const TextStyle(
            fontSize: 40,
            height: 4,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
