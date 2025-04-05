import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/login.dart';

void showTokenExpiredDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: const Text("Session Expired"),
      content: const Text("Your session has expired. Please log in again."),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("OK"))
      ],
    ),
  );
}
