import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/models/login_model.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/screens/home_page.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        width: 400,
        height: 390,
        decoration: BoxDecoration(color: Colors.grey[100]),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Welcome to Rekreacija', style: TextStyle(fontSize: 24)),
            const Text('Please login to our app',
                style: TextStyle(fontSize: 15)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FormBuilder(
                    key: formKey,
                    child: Column(
                      children: [
                        FormBuilderTextField(
                          name: 'Email',
                          controller: widget._emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, color: Colors.black),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email()
                          ]),
                        ),
                        const SizedBox(height: 15),
                        FormBuilderTextField(
                          name: 'Password',
                          controller: widget._passwordController,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(),
                            prefixIcon:
                                const Icon(Icons.lock, color: Colors.black),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              print('Forgot Password');
                            },
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.montserrat(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                  decorationColor: Colors.blue),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: TextButton(
                            onPressed: () async {
                              if (formKey.currentState?.saveAndValidate() ??
                                  false) {
                                try {
                                  final formData = formKey.currentState!.fields;
                                  final email = formData['Email']?.value ?? '';
                                  final password =
                                      formData['Password']?.value ?? '';

                                  LoginModel loginModel =
                                      LoginModel(email, password);
                                  final AuthProvider customerLogin =
                                      AuthProvider();
                                  await customerLogin.userLogin(loginModel);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Login successful'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomePageScreen()));
                                } catch (e) {
                                  String errorMessage = e.toString();

                                  if (errorMessage.startsWith("Exception:")) {
                                    errorMessage = errorMessage
                                        .replaceFirst("Exception:", "")
                                        .trim();
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fix the errors in the form.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                )),
                            child: const Text(
                              'LOGIN',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
