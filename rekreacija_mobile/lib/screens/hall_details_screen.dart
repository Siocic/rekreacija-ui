import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/review_card.dart';
import 'package:rekreacija_mobile/widgets/review_modal.dart';

class HallDetailsScreen extends StatefulWidget {
  final ObjectModel object;
  const HallDetailsScreen({super.key, required this.object});
  @override
  State<StatefulWidget> createState() => _HallDetailsScreenState();
}

class _HallDetailsScreenState extends State<HallDetailsScreen> {
  bool _isExpanded = false;
  late String objectName;
  late String objectAddress;
  late String objectPrice;
  late String objectDescription;
  late Image objectImage;
  late int objectId;
  String userId = '';

  @override
  void initState() {
    super.initState();
    initializeFields();
    getIdUser();
  }

  void initializeFields() {
    objectId=widget.object.id??0;
    objectName = widget.object.name ?? '';
    objectAddress = widget.object.address ?? '';
    objectPrice = widget.object.price.toString();
    objectDescription = widget.object.description ?? '';
    objectImage = widget.object.objectImage != null
        ? imageFromString(widget.object.objectImage!)
        : Image.asset("assets/images/RekreacijaDefault.jpg");
  }

  Future<void> getIdUser() async {
    final iduser = await getUserId();
    setState(() {
      userId = iduser;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          decoration: customDecoration,
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
                    child: Image(
                      image: objectImage.image,
                      fit: BoxFit.cover,
                    ),
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
                      objectName,
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      objectAddress,
                      style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      '${objectPrice} KM',
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
                            text: objectDescription.length <= 100
                                ? objectDescription
                                : _isExpanded
                                    ? objectDescription
                                    : "${objectDescription.substring(0, 100)}...",
                            style: GoogleFonts.robotoSlab(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                          if (objectDescription.length > 100)
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
                      height: 165.0,
                      child: PageView.builder(
                        controller: PageController(
                            viewportFraction: 1.0, initialPage: 0),
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ReviewCard(
                                  rating: '5.0',
                                  personName: 'personName',
                                  comment: comment));
                        },
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ReviewModal(userId: userId,objectId: objectId,);
                              });
                          //Navigator.pushNamed(context, '/hallReview');
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
