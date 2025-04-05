import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_insert.dart';
import 'package:rekreacija_desktop/models/sport_category.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/sport_category_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

class ObjectModal extends StatefulWidget {
  ObjectModal({super.key});
  final TextEditingController objectName = TextEditingController();
  final TextEditingController objectAddress = TextEditingController();
  final TextEditingController objectCity = TextEditingController();
  final TextEditingController objectDescription = TextEditingController();
  final TextEditingController objectPrice = TextEditingController();

  @override
  State<StatefulWidget> createState() => _ObjectModal();
}

class _ObjectModal extends State<ObjectModal> {
  late ObjectProvider _objectProvider;
  late SportCategoryProvider _sportCategoryProvider;
  String userId = '';
  File? selectedImage;
  String? base64Image;
  List<SportCategory> sports = [];

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    _sportCategoryProvider = context.read<SportCategoryProvider>();
    getIdUser();
    _loadSports();
  }

  Future<void> getIdUser() async {
    final iduser = await getUserId();
    setState(() {
      userId = iduser;
    });
  }

  Future<void> _loadSports() async {
    try {
      final sport = await _sportCategoryProvider.Get();
      setState(() {
        sports = sport;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load sports: $e')));
    }
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        final bytes = await file.readAsBytes();

        setState(() {
          selectedImage = file;
          base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to add image')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add new object',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                FormBuilder(
                  key: formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: SizedBox(
                          width: 400,
                          height: 250,
                          child: selectedImage != null
                              ? Image.file(selectedImage!, fit: BoxFit.fill)
                              : Image.asset(
                                  'assets/images/RekreacijaDefault.jpg',
                                  fit: BoxFit.fill),
                        ),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "Name",
                        maxLength: 50,
                        controller: widget.objectName,
                        decoration: const InputDecoration(
                          labelText: 'Object Name',
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "The name of object is required"),
                          FormBuilderValidators.minLength(2,
                              errorText: "Minimum 2 charcters"),
                          FormBuilderValidators.maxLength(50,
                              errorText: "Maximum 50 charcters"),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "Address",
                        controller: widget.objectAddress,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Object address',
                          filled: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "The address of object is required"),
                          FormBuilderValidators.minLength(2,
                              errorText: "Minimum 2 charcters"),
                          FormBuilderValidators.maxLength(50,
                              errorText: "Maximum 50 charcters"),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "City",
                        controller: widget.objectCity,
                        maxLength: 50,
                        decoration: const InputDecoration(
                            labelText: 'Object city',
                            filled: true,
                            border: OutlineInputBorder()),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "The city of object is required"),
                          FormBuilderValidators.city(),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "Description",
                        controller: widget.objectDescription,
                        maxLines: 5,
                        maxLength: 200,
                        decoration: const InputDecoration(
                            labelText: 'Description',
                            filled: true,
                            border: OutlineInputBorder()),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText:
                                  "The description of object is required"),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderCheckboxGroup(
                        name: 'select_sport',
                        decoration: const InputDecoration(
                            labelText: "Select sport",
                            border: InputBorder.none),
                        activeColor: Colors.blueAccent,
                        wrapSpacing: 10,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select at least one sport.";
                          }
                          return null;
                        },
                        options: sports.map((sport) {
                          return FormBuilderChipOption(
                            value: sport.id!,
                            child: Text(sport.name!),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      FormBuilderTextField(
                        name: "Price",
                        controller: widget.objectPrice,
                        decoration: const InputDecoration(
                            labelText: 'Price',
                            suffixText: "KM",
                            filled: true,
                            border: OutlineInputBorder()),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d*')),
                        ],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                              errorText: "The price of object is required"),
                          FormBuilderValidators.numeric(
                              errorText: "Enter a valid number"),
                        ]),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              bool isExpired = await isTokenExpired();
                              if (isExpired) {
                                showTokenExpiredDialog(context);
                                return;
                              }
                              if (formKey.currentState?.saveAndValidate() ??
                                  false) {
                                try {
                                  final formData = formKey.currentState!.fields;
                                  final name = formData['Name']?.value ?? '';
                                  final address =
                                      formData['Address']?.value ?? '';
                                  final city = formData['City']?.value ?? '';
                                  final description =
                                      formData['Description']?.value ?? '';
                                  final price = formData['Price']?.value ?? '';
                                  final priceAsDouble = double.tryParse(price);
                                  final choice =
                                      formData['select_sport']?.value ?? '';
                                  final List<int> sportIds =
                                      List<int>.from(choice);
                                  DateTime now = DateTime.now();

                                  ObjectInsert objectInsert = ObjectInsert(
                                      name,
                                      now,
                                      address,
                                      city,
                                      description,
                                      priceAsDouble,
                                      userId,
                                      base64Image,
                                      sportIds);

                                  await _objectProvider.Insert(objectInsert);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'You added a new object successfully.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context, true);
                                } catch (e) {
                                  String errorMessage = e.toString();

                                  if (errorMessage.startsWith("Exception:")) {
                                    errorMessage = errorMessage
                                        .replaceFirst("Exception:", "")
                                        .trim();
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMessage)),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Please fix the errors in form.")));
                              }
                            },
                            child: const Text('Submit'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            )),
      ),
    );
  }
}
