import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ObjectCard extends StatelessWidget {
  final String objectName;
  final String objectAddress;
  final Image image;
  final VoidCallback deleteObject;
  final VoidCallback editObject;
  const ObjectCard(
      {super.key,
      required this.objectName,
      required this.objectAddress,
      required this.image,
      required this.deleteObject,
      required this.editObject});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Container(
              width: double.infinity,
              height: 350.0,
              color: Colors.grey[300],
              child: Image(
                image: image.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objectName,
                  style: GoogleFonts.suezOne(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Text(
                      objectAddress,
                      style: GoogleFonts.suezOne(
                        color: Colors.black54,
                        fontSize: 18.0,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: editObject,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: deleteObject,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
