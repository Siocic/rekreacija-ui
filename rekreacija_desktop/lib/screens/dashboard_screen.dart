import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/my_client_payments_model.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
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
  late AppointmentProvider appointmentProvider;
  int numberOfObjects = 0;
  int numberOfNotifications = 0;
  int numberOfReviews = 0;
  bool isLoading = true;
  ObjectModel? object;
  static String? baseUrl = String.fromEnvironment("BASE_URL",
      defaultValue: "http://localhost:5246/");
  List<ReviewModel> reviewsOfMyObject = [];
  List<MyClientPaymentsModel> payments = [];
  List<MyClientPaymentsModel> appointments = [];

  @override
  void initState() {
    super.initState();
    objectProvider = context.read<ObjectProvider>();
    notificationProvider = context.read<NotificationProvider>();
    reviewProvider = context.read<ReviewProvider>();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchData();
  }

  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  Map<String, double> amountPerObject = {};
  Map<String, double> monthlyCounts = {};
  Map<String, double> reservationCounts = {};

  Future<void> fetchData() async {
    try {
      final userObject = await objectProvider.getObjectOfLoggedUser();
      final userNotification =
          await notificationProvider.getNotificationsOfUser();
      final reviews = await reviewProvider.getReviewsForMyObjects();
      final paymentsList = await appointmentProvider.getMyClientPayments();
      final appointmentList = await appointmentProvider.getMyClientPayments();

      setState(() {
        numberOfObjects = userObject.length;
        numberOfNotifications = userNotification.length;
        numberOfReviews = reviews.length;
        reviewsOfMyObject = reviews;
        object = userObject.isNotEmpty ? userObject.first : null;
        payments = paymentsList;
        appointments = appointmentList;
        isLoading = false;
        for (var r in reviewsOfMyObject) {
          int rating = r.rating?.round() ?? 0;
          if (ratingCounts.containsKey(rating)) {
            ratingCounts[rating] = ratingCounts[rating]! + 1;
          }
        }
        for (var appt in payments) {
          final objectId = appt.objectName;
          final amount = appt.amount?.toDouble() ?? 0;

          if (amountPerObject.containsKey(objectId)) {
            amountPerObject[objectId.toString()] =
                amountPerObject[objectId]! + amount;
          } else {
            amountPerObject[objectId.toString()] = amount;
          }
        }
        for (var appt in appointments) {
          final date = DateTime.parse(appt.appointmentDate.toString());
          final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
          final objectName = appt.objectName;
          if (!monthlyCounts.containsKey(key)) {
            monthlyCounts[key] = 1;
          } else {
            monthlyCounts[key] = monthlyCounts[key]! + 1;
          }
          if (reservationCounts.containsKey(objectName)) {
            reservationCounts[objectName.toString()] =
                reservationCounts[objectName]! + 1;
          } else {
            reservationCounts[objectName.toString()] = 1;
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

    /* RENEVUE PER OBJECT --START */
    List<BarChartGroupData> amountBars = [];
    List<String> objectNames = amountPerObject.keys.toList();
    for (int i = 0; i < objectNames.length; i++) {
      String name = objectNames[i];
      double value = amountPerObject[name]!;
      amountBars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                toY: value,
                color: Colors.purple,
                width: 20,
                borderRadius: BorderRadius.circular(4)),
          ],
        ),
      );
    }
    /* RENEVUE PER OBJECT --END */

    /* APPOINTMENT COUNT PER MONTH --START */
    final sortedKeys = monthlyCounts.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    List<BarChartGroupData> barData = [];
    int index = 0;
    for (var key in sortedKeys) {
      barData.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: monthlyCounts[key]!.toDouble(),
              color: Colors.blue,
              width: 20,
              borderRadius: BorderRadius.circular(4),
            )
          ],
        ),
      );
      index++;
    }
    /* APPOINTMENT COUNT PER MONTH --END */

    /* BROJ REZERVACIJA PO OBJEKTU ---START */
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.brown
    ];
    double totalReservations =
        reservationCounts.values.fold(0, (a, b) => a + b);

    List<PieChartSectionData> sections = [];
    int i = 0;
    reservationCounts.forEach((objectName, count) {
      final percent = (count / totalReservations * 100).toStringAsFixed(1);

      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$percent%',
          color: colors[i % colors.length],
          radius: 70,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
      i++;
    });
    /* BROJ REZERVACIJA PO OBJEKTU ---END */

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  if (reviewsOfMyObject.isNotEmpty) ...[
                    const Text(
                      "Reviews by rating",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
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
                  ] else ...[
                    const Text(""),
                  ],
                ],
              ),
              const SizedBox(width: 35),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (amountPerObject.isNotEmpty) ...[
                    const Text(
                      "Renevue per object",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height: 300,
                      width: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: amountBars,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
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
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();
                                  if (index >= 0 &&
                                      index <= objectNames.length) {
                                    return Text(objectNames[index]);
                                  } else {
                                    return const Text('');
                                  }
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    const Text(""),
                  ],
                ],
              ),
              const SizedBox(width: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (reservationCounts.isNotEmpty) ...[
                    const Text(
                      "Appointments per object",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 80),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: reservationCounts.keys
                          .toList()
                          .asMap()
                          .entries
                          .map((entry) {
                        int index = entry.key;
                        final objectId = entry.value.toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                color: colors[index % colors.length],
                              ),
                              const SizedBox(width: 8),
                              Text("$objectId"),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ] else ...[
                    const Text(""),
                  ]
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: monthlyCounts.isNotEmpty
                ? [
                    const Text(
                      "Appointments per month",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: BarChart(
                        BarChartData(
                          barGroups: barData,
                          barTouchData: BarTouchData(
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
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
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() < sortedKeys.length) {
                                    final label = sortedKeys[value.toInt()];
                                    return Text(getMonthName(label));
                                  } else {
                                    return const Text('');
                                  }
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    const Text(""),
                  ],
          ),
        )
      ],
    );
  }
}

String getMonthName(String key) {
  final parts = key.split('-');
  final monthNum = int.tryParse(parts[1]) ?? 1;
  const monthNames = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  return monthNames[monthNum - 1];
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
