import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/object_model.dart';
import 'package:rekreacija_mobile/models/review_model.dart';
import 'package:rekreacija_mobile/providers/review_provider.dart';
import 'package:rekreacija_mobile/screens/hall_message_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/appointment_modal.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';
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
  late String rating;
  late String objectDescription;
  late Image objectImage;
  late int objectId;
  String userId = '';
  late ReviewProvider reviewProvider;
  List<ReviewModel> reviewModel = [];
  static String? baseUrl = String.fromEnvironment("BASE_URL",defaultValue:"http://10.0.2.2:5246/");
  

  @override
  void initState() {
    super.initState();
    reviewProvider = context.read<ReviewProvider>();
    initializeFields();
    getIdUser();
    getReviewsOfObject();
  }

  void initializeFields() {
    objectId = widget.object.id ?? 0;
    objectName = widget.object.name ?? '';
    objectAddress = widget.object.address ?? '';
    objectPrice = widget.object.price.toString();
    objectDescription = widget.object.description ?? '';
    rating = formatNumber(widget.object.rating!);
    objectImage = widget.object.imagePath != null
        ? Image.network('$baseUrl${widget.object.imagePath!}')
        : Image.asset("assets/images/RekreacijaDefault.jpg");
  }

  Future<void> getIdUser() async {
    final iduser = await getUserId();
    setState(() {
      userId = iduser;
    });
  }

  Future<void> getReviewsOfObject() async {
    try {
      var review = await reviewProvider.getReviewofObject(objectId);
      setState(() {
        reviewModel = review;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  bool _hasCheckedToken = false;

  @override
  Widget build(BuildContext context) {
    if (!_hasCheckedToken) {
      _hasCheckedToken = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        bool isExpired = await isTokenExpired();
        if (isExpired) {
          showTokenExpiredDialog(context);
          return;
        }
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Details',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: customDecoration,
        child: SingleChildScrollView(
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
                      '$objectPrice KM',
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
                        Text(rating,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            Icons.local_post_office_outlined,
                            color: Colors.white,
                            size: 25.0,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HallMessageScreen(
                                          userId: widget.object.user_id ??
                                              '',
                                          hallName: objectName,
                                        )));
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
                        // onPressed: () {
                        //   Navigator.pushNamed(context, '/appointment');
                        // },
                        onPressed: () async {
                          bool isExpired = await isTokenExpired();
                          if (isExpired) {
                            showTokenExpiredDialog(context);
                            return;
                          }

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AppointmentModal(
                                  price: objectPrice,
                                  object_id: objectId,
                                  userId: userId,
                                );
                              });
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
                    reviewModel.isNotEmpty
                        ? SizedBox(
                            height: 165.0,
                            child: PageView.builder(
                              controller: PageController(
                                  viewportFraction: 1.0, initialPage: 0),
                              itemCount: reviewModel.length,
                              itemBuilder: (context, index) {
                                final reviews = reviewModel[index];
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ReviewCard(
                                    rating: reviews.rating.toString(),
                                    comment: reviews.comment ?? 'No comment',
                                    personName: reviews.user != null
                                        ? '${reviews.user!.firstName ?? ''} ${reviews.user!.lastName ?? ''}'
                                        : 'Anonymous',
                                    image: reviews.user?.profilePicture != null
                                        ? imageFromString(
                                            reviews.user!.profilePicture!)
                                        : Image.asset(
                                            "assets/images/RekreacijaDefaultProfilePicture.png"),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                "There are no reviews for this object yet.",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                    const SizedBox(height: 10.0),
                    SizedBox(
                      width: 400,
                      height: 50,
                      child: TextButton(
                        onPressed: () async {
                          final bool? result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return ReviewModal(
                                  userId: userId,
                                  objectId: objectId,
                                );
                              });
                          if (result == true) {
                            getReviewsOfObject();
                          }
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
