import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rekreacija_desktop/widgets/container_header.dart';
import 'package:rekreacija_desktop/widgets/obavijesti_modal.dart';

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
            const Padding(
              padding: EdgeInsets.all(0.0),
              child: ContainerHeader(title: 'Obavijesti'),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.add_box_outlined,
                  size: 35,                  
                ),
                 onPressed: () {
                      showDialog(context: context, builder: (BuildContext context){
                        return  ObavijestiModal();
                      },);
                    },
                 
              ),
            )
          ],
        ),
      ],
    );
  }
}
