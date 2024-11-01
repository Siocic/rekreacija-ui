import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';
import 'package:rekreacija_desktop/widgets/profile_container.dart';
import 'package:rekreacija_desktop/widgets/welcome_user.dart';

class MojProfilScreen extends StatelessWidget {
  const MojProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ContainerHeader(title: 'Moj profil'),
            WelcomeUser(),
          ],
        ),
        ProfileContainer(),
      ],
    );
  }
}
