import 'package:flutter/material.dart';

class SportSection extends StatefulWidget {
  final String hallName;
  final String hallAdress;
  final Image image;
  final VoidCallback? onFavoritePressed;

  const SportSection(
      {super.key,
      required this.hallAdress,
      required this.hallName,
      required this.image,
      required this.onFavoritePressed});

  @override
  State<StatefulWidget> createState() => _SportSectionState();
}

class _SportSectionState extends State<SportSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 49, 49, 0.8),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 120.0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 100.0,
                height: 120.0,
                color: Colors.grey[300],
                child: Image(image: widget.image.image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.hallName,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      widget.hallAdress,
                      style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: widget.onFavoritePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
