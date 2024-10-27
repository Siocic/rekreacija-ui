import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class PorukeScreen extends StatelessWidget {
  const PorukeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Poruke'),            
          ],
        ),
      ],
    );
  }
}
