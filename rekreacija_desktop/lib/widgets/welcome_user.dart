import 'package:flutter/material.dart';

class WelcomeUser extends StatefulWidget {
  const WelcomeUser({super.key});

  @override
  State<WelcomeUser> createState() => _WelcomeUser();
}

class _WelcomeUser extends State<WelcomeUser> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0, top: 30.0),
      child: Row(
        children: [
          const Text(
            'Welcome, Admin',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            width: 8,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              print('Kliknuli ste ovjde');
            },
          )
        ],
      ),
    );
  }
}
