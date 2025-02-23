import 'package:flutter/material.dart';

class HallCard extends StatefulWidget {
  final String hallName;
  final String hallAdress;
  final Image image;
  final String rating;

  const HallCard({super.key, required this.hallAdress, required this.hallName, required this.image, required this.rating});

  @override
  State<StatefulWidget> createState() => _HallCardState();
}

class _HallCardState extends State<HallCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0,right: 10.0),
      child: Card(
        color: const Color.fromRGBO(49, 49, 49, 0.8),
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: SizedBox(
          width: 400.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  color: Colors.grey[300],
                  child: Image(
                    image: widget.image.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.hallName,
                            style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.hallAdress,
                            style: const TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 21.0),
                    const SizedBox(width: 5.0),
                    Text(widget.rating, style: const TextStyle(color: Colors.white))
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
            ],            
          ),      
        ),
      ),
    );
  }
}