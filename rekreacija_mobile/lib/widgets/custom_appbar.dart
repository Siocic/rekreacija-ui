import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final List<Widget>?actions;
  //final VoidCallback? onBackPressed;

  const CustomAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color.fromARGB(225, 19, 19, 19),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:  Text(
          title,
          style: GoogleFonts.suezOne(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: actions??[],
    );
  }
    @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}