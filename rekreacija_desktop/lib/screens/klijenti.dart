import 'package:flutter/widgets.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class KlijentiScreen extends StatelessWidget {
  const KlijentiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Klijenti'),            
          ],
        )
      ],
    );
  }
}
