import 'package:flutter/material.dart';

class CardView extends StatefulWidget {
  final IconData icon;
  int num;
  String decription;
  bool isLoading;
  CardView(
      {super.key,
      required this.icon,
      required this.num,
      required this.decription,
      required this.isLoading});
      
  @override
  State<StatefulWidget> createState() => _CardView();
}

class _CardView extends State<CardView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: SizedBox(
        width: 300,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: Colors.black,
                size: 80,
              ),
              const SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.isLoading ? "Loading..." : widget.num.toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.decription,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
