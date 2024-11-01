import 'package:flutter/material.dart';

class ProfileParts extends StatefulWidget {
  const ProfileParts(
      {super.key, required this.labelText, required this.inputText});
  final String labelText;
  final String inputText;

  @override
  State<ProfileParts> createState() => _ProfileParts();
}

class _ProfileParts extends State<ProfileParts> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              widget.labelText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: widget.inputText),
            readOnly: true,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: 10.0), 
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
