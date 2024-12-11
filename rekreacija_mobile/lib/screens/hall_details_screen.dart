import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/review_card.dart';

class HallDetailsScreen extends StatefulWidget {
  const HallDetailsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  bool _isExpanded = false;
  final bool _isCommentExapnded = false;

  @override
  Widget build(BuildContext context) {
    String description =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged ";
    String comment =
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the";

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Details',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.favorite_border,
              color: Colors.white,
            ),
          )
        ],
      ),   
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(225, 19, 19, 19),
              Color.fromARGB(225, 49, 49, 49),
            ], begin: Alignment.topRight, end: Alignment.bottomLeft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20.0),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 400.0,
                    height: 230.0,
                    color: Colors.grey[300],
                    child:
                        const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hall Name',
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Hall Address',
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      'Hall Price/h',
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.star,
                            color: Colors.yellow, size: 25.0),
                        const SizedBox(width: 5.0),
                        const Text('5.0',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.local_post_office_outlined,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/hallMessage');
                          },
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 20.0),
                    Text(
                      'Description',
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: _isExpanded
                                ? description
                                : "${description.substring(0, 100)}...  ",
                            style: GoogleFonts.suezOne(
                              color: Colors.white,
                              fontSize: 17.0,
                            ),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                _isExpanded ? "Show Less" : "Read More",
                                style: GoogleFonts.suezOne(
                                  color:
                                      const Color.fromRGBO(198, 124, 78, 100),
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/appointment');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(14, 119, 62, 1.0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                        child: const Text(
                          'Make an appointment',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Divider(),
                    Text(
                      'Reviews',
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    SizedBox(
                      height: _isCommentExapnded ? 180.0 : 160.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ReviewCard(rating: '5.0', personName: 'personName', comment: comment)
                            
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/hallReview');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(14, 119, 62, 1.0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(16.0)),
                        ),
                        child: const Text(
                          'Leave a review',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
