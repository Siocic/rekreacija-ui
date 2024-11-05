import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/screens/login_screen.dart';

class PravnoliceScreen extends StatefulWidget {
  PravnoliceScreen({super.key});

  final TextEditingController _nazivUstanove = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordContoller =
      TextEditingController();

  @override
  State<StatefulWidget> createState() => _PravnoliceScreen();
}

class _PravnoliceScreen extends State<PravnoliceScreen> {
  Color _nazivUstanoveColor = Colors.black;
  Color _emailColor = Colors.black;
  Color _addressColor = Colors.black;
  Color _passwordColor = Colors.black;
  bool _showPassword = false;
  bool _showRepeatPassword = false;

  bool validateNazivUstanove(TextEditingController controller) {
    if (controller.text.isEmpty) {
      setState(() {
        _nazivUstanoveColor = Colors.red;
      });
      return false;
    } else if ((controller.text.length < 10 || controller.text.length < 30)) {
      setState(() {
        _nazivUstanoveColor = Colors.red;
      });
      return false;
    }
    setState(() {
      _nazivUstanoveColor = Colors.black;
    });
    return true;
  }

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
              const SizedBox(height: 100),
              Text(
                'Register here',
                style: GoogleFonts.sora(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),  const SizedBox(height: 10),
              TextField(
                controller: widget._nazivUstanove,
                decoration: InputDecoration(
                  labelText: 'Naziv ustanove',
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
                  errorText: _nazivUstanoveColor == Colors.red
                      ? 'The nazivUstanove is invalid. The nazivUstanove can have min 10 and max 30 letters'
                      : null,
                ),
                keyboardType: TextInputType.name,
                style: TextStyle(color: _nazivUstanoveColor),
                onChanged: (value) =>
                    validateNazivUstanove(widget._nazivUstanove),
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
                  labelStyle: const TextStyle(color: Colors.black, fontSize: 15),
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
              const SizedBox(height: 20),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
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
