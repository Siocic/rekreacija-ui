import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class TerminiScreen extends StatelessWidget{
  const TerminiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Termini'),
          ],
        )
      ],
    );
  }
}