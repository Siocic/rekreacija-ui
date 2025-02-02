import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/object_card.dart';
import 'package:rekreacija_desktop/widgets/object_modal.dart';

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
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Our objects'),
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
            onPressed: () async {
              final bool? result = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return  ObjectModal();
                  });
                  if(result==true)
                  {
                    //todo osvjesiziti kada dodamo iscrtavanje objekata
                  }
            },
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
                  objectAddress: ourObjects['ObjectAddress'] ?? '',
                  deleteObject: () {
                    _showDeleteDialog(index);
                  },
                  editObject: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return  ObjectModal();
                        });
                  },
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 25.0)
      ],
    );
  }

  void _showDeleteDialog(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text('Are you sure you want to delete this object?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      objects.removeAt(index);
                    });
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'You successfully deleted the object: ${objects[index]['ObjectName']}',
                        style: GoogleFonts.suezOne(),
                      ),
                      backgroundColor: Colors.green,
                    ));
                  },
                  child: const Text('Yes'))
            ],
          );
        });
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
