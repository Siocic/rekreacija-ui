import 'package:flutter/material.dart';

class HallCard extends StatefulWidget {
  final String hallName;
  final String hallAdress;

  const HallCard({super.key, required this.hallAdress, required this.hallName});

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  width: double.infinity,
                  height: 150.0,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          children: [
                            Text(
                              widget.hallName,
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.hallAdress,
                              style: const TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 21.0),
                    SizedBox(width: 5.0),
                    Text('5.0', style: TextStyle(color: Colors.white))
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
