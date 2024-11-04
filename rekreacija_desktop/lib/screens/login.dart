import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/home_page.dart';
import 'package:rekreacija_desktop/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        width: 400,
        height: 400,
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
                  const SizedBox(height: 20),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePageScreen()));
                      },
                      child: Text('LOGIN'),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                          'Don\'t have an account? '), // Note the space after the question mark
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
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
