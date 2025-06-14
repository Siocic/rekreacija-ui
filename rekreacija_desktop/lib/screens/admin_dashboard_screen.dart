import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:rekreacija_desktop/models/appointment_model.dart';
import 'package:rekreacija_desktop/models/object_count_per_user_model.dart';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/review_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/card_view.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _AdminDashboard();
}

class _AdminDashboard extends State<AdminDashboard> {
  late ObjectProvider objectProvider;
  late AuthProvider authProvider;
  late ReviewProvider reviewProvider;
  late AppointmentProvider appointmentProvider;
  int numberOfObjects = 0;
  int numberOfUsers = 0;
  bool isObjects = true;
  bool isUser = true;
  List<ReviewModel> reviewList = [];
  List<ObjectCountPerUserModel> objectsPerUser = [];
  List<AppointmentModel> allAppointment = [];

  @override
  void initState() {
    super.initState();
    objectProvider = context.read<ObjectProvider>();
    authProvider = context.read<AuthProvider>();
    reviewProvider = context.read<ReviewProvider>();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchData();
  }

  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
  Map<String, int> countObjectPerUser = {};
  Map<String, int> totalCounts = {};
  Map<String, int> approvedCounts = {};

  Future<void> fetchData() async {
    try {
      var objects = await objectProvider.Get();
      var users = await authProvider.getAllUser();
      var review = await reviewProvider.Get();
      var countedObject = await objectProvider.getCountObjectPerUser();
      var appoinmentList = await appointmentProvider.Get();

      setState(() {
        numberOfObjects = objects.length;
        numberOfUsers = users.length;
        reviewList = review;
        objectsPerUser = countedObject;
        isObjects = false;
        isUser = false;
        allAppointment = appoinmentList;

        for (var r in reviewList) {
          int rating = r.rating?.round() ?? 0;
          if (ratingCounts.containsKey(rating)) {
            ratingCounts[rating] = ratingCounts[rating]! + 1;
          }
        }
        for (var c in objectsPerUser) {
          final userName = c.fullName;
          int count = c.objectCount ?? 0;
          countObjectPerUser[userName.toString()] =
              (countObjectPerUser[userName] ?? 0) + count;
        }
        for (var appt in allAppointment) {
          final date = DateTime.parse(appt.appointment_date.toString());
          final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";

          totalCounts[key] = (totalCounts[key] ?? 0) + 1;

          if (appt.is_approved == true) {
            approvedCounts[key] = (approvedCounts[key] ?? 0) + 1;
          }
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));

      setState(() {
        isObjects = false;
        isUser = false;
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

    /*PIE CHART FOR OBJECTS OF USERS --START*/
    Color getRandomColor() {
      final Random random = Random();
      int r = 180 + random.nextInt(80);
      int g = 180 + random.nextInt(80);
      int b = 180 + random.nextInt(80);
      return Color.fromARGB(255, r, g, b);
    }

    final double totalCount =
        countObjectPerUser.values.fold(0, (a, b) => a + b);
    List<PieChartSectionData> sections = [];
    Map<String, Color> userColors = {};

    int i = 0;
    countObjectPerUser.forEach((userName, count) {
      final percent = (count / totalCount * 100).toStringAsFixed(1);
      final color = getRandomColor();
      userColors[userName] = color;
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: '$percent%',
        color: color,
        radius: 70,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
      i++;
    });
/*PIE CHART FOR OBJECTS OF USERS --END*/

/* LINE CHART ZA UKUPNE APPOINTMNETE --START */
    final sortedKeys = totalCounts.keys
        .toSet()
        .union(approvedCounts.keys.toSet())
        .toList()
      ..sort((a, b) => a.compareTo(b));

    List<FlSpot> allSpots = [];
    List<FlSpot> approvedSpots = [];

    for (int i = 0; i < sortedKeys.length; i++) {
      final key = sortedKeys[i];
      allSpots.add(FlSpot(i.toDouble(), (totalCounts[key] ?? 0).toDouble()));
      approvedSpots
          .add(FlSpot(i.toDouble(), (approvedCounts[key] ?? 0).toDouble()));
    }

/* LINE CHART ZA UKUPNE APPOINTMNETE --END */

    return SingleChildScrollView(
      child: Column(
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
                    decription: "Total objects",
                    isLoading: isObjects),
                const SizedBox(width: 10),
                CardView(
                    icon: Icons.people_alt,
                    num: numberOfUsers,
                    decription: "Total users",
                    isLoading: isUser),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 30, bottom: 10),
            child: Row(
              children: [
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
                const SizedBox(width: 80),
                Column(
                  children: [
                    const Text(
                      "Object by user",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 80),
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          centerSpaceRadius: 40,
                          sectionsSpace: 2,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: countObjectPerUser.keys
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      //int index = entry.key;
                      final username = entry.value.toString();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              color: userColors[username],
                            ),
                            const SizedBox(width: 8),
                            Text(username),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reservation Trends",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: LineChart(
                    LineChartData(
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) {
                              int index = value.toInt();
                              if (index < sortedKeys.length) {
                                return Text(
                                  sortedKeys[index].substring(5), // Month part
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, _) => Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                        topTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles:
                            AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: allSpots, // All reservations
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.blue,
                          dotData: FlDotData(show: true),
                        ),
                        LineChartBarData(
                          spots: approvedSpots, // Approved reservations
                          isCurved: true,
                          barWidth: 3,
                          color: Colors.red,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Legend
                Row(
                  children: [
                    Row(
                      children: [
                        Container(width: 12, height: 12, color: Colors.blue),
                        const SizedBox(width: 6),
                        const Text("All Reservations"),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Container(width: 12, height: 12, color: Colors.red),
                        const SizedBox(width: 6),
                        const Text("Approved Reservations"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
