import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/providers/notification_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/review_provider.dart';
import 'package:rekreacija_desktop/widgets/card_view.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<StatefulWidget> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ObjectProvider objectProvider;
  late NotificationProvider notificationProvider;
  late ReviewProvider reviewProvider;
  int numberOfObjects = 0;
  int numberOfNotifications = 0;
  int numberOfReviews = 0;
  bool isLoading = true;
  ObjectModel? object;

  @override
  void initState() {
    super.initState();
    objectProvider = context.read<ObjectProvider>();
    notificationProvider = context.read<NotificationProvider>();
    reviewProvider = context.read<ReviewProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final userObject = await objectProvider.getObjectOfLoggedUser();
      userObject.sort((a, b) => b.created_date!.compareTo(a.created_date!));
      final userNotification =
          await notificationProvider.getNotificationsOfUser();
      final reviews = await reviewProvider.getReviewsForMyObjects();

      setState(() {
        numberOfObjects = userObject.length;
        numberOfNotifications = userNotification.length;
        numberOfReviews = reviews.length;
        object = userObject.isNotEmpty ? userObject.first : null;
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.all(40.0),
        child: ContentHeader(title: 'Dashboard'),
      ),
      const SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardView(
                icon: Icons.apartment,
                num: numberOfObjects,
                decription: "My objects",
                isLoading: isLoading),
            const SizedBox(width: 10),
            CardView(
                icon: Icons.reviews,
                num: numberOfReviews,
                decription: "Total reivews",
                isLoading: isLoading),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (object != null) ...[
              const Text("Last added object"),
              objectCardView(
                object!.name!,
                object!.address!,
                object!.objectImage != null
                    ? imageFromString(object!.objectImage!)
                    : Image.asset("assets/images/RekreacijaDefault.jpg"),
              ),
            ]
          ],
        ),
      )
    ]);
  }
}

Widget objectCardView(
    String objectName, String objectAddress, final Image image) {
  return Card(
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    child: SizedBox(
      width: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
            child: Container(
              width: double.infinity,
              height: 200.0,
              color: Colors.grey[300],
              child: Image(
                image: image.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  objectName,
                  style: GoogleFonts.suezOne(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  objectAddress,
                  style: GoogleFonts.suezOne(
                    color: Colors.black54,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
