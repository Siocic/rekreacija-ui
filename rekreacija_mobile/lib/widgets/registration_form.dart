import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController repeatPasswordController;
  final TextEditingController cityController;
  final TextEditingController addressController;
  final VoidCallback? onSubmit;

  const RegistrationForm({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.repeatPasswordController,
    required this.cityController,
    required this.addressController,
    this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: "FirstName",
            controller: widget.firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              filled: true,
              prefixIcon: Icon(Icons.perm_identity, color: Colors.black),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: 'First name is required'),
              FormBuilderValidators.minLength(2,
                  errorText: 'Minimum 2 characters'),
              FormBuilderValidators.maxLength(50,
                  errorText: 'Maximum 50 characters'),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: "LastName",
            controller: widget.lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              filled: true,
              prefixIcon: Icon(Icons.perm_identity, color: Colors.black),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                  errorText: 'Last name is required'),
              FormBuilderValidators.minLength(2,
                  errorText: 'Minimum 2 characters'),
              FormBuilderValidators.maxLength(50,
                  errorText: 'Maximum 50 characters'),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'Email',
            controller: widget.emailController,
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
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'City',
            controller: widget.cityController,
            decoration: const InputDecoration(
              labelText: 'City',
              filled: true,
              prefixIcon: Icon(Icons.location_city, color: Colors.black),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'City is required'),
              FormBuilderValidators.minLength(2,
                  errorText: 'Minimum 2 characters'),
              FormBuilderValidators.maxLength(50,
                  errorText: 'Maximum 50 characters'),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'Address',
            controller: widget.addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              filled: true,
              prefixIcon: Icon(Icons.location_on, color: Colors.black),
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(errorText: 'Address is required'),
              FormBuilderValidators.minLength(2,
                  errorText: 'Minimum 2 characters'),
              FormBuilderValidators.maxLength(50,
                  errorText: 'Maximum 50 characters'),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'Phone',
            controller: widget.phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              filled: true,
              prefixIcon: Icon(Icons.phone, color: Colors.black),
            ),
            keyboardType:TextInputType.phone,
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.phoneNumber()
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'Password',
            controller: widget.passwordController,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              filled: true,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  _showPassword ? Icons.visibility : Icons.visibility_off,
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
              FormBuilderValidators.minLength(6,
                  errorText: 'Password must be at least 6 characters'),
            ]),
          ),
          const SizedBox(height: 10),
          FormBuilderTextField(
            name: 'Confirm Password',
            controller: widget.repeatPasswordController,
            obscureText: !_showRepeatPassword,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              filled: true,
              prefixIcon: const Icon(Icons.lock, color: Colors.black),
              suffixIcon: IconButton(
                icon: Icon(
                  _showRepeatPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _showRepeatPassword = !_showRepeatPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value != widget.passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Register',
                style: GoogleFonts.sora(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
