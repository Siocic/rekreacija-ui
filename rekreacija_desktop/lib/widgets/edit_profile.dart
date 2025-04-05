import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:rekreacija_desktop/models/user_model.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

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
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  File? _selectedImage;
  String? base64Image;

  Future<void> _pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
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
          maxWidth: 600,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Edit Profile'),
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
                const SizedBox(height: 10),
                buildTextField(
                    widget.lastNameController, 'LastName', Icons.person),
                const SizedBox(height: 10),
                buildTextField(widget.emailController, 'Email', Icons.email),
                const SizedBox(height: 10),
                buildTextField(
                    widget.cityController, 'City', Icons.location_city),
                const SizedBox(height: 10),
                buildTextField(
                    widget.addressController, 'Address', Icons.location_on),
                const SizedBox(height: 10),
                buildTextField(
                    widget.phoneController, 'Phone', Icons.phone_android),
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
                        if (formKey.currentState?.saveAndValidate() ?? false) {
                          try {
                            final formData = formKey.currentState!.fields;
                            final firstName =
                                formData['FirstName']?.value ?? '';
                            final lastName = formData['LastName']?.value ?? '';
                            final email = formData['Email']?.value ?? '';
                            final city = formData['City']?.value ?? '';
                            final address = formData['Address']?.value ?? '';
                            final phone = formData['Phone']?.value ?? '';

                            UserModel userModel = UserModel(firstName, lastName,
                                email, address, city, phone, base64Image);
                            final AuthProvider editProfile = AuthProvider();
                            await editProfile.editProfile(userModel);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'You update profile successfully.',
                                ),
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
                                content:
                                    Text('Please fix the errors in the form.')),
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
                )
              ],
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
