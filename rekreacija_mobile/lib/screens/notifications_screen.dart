import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/notification_model.dart';
import 'package:rekreacija_mobile/providers/notification_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/notification_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late NotificationProvider _notificationProvider;
  List<NotificationModel> notificationModel = [];

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final notification = await _notificationProvider.Get();
      setState(() {
        notificationModel = notification;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaitons',
            style:
                GoogleFonts.ultra(fontWeight: FontWeight.w400, fontSize: 22)),
        backgroundColor: const Color.fromARGB(225, 29, 29, 29),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: customDecoration,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              notificationModel.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: notificationModel.length,
                        itemBuilder: (context, index) {
                          final notifaication = notificationModel[index];
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: NotificationCard(
                                name: notifaication.name ?? '',
                                description: notifaication.description ?? '',
                                username:
                                    '${notifaication.user!.firstName!} ${notifaication.user!.lastName!}',
                                date: DateFormat('d/M/y')
                                    .format(notifaication.created_date!)),
                          );
                        },
                      ),
                    )
                  : Text(
                      'No new notifications at this time.',
                      style:
                          GoogleFonts.ultra(color: Colors.white, fontSize: 15),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

Widget notificationCard(
    String name, String description, String username, String date) {
  return Card(
    color: const Color.fromRGBO(49, 49, 49, 0.8),
    margin: const EdgeInsets.symmetric(vertical: 8.0),
    child: SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  username,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white, fontSize: 16.0),
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            Text(
              name,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
            const SizedBox(height: 5.0),
            Text(
              description,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ],
        ),
      ),
    ),
  );
}
