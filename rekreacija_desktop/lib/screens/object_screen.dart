import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/edit_object_modal.dart';
import 'package:rekreacija_desktop/widgets/object_card.dart';
import 'package:rekreacija_desktop/widgets/object_modal.dart';

class ObjectScreen extends StatefulWidget {
  const ObjectScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ObjectScreen();
}

class _ObjectScreen extends State<ObjectScreen> {
  late ObjectProvider _objectProvider;
  List<ObjectModel>? objects;
  Image? image;

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    _loadObjectOfUser();
  }

  Future<void> _loadObjectOfUser() async {
    try {
      final userObject = await _objectProvider.getObjectOfLoggedUser();
      setState(() {
        objects = userObject;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

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
                    return ObjectModal();
                  });
              if (result == true) {
                _loadObjectOfUser();
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
              itemCount: objects!.length,
              itemBuilder: (context, index) {
                final ourObjects = objects![index];
                return ObjectCard(
                  objectName: ourObjects.name ?? '',
                  objectAddress: ourObjects.address ?? '',
                  image: ourObjects.objectImage != null
                      ? imageFromString(ourObjects.objectImage!)
                      : Image.asset("assets/images/RekreacijaDefault.jpg"),
                  deleteObject: () async {
                    _showDeleteDialog(ourObjects.id!);
                  },
                  editObject: () async {
                    final bool? result = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return EditObjectModal(
                            object: ourObjects,
                          );
                        });

                    if (result == true) {
                      _loadObjectOfUser();
                    }
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

  void _showDeleteDialog(int id) {
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
                  onPressed: () async {
                    try {
                      await _objectProvider.Delete(id);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'You successfully deleted the object',
                          style: GoogleFonts.suezOne(),
                        ),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pop(context);
                      _loadObjectOfUser();
                    } catch (e) {
                      String errorMessage = e.toString();

                      if (errorMessage.startsWith("Exception:")) {
                        errorMessage =
                            errorMessage.replaceFirst("Exception:", "").trim();
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(errorMessage)),
                      );
                    }
                  },
                  child: const Text('Yes'))
            ],
          );
        });
  }
}
