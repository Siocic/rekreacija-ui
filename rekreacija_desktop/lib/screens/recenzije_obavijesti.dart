import 'package:flutter/widgets.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';

class RecenzijeObavijestiScreen extends StatelessWidget {
  const RecenzijeObavijestiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ContainerHeader(title: 'Recenzije'),            
          ],
        ),
        Row(
          children: [
            ContainerHeader(title: 'Obavijesti'),            
          ],
        ),
      ],
    );
  }
}
