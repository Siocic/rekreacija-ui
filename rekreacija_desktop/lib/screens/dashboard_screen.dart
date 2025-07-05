import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/my_client_payments_model.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/providers/notification_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/providers/review_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/build_card.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';
import 'package:rekreacija_desktop/widgets/stat_card.dart';

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
  //static String? baseUrl = String.fromEnvironment("BASE_URL", defaultValue: "http://localhost:5246/");
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

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                      icon: Icons.reviews,
                      label: "Total reviews",
                      value: numberOfReviews,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: [
                    if (object != null) ...[
                      BuildCard(
                        title: "Last Added Object",
                        screenWidth: screenWidth,
                        child: objectCardContent(
                          object!.name!,
                          object!.address!,
                          object!.imagePath != null
                              ? Image.network('$baseUrl${object!.imagePath!}')
                              : Image.asset(
                                  "assets/images/RekreacijaDefault.jpg"),
                        ),
                      ),
                    ],
                    if (reviewsOfMyObject.isNotEmpty) ...[
                      BuildCard(
                          title: "Reviews by Rating",
                          child: _buildRatingChart(),
                          screenWidth: screenWidth),
                    ] else ...[
                      const Text(""),
                    ],
                    if (amountPerObject.isNotEmpty) ...[
                      BuildCard(
                          title: "Revenue per Object",
                          child: _buildRevenueChart(),
                          screenWidth: screenWidth),
                    ] else ...[
                      const Text(""),
                    ],
                    if (amountPerObject.isNotEmpty) ...[
                      BuildCard(
                          title: "Appointments per Object",
                          child: _buildPieChart(),
                          screenWidth: screenWidth),
                    ] else ...[
                      const Text(""),
                    ],
                  ],
                ),
                const SizedBox(height: 30),
                if(reservationCounts.isNotEmpty)...[
                  const Text("Appointments per Month",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: _buildMonthlyChart(),
                  )
                ]else...[
                    const Text(""),
                ]

                ]
            );
          },
        ),
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

  Widget _buildRevenueChart() {
    List<String> keys = amountPerObject.keys.toList();
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < keys.length; i++) {
      bars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            toY: amountPerObject[keys[i]]!, color: Colors.purple, width: 16),
      ]));
    }
    return BarChart(
      BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) => Text(keys[value.toInt()]),
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
    List<Color> colors = [Colors.blue, Colors.green, Colors.red, Colors.orange];

    double total = reservationCounts.values.fold(0, (a, b) => a + b);
    List<PieChartSectionData> sections = [];
    int i = 0;
    reservationCounts.forEach((name, count) {
      double percent = (count / total) * 100;
      sections.add(PieChartSectionData(
        value: count,
        title: '${percent.toStringAsFixed(1)}%',
        color: colors[i % colors.length],
        radius: 60,
      ));
      i++;
    });

    return Padding(
      padding: const EdgeInsets.only(left: 16.0), // Možeš povećati ako treba
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  reservationCounts.keys.toList().asMap().entries.map((entry) {
                int index = entry.key;
                final objectName = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        color: colors[index % colors.length],
                      ),
                      const SizedBox(width: 8),
                      Flexible(child: Text(objectName)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final sortedKeys = monthlyCounts.keys.toList()..sort();
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < sortedKeys.length; i++) {
      bars.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            toY: monthlyCounts[sortedKeys[i]]!, color: Colors.blue, width: 16),
      ]));
    }

    return BarChart(
      BarChartData(
        barGroups: bars,
        titlesData: FlTitlesData(
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
                  }),
            ),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false))),
        borderData: FlBorderData(show: false),
      ),
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

Widget objectCardContent(String name, String address, Image image) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 180,
          color: Colors.grey[300],
          child: Image(
            image: image.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      const SizedBox(height: 6),
      Text(
        address,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
    ],
  );
}
