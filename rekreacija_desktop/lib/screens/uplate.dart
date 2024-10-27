import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class UplateScren extends StatelessWidget {
  const UplateScren({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Uplate'),           
          ],
        ),
      ],
    );
  }
}
