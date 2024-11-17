import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rekreacija_mobile/routes.dart';

class FizickoliceScreen extends StatefulWidget {
  FizickoliceScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordContoller =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _FizickoliceScreen();
}

class _FizickoliceScreen extends State<FizickoliceScreen> {
  Color _emailColor = Colors.black;
  Color _firstNameColor = Colors.black;
  Color _lastNameColor = Colors.black;
  Color _phoneColor = Colors.black;
  Color _addressColor = Colors.black;
  Color _passwordColor = Colors.black;
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  bool emailValidation(TextEditingController controller) {
    final emailRegex = RegExp(
        r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");
    if (controller.text.isEmpty) {
      setState(() {
        _emailColor = Colors.red;
      });
      return false;
    } else if (emailRegex.hasMatch(controller.text) == false) {
      setState(() {
        _emailColor = Colors.red;
      });
      return false;
    }
    setState(() {
      _emailColor = Colors.black;
    });
    return true;
  }

  bool validateFirstOrLastName(
      TextEditingController controller, bool isFirstName) {
    if (controller.text.isEmpty && isFirstName) {
      setState(() {
        _firstNameColor = Colors.red;
      });
      return false;
    }
    if (controller.text.isEmpty && !isFirstName) {
      setState(() {
        _lastNameColor = Colors.red;
      });
      return false;
    }
    if ((controller.text.length < 2 || controller.text.length > 50)) {
      if (isFirstName) {
        setState(() {
          _firstNameColor = Colors.red;
        });
      } else {
        setState(() {
          _lastNameColor = Colors.red;
        });
      }
      return false;
    }
    if (isFirstName) {
      setState(() {
        _firstNameColor = Colors.black;
      });
    } else {
      setState(() {
        _lastNameColor = Colors.black;
      });
    }
    return true;
  }

  bool phoneNumberValidation(TextEditingController controller) {
    final phoneRegex = RegExp(r"^\+?[0-9]*$");

    if (controller.text.isEmpty) {
      setState(() {
        _phoneColor = Colors.red;
      });
      return false;
    } else if (!phoneRegex.hasMatch(controller.text)) {
      setState(() {
        _phoneColor = Colors.red;
      });
      return false;
    }
    setState(() {
      _phoneColor = Colors.black;
    });
    return true;
  }

  bool checkPasswords(
      TextEditingController password, TextEditingController repeatPassword) {
    if ((password.text != repeatPassword.text) || password.text.isEmpty) {
      setState(() {
        _passwordColor = Colors.red;
      });
      return false;
    }
    setState(() {
      _passwordColor = Colors.black;
    });
    return true;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        widget._birthdayController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(14, 121, 115, 100),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'Register here',
                style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._firstNameController,
                decoration: InputDecoration(
                  labelText: 'FirstName',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _firstNameColor == Colors.red
                      ? 'The firstName is invalid. The firstName can have min 2 and max 50 letters'
                      : null,
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(color: _firstNameColor),
                onChanged: (value) =>
                    validateFirstOrLastName(widget._firstNameController, true),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._lastNameController,
                decoration: InputDecoration(
                  labelText: 'LastName',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.perm_identity,
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _lastNameColor == Colors.red
                      ? 'The lastName is invalid. The lastName can have min 2 and max 50 letters'
                      : null,
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(color: _lastNameColor),
                onChanged: (value) =>
                    validateFirstOrLastName(widget._lastNameController, false),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._usernameNameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: Icon(Icons.perm_identity, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _emailColor == Colors.red
                      ? 'Email is invalid. Pattern: email@example.com'
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: _emailColor),
                onChanged: (value) => emailValidation(widget._emailController),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: Icon(Icons.location_city, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: Icon(Icons.location_city, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(color: _addressColor),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._birthdayController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Birthday',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  _selectDate(context);
                },
                keyboardType: TextInputType.none,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone number',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(Icons.phone, color: Colors.black),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _phoneColor == Colors.red
                      ? 'Phone only can have numbers'
                      : null,
                ),
                keyboardType: TextInputType.phone,
                style: TextStyle(color: _phoneColor),
                onChanged: (value) =>
                    phoneNumberValidation(widget._phoneController),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(_showPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _passwordColor == Colors.red
                      ? 'The passwords didn\t match'
                      : null,
                ),
                style: TextStyle(color: _passwordColor),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: widget._repeatPasswordContoller,
                obscureText: !_showRepeatPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  labelStyle:
                      const TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: const Color.fromRGBO(255, 255, 255, 100),
                  filled: true,
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(_showRepeatPassword
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _showRepeatPassword = !_showRepeatPassword;
                      });
                    },
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                  errorText: _passwordColor == Colors.red
                      ? 'The passwords didn\t match'
                      : null,
                ),
                style: TextStyle(color: _passwordColor),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 400,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageScreen()));
                    print('Register here');
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0))),
                  child: Text(
                    'Register here',
                    style: GoogleFonts.sora(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
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
