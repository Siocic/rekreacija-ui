import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/login_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/routes.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _showPassword = false;
  late AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
  }

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
              const SizedBox(height: 200),
              Text(
                'Login here',
                style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 40),
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
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
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
                    // const SizedBox(height: 10),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       print('Forgot Password');
                    //     },
                    //     child: Text(
                    //       'Forgot password?',
                    //       style: GoogleFonts.montserrat(
                    //           color: Colors.blue,
                    //           fontSize: 16,
                    //           decoration: TextDecoration.underline,
                    //           fontWeight: FontWeight.w500,
                    //           decorationColor: Colors.blue),
                    //     ),
                    //   ),
                    // ),
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
                              await _authProvider.userLogin(loginModel);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login successful')),
                              );

                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.tabsscreen);
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
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Don\'t have an account?',
                style: GoogleFonts.sora(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(
                      context, AppRoutes.roleselection);
                },
                child: Text(
                  'Register here',
                  style: GoogleFonts.sora(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
