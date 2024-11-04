import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordContoller =
      TextEditingController();

  @override
  State<StatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  Color _emailColor = Colors.black;
  Color _firstNameColor = Colors.black;
  Color _lastNameColor = Colors.black;
  Color _phoneColor = Colors.black;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 500,
          height: 700,
          decoration: BoxDecoration(color: Colors.grey[100]),
          child: Column(
            children: [
              const Text('Register your account',
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: widget._firstNameController,
                      decoration: InputDecoration(
                        labelText: 'FirstName',
                        prefixIcon: Icon(Icons.perm_identity),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                        errorText: _firstNameColor == Colors.red
                            ? 'The firstName is invalid. The firstName can have min 2 and max 50 letters'
                            : null,
                      ),
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: _firstNameColor),
                      onChanged: (value) => validateFirstOrLastName(
                          widget._firstNameController, true),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget._lastNameController,
                      decoration: InputDecoration(
                        labelText: 'LastName',
                        prefixIcon: Icon(Icons.perm_identity),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                        errorText: _lastNameColor == Colors.red
                            ? 'The lastName is invalid. The lastName can have min 2 and max 50 letters'
                            : null,
                      ),
                      keyboardType: TextInputType.name,
                      style: TextStyle(color: _lastNameColor),
                      onChanged: (value) => validateFirstOrLastName(
                          widget._lastNameController, false),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget._usernameNameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.perm_identity),
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
                        prefixIcon: const Icon(Icons.email),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        errorText: _emailColor == Colors.red
                            ? 'Email is invalid. Pattern: email@example.com'
                            : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: _emailColor),
                      onChanged: (value) =>
                          emailValidation(widget._emailController),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: TextEditingController(),
                      decoration: const InputDecoration(
                        labelText: 'Datum rodjenja',
                        prefixIcon: Icon(Icons.calendar_today),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.datetime,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget._phoneController,
                      decoration: InputDecoration(
                        labelText: 'Broj telefona',
                        prefixIcon: Icon(Icons.phone),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
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
                      controller: TextEditingController(),
                      decoration: const InputDecoration(
                        labelText: 'Grad',
                        prefixIcon: Icon(Icons.location_city),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: widget._passwordController,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
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
                        prefixIcon: const Icon(Icons.lock),
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
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        border: const OutlineInputBorder(),
                        errorText: _passwordColor == Colors.red
                            ? 'The passwords didn\t match'
                            : null,
                      ),
                      style: TextStyle(color: _passwordColor),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 500,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          print('Register');
                        },
                        child: Text('REGISTER'),
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            print('Login');
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
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
