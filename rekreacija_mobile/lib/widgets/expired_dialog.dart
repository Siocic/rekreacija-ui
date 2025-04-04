import 'package:flutter/material.dart';
import 'package:rekreacija_mobile/routes.dart';

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
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
            child: const Text("OK"))
      ],
    ),
  );
}
