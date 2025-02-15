import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/change_password_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  State<StatefulWidget> createState() => _ChangePassword();
}

class _ChangePassword extends State<ChangePassword> {
  bool _showPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
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
      appBar: const CustomAppBar(title: 'Change password'),
      body: Container(
        width: double.infinity,
        decoration: customDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20.0),
            Text(
              'Ensure your new password is strong and secure',
              style: GoogleFonts.suezOne(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 20.0),
            FormBuilder(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'CurrentPassword',
                      controller: widget.passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
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
                    const SizedBox(height: 20.0),
                    FormBuilderTextField(
                      name: 'NewPassword',
                      controller: widget.newPasswordController,
                      obscureText: !_showNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        filled: true,
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showNewPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showNewPassword = !_showNewPassword;
                            });
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.password(
                          minLength: 8,
                          minUppercaseCount: 1,
                          minLowercaseCount: 1,
                          minNumberCount: 1,
                          minSpecialCharCount: 1,
                          errorText:
                              'Password must meet complexity requirements',
                        )
                      ]),
                    ),
                    const SizedBox(height: 20.0),
                    FormBuilderTextField(
                      name: 'ConfirmPassword',
                      controller: widget.confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        filled: true,
                        prefixIcon: const Icon(Icons.lock, color: Colors.black),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showConfirmPassword = !_showConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value != widget.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
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
                              final password =
                                  formData['CurrentPassword']?.value ?? '';
                              final newPassword =
                                  formData['NewPassword']?.value ?? '';

                              ChangePasswordModel change =
                                  ChangePasswordModel(password, newPassword);

                              await _authProvider.changePassword(change);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You successfullly change your password')),
                              );

                              Navigator.pop(context);
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
                                      Text('Please fill the form correct.')),
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(14, 119, 62, 1.0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        child: const Text(
                          'Change password',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
