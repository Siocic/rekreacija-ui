import 'package:flutter/material.dart';

class BuildCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double screenWidth;

  const BuildCard({super.key, required this.title, required this.child, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
        double cardWidth = screenWidth < 600 ? screenWidth - 40 : 350;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(height: 250, child: child),
        ],
      ),
    );
  }
}
