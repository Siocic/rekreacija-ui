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
import 'package:rekreacija_desktop/widgets/build_card.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';
import 'package:rekreacija_desktop/widgets/stat_card.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ContentHeader(title: 'Dashboard'),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  StatCard(
                    icon: Icons.apartment,
                    label: "My objects",
                    value: numberOfObjects,
                  ),
                  StatCard(
                    icon: Icons.people_alt,
                    label: "Total users",
                    value: numberOfUsers,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                children: [
                  BuildCard(
                      title: "Reviews by Rating",
                      child: _buildRatingChart(),
                      screenWidth: screenWidth),
                  BuildCard(
                      title: "Object per user",
                      child: _buildPieChart(),
                      screenWidth: screenWidth),
                ],
              ),
              const SizedBox(height: 30),
              _buildLineChart()
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRatingChart() {
    List<BarChartGroupData> bars = ratingCounts.entries.map((e) {
      return BarChartGroupData(x: e.key, barRods: [
        BarChartRodData(
            toY: e.value.toDouble(), color: Colors.orange, width: 16),
      ]);
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text('${value.toInt()}★'),
            ),
          ),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildPieChart() {
    // Funkcija za generisanje nasumične pastelne boje (da ne bude previše jarko)
    Color getRandomColor() {
      final Random random = Random();
      int r = 180 + random.nextInt(75);
      int g = 180 + random.nextInt(75);
      int b = 180 + random.nextInt(75);
      return Color.fromARGB(255, r, g, b);
    }

    final double total = countObjectPerUser.values.fold(0, (a, b) => a + b);
    List<PieChartSectionData> sections = [];
    Map<String, Color> userColors = {};

    countObjectPerUser.forEach((name, count) {
      final percent = (count / total) * 100;
      final color = getRandomColor();
      userColors[name] = color;
      sections.add(PieChartSectionData(
        value: count.toDouble(),
        title: '${percent.toStringAsFixed(1)}%',
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
    });

    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pie chart zauzima fiksno 180x180
          SizedBox(
            height: 180,
            width: 180,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: SizedBox(
              height: 180,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: countObjectPerUser.keys.map((objectName) {
                    final color = userColors[objectName] ?? Colors.grey;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, color: color),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(objectName),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
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

    return Column(
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
                          sortedKeys[index].substring(5),
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
                      style: const TextStyle(fontSize: 12),
                    ),
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
                  spots: allSpots,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                ),
                LineChartBarData(
                  spots: approvedSpots,
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
    );
  }
}
