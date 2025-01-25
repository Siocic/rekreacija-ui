import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Messages'),
        )
      ],
    );
  }
}
