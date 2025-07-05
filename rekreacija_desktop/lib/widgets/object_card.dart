import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ObjectCard extends StatelessWidget {
  final String objectName;
  final String objectAddress;
  final Image image;
  final VoidCallback deleteObject;
  final VoidCallback editObject;

  const ObjectCard({
    super.key,
    required this.objectName,
    required this.objectAddress,
    required this.image,
    required this.deleteObject,
    required this.editObject,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 4.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Responsive slika sa aspect ratio
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: Image(
                    image: image.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      objectName,
                      style: GoogleFonts.suezOne(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            objectAddress,
                            style: GoogleFonts.suezOne(
                              fontSize: 16.0,
                              color: Colors.black54,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: editObject,
                          splashRadius: 20,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: deleteObject,
                          splashRadius: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        );
      },
    );
  }
}
