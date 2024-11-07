import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/screens/homepage_screen.dart';
import 'package:rekreacija_mobile/screens/role_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _showPassword = false;
  Color _emailColor = Colors.black;

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
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: widget._emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 50),
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
              const SizedBox(height: 20),
              TextField(
                controller: widget._passwordController,
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 15),
                  fillColor: Color.fromRGBO(255, 255, 255, 50),
                  filled: true,
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    print('Forgot Password');
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 400,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePageScreen()));
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
              const SizedBox(height: 70),
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const RoleSelectionScreen()));
                  print('registriraj se ovjde');
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
