import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReviewCard extends StatefulWidget {
  final String rating;
  final String personName;
  final String comment;

  const ReviewCard(
      {super.key,
      required this.rating,
      required this.personName,
      required this.comment});

  State<StatefulWidget> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _isCommentExapnded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 49, 49, 0.8),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: 390.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 30, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          widget.rating,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16.0),
                        ),
                      ],
                    ),
                    Text(
                      widget.personName,
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _isCommentExapnded
                                ? widget.comment
                                : widget.comment.substring(0, 30) + "...",
                            style: GoogleFonts.suezOne(
                              color: Colors.white,
                              fontSize: 15.0,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCommentExapnded = !_isCommentExapnded;
                                });
                              },
                              child: Text(
                                _isCommentExapnded ? "Show Less" : "Show More",
                                style: const TextStyle(
                                    color: Color.fromRGBO(198, 124, 78, 1.0),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
