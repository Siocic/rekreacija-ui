import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final String name;
  final String description;
  final String username;
  final String date;

  const NotificationCard(
      {super.key,
      required this.name,
      required this.description,
      required this.username,
      required this.date});

  @override
  State<StatefulWidget> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 49, 49, 0.8),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                  const Spacer(),
                  Text(
                    widget.date,
                    style: const TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                widget.name,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.description,
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
