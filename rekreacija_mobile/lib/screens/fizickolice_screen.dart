import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/models/registration_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/routes.dart';
import 'package:rekreacija_mobile/widgets/registration_form.dart';

class FizickoliceScreen extends StatefulWidget {
  FizickoliceScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordContoller = TextEditingController();

  @override
  State<StatefulWidget> createState() => _FizickoliceScreen();
}

class _FizickoliceScreen extends State<FizickoliceScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      backgroundColor: const Color.fromRGBO(14, 121, 115, 1),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Text(
                'Register here',
                style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              RegistrationForm(
                formKey: formKey,
                firstNameController: widget._firstNameController,
                lastNameController: widget._lastNameController,
                emailController: widget._emailController,
                cityController: widget._cityController,
                addressController: widget._addressController,
                phoneController: widget._phoneController,
                passwordController: widget._passwordController,
                repeatPasswordController: widget._repeatPasswordContoller,
                onSubmit: () async {
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    try {
                      final formData = formKey.currentState!.fields;
                      final firstName = formData['FirstName']?.value ?? '';
                      final lastName = formData['LastName']?.value ?? '';
                      final email = formData['Email']?.value ?? '';
                      final city = formData['City']?.value ?? '';
                      final address = formData['Address']?.value ?? '';
                      final phone = formData['Phone']?.value ?? '';
                      final password = formData['Password']?.value ?? '';
                      final confirmPassword =
                          formData['Confirm Password']?.value ?? '';

                      if (password != confirmPassword) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Passwords do not match')),
                        );
                        return;
                      }

                      RegistrationModel registrationModel = RegistrationModel(
                          firstName,
                          lastName,
                          email,
                          city,
                          address,
                          phone,
                          password);

                      final AuthProvider customerRegistraion = AuthProvider();
                      await customerRegistraion.userRegister(
                          registrationModel, 0);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Registration successful! Please log in.')),
                      );
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fix the errors in the form.')),
                    );
                  }
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.sora(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
