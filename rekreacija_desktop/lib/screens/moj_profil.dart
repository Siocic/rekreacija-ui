import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class MojProfilScreen extends StatelessWidget{
  const MojProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Moj profil'),            
          ],
        )
      ],
    );
  }
}