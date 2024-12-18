import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/object_card.dart';

class ObjectScreen extends StatefulWidget {
  const ObjectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ObjectScreen();
}

class _ObjectScreen extends State<ObjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
            title: 'Our objects',
            onLogout: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(14, 121, 115, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Add new object',
              style: GoogleFonts.suezOne(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20),
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 35.0, right: 35.0, top: 10.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 5.3 / 3,
              ),
              itemCount: objects.length,
              itemBuilder: (context, index) {
                final ourObjects = objects[index];
                return ObjectCard(
                    objectName: ourObjects['ObjectName'] ?? '',
                    objectAddress: ourObjects['ObjectAddress'] ?? '');
              },
            ),
          ),
        ),
        const SizedBox(height: 25.0)
      ],
    );
  }

  final List<Map<String, String>> objects = [
    {
      'ObjectName': 'Object 1',
      'ObjectAddress': 'Address 1',
    },
    {
      'ObjectName': 'Object 2',
      'ObjectAddress': 'Address 2',
    },
    {
      'ObjectName': 'Object 3',
      'ObjectAddress': 'Address 3',
    },
    {
      'ObjectName': 'Object 4',
      'ObjectAddress': 'Address 4',
    },
    {
      'ObjectName': 'Object 5',
      'ObjectAddress': 'Address 5',
    },
  ];
}
