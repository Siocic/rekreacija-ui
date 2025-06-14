import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/notification_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/review_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/card_view.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

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
  String? baseUrl = "http://localhost:5246";
  List<ReviewModel> reviewsOfMyObject = [];

  @override
  void initState() {
    super.initState();
    objectProvider = context.read<ObjectProvider>();
    notificationProvider = context.read<NotificationProvider>();
    reviewProvider = context.read<ReviewProvider>();
    fetchData();
  }

  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  Future<void> fetchData() async {
    try {
      final userObject = await objectProvider.getObjectOfLoggedUser();
      final userNotification =
          await notificationProvider.getNotificationsOfUser();
      final reviews = await reviewProvider.getReviewsForMyObjects();

      setState(() {
        numberOfObjects = userObject.length;
        numberOfNotifications = userNotification.length;
        numberOfReviews = reviews.length;
        reviewsOfMyObject = reviews;
        object = userObject.isNotEmpty ? userObject.first : null;
        isLoading = false;
        for (var r in reviewsOfMyObject) {
          int rating = r.rating?.round() ?? 0;
          if (ratingCounts.containsKey(rating)) {
            ratingCounts[rating] = ratingCounts[rating]! + 1;
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));

      setState(() {
        isLoading = false;
      });
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

    /* CHART FOR RATINGS --START */
    List<BarChartGroupData> ratingBars = ratingCounts.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.orange,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          )
        ],
      );
    }).toList();
    /* CHART FOR RATINGS --END */

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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (object != null) ...[
                  const Text("Last added object"),
                  objectCardView(
                    object!.name!,
                    object!.address!,
                    object!.imagePath != null
                        ? Image.network('$baseUrl${object!.imagePath!}')
                        : Image.asset("assets/images/RekreacijaDefault.jpg"),
                  ),
                ]
              ],
            ),
            const SizedBox(width: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reviews by rating",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: ratingCounts.values
                              .reduce((a, b) => a > b ? a : b)
                              .toDouble() +
                          2,
                      //barTouchData: const BarTouchData(enabled: true),
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              rod.toY.toInt().toString(),
                              const TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) =>
                                Text('${value.toInt()}★'),
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: ratingBars,
                    ),
                  ),
                ),
              ],
            ),
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
