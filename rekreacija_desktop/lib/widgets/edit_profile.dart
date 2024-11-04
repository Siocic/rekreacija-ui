import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  Color _emailColor = Colors.black;
  Color _firstNameColor = Colors.black;
  Color _lastNameColor = Colors.black;
  Color _phoneColor=Colors.black;

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

  bool phoneNumberValidation(TextEditingController controller)
  {
    final phoneRegex=RegExp(r"^\+?[0-9]*$");

    if(controller.text.isEmpty){
      setState(() {
        _phoneColor=Colors.red;
      });
      return false;
    }
    else if(!phoneRegex.hasMatch(controller.text)){
      setState(() {
        _phoneColor=Colors.red;
      });
      return false;
    }
    setState(() {
      _phoneColor=Colors.black;
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profile'),
            const SizedBox(height: 20),
            SizedBox(
              width: 400,
              child: Column(
                children: [
                  TextField(
                    controller: widget._firstNameController,
                    decoration: InputDecoration(
                      labelText: 'FirstName',
                      prefixIcon: const Icon(Icons.perm_identity),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      border: const OutlineInputBorder(),
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
                      prefixIcon: const Icon(Icons.perm_identity),
                      contentPadding:const EdgeInsets.symmetric(horizontal: 10.0),
                      border: const OutlineInputBorder(),
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
                    decoration:  InputDecoration(
                      labelText: 'Broj telefona',
                      prefixIcon: const Icon(Icons.phone),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                      border: const OutlineInputBorder(),
                       errorText: _phoneColor == Colors.red
                          ? 'Phone only can have numbers'
                          : null,
                    ),
                    keyboardType: TextInputType.phone,
                     style: TextStyle(color: _phoneColor),
                    onChanged: (value) => phoneNumberValidation(
                        widget._phoneController),
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
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                      TextButton(
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
          ],
        ),
      ),
    );
  }
}
