import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/models/object_update.dart';
import 'package:rekreacija_desktop/models/sport_category.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/sport_category_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';

class EditObjectModal extends StatefulWidget {
  final ObjectModel object;
  const EditObjectModal({super.key, required this.object});
  @override
  State<StatefulWidget> createState() => _EditObjectModalState();
}

class _EditObjectModalState extends State<EditObjectModal> {
  late ObjectProvider _objectProvider;
  late SportCategoryProvider _sportCategoryProvider;
  final TextEditingController objectName = TextEditingController();
  final TextEditingController objectAddress = TextEditingController();
  final TextEditingController objectCity = TextEditingController();
  final TextEditingController objectDescription = TextEditingController();
  final TextEditingController objectPrice = TextEditingController();
  late ImageProvider objectImageProvider;
  File? selectedImage;
  String? base64Image;
  List<SportCategory> sports = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    _sportCategoryProvider = context.read<SportCategoryProvider>();
    getIdUser();
    _initializeFields();
    _loadSports();
  }

  void _initializeFields() {
    objectName.text = widget.object.name ?? '';
    objectAddress.text = widget.object.address ?? '';
    objectCity.text = widget.object.city ?? '';
    objectDescription.text = widget.object.description ?? '';
    objectPrice.text = widget.object.price?.toString() ?? '';
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

  Future<void> getIdUser() async {
    final iduser = await getUserId();
    setState(() {
      userId = iduser;
    });
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
                'Edit object',
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
                            : (widget.object.objectImage != null
                                ? imageFromString(widget.object.objectImage!)
                                : Image.asset(
                                    'assets/images/RekreacijaDefaultProfilePicture.png',
                                    fit: BoxFit.fill)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: "Name",
                      maxLength: 50,
                      controller: objectName,
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
                      controller: objectAddress,
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
                      controller: objectCity,
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
                      controller: objectDescription,
                      maxLines: 5,
                      maxLength: 200,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          border: OutlineInputBorder()),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: "The description of object is required"),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderCheckboxGroup(
                      name: 'select_sport',
                      initialValue: widget.object.sportsId ?? [],
                      decoration: const InputDecoration(
                          labelText: "Select sport", border: InputBorder.none),
                      activeColor: Colors.blueAccent,
                      wrapSpacing: 10,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select at least one sport.";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        print(value);
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
                      controller: objectPrice,
                      decoration: const InputDecoration(
                          labelText: 'Price',
                          suffixText: "KM",
                          filled: true,
                          border: OutlineInputBorder()),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
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

                                  String? imageToSend;
                                  if (selectedImage != null) {
                                    final bytes =
                                        await selectedImage!.readAsBytes();
                                    imageToSend = base64Encode(bytes);
                                  } else if (widget.object.objectImage !=
                                          null &&
                                      widget.object.objectImage!.isNotEmpty) {
                                    imageToSend = widget.object.objectImage;
                                  }

                                  ObjectUpdate objectUpdate = ObjectUpdate(
                                      name,
                                      now,
                                      address,
                                      city,
                                      description,
                                      priceAsDouble,
                                      userId,
                                      imageToSend,
                                      sportIds);

                                  await _objectProvider.Update(
                                      widget.object.id!, objectUpdate);
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
                            child: const Text('Submit')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close'))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
