import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';

class ContentHeader extends StatelessWidget {
  final String title;
  final VoidCallback onLogout;

  const ContentHeader({super.key, required this.title, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.suezOne(fontSize: 30)),
        const Spacer(),
        const Text('Welcome, Admin', style: TextStyle(fontSize: 20)),
        const SizedBox(width: 10.0),
        IconButton(
          icon: const Icon(
            Icons.person,
            color: AppColors.iconBlack,
            size: 27,
          ),
          onPressed: onLogout,
        ),
      ],
    );
  }
}
