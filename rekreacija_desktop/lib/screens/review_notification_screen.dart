import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class ReviewNotificationScreen extends StatelessWidget {
  const ReviewNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
              title: 'Review & Notification',
              onLogout: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
        )
      ],
    );
  }
}
