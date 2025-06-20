import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/user_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';

class EditProfile extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final TextEditingController phoneController;
  final ImageProvider currentImage;

  const EditProfile(
      {super.key,
      required this.firstNameController,
      required this.lastNameController,
      required this.emailController,
      required this.cityController,
      required this.addressController,
      required this.phoneController,
      required this.currentImage});

  @override
  State<StatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _selectedImage;
  String? base64Image;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final File file = File(image.path);
        final bytes = await file.readAsBytes();

        setState(() {
          _selectedImage = file;
          base64Image = base64Encode(bytes);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 800,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FormBuilder(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text(
                    'Edit profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : widget.currentImage,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildTextField(
                      widget.firstNameController, 'FirstName', Icons.person),
                  buildTextField(
                      widget.lastNameController, 'LastName', Icons.person),
                  buildTextField(widget.emailController, 'Email', Icons.email),
                  buildTextField(
                      widget.cityController, 'City', Icons.location_city),
                  buildTextField(
                      widget.addressController, 'Address', Icons.location_on),
                  buildTextField(widget.phoneController, 'Phone',
                      Icons.phone_android_sharp),
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
                              final firstName =
                                  formData['FirstName']?.value ?? '';
                              final lastName =
                                  formData['LastName']?.value ?? '';
                              final email = formData['Email']?.value ?? '';
                              final city = formData['City']?.value ?? '';
                              final address = formData['Address']?.value ?? '';
                              final phone = formData['Phone']?.value ?? '';
                              final id = 'test';

                              UserModel userModel = UserModel(
                                  firstName,
                                  lastName,
                                  email,
                                  address,
                                  city,
                                  phone,
                                  base64Image, 
                                  id);
                              await _authProvider.editProfile(userModel);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You update profile successfully.')),
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
                                      'Please fix the errors in the form.')),
                            );
                          }
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildTextField(
    TextEditingController controller, String label, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0.0),
    child: FormBuilderTextField(
      name: label,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "$label is required."),
      ]),
    ),
  );
}
