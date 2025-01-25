import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

class ContentHeader extends StatefulWidget {
  final String title;
  const ContentHeader({super.key, required this.title});
  @override
  State<StatefulWidget> createState() => _ContentHeader();
}

class _ContentHeader extends State<ContentHeader> {
  String user = '';

  @override
  void initState() {
    super.initState();
    fetchUserFullName();
  }

 
  Future<void> fetchUserFullName() async {
    final userName = await getUserFullName();
    setState(() {
      user = userName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title, style: GoogleFonts.suezOne(fontSize: 30)),
        const Spacer(),
        Text(
          user.isNotEmpty ? 'Welcome, $user' : 'Welcome, ...', // Display welcome message
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }
}

