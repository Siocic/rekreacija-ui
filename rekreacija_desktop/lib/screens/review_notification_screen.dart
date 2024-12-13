import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/notification_card.dart';
import 'package:rekreacija_desktop/widgets/notification_modal.dart';
import 'package:rekreacija_desktop/widgets/review_card.dart';

class ReviewNotificationScreen extends StatefulWidget {
  const ReviewNotificationScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ReviewNotificationState();
}

class _ReviewNotificationState extends State<ReviewNotificationScreen> {
  String comment =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
              title: 'Review & Notification',
              onLogout: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review',
                style: GoogleFonts.suezOne(fontSize: 20),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  TextButton(
                    onPressed: reviewLeft,
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_left_sharp,
                      color: Color.fromRGBO(14, 119, 62, 1),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  TextButton(
                    onPressed: reviewRight,
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Color.fromRGBO(14, 119, 62, 1),
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SizedBox(
            height: 320.0,
            width: 1590.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _reviewScrollController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ReviewCard(
                      comment: comment,
                      date: '12.12.2024',
                      customer: 'Person Name',
                      rating: '5.0'),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notification',
                style: GoogleFonts.suezOne(fontSize: 20),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const NotificationModal();
                      });
                },
                child: Text(
                  'Add new notification',
                  style: GoogleFonts.suezOne(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  TextButton(
                    onPressed: notificationLeft,
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_left_sharp,
                      color: Color.fromRGBO(14, 119, 62, 1),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 5.0),
                  TextButton(
                    onPressed: notificationRight,
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                      backgroundColor: Colors.grey[300],
                      padding: const EdgeInsets.all(8),
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Color.fromRGBO(14, 119, 62, 1),
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 5.0),
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: SizedBox(
            height: 250.0,
            width: 1590.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _notificationScrollController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: NotificationCard(
                      date: '12.12.2024',
                      description: comment,
                      hallName: 'Hall Name'),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  final ScrollController _reviewScrollController = ScrollController();
  final ScrollController _notificationScrollController = ScrollController();

  void reviewLeft() {
    _reviewScrollController.animateTo(
      _reviewScrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void reviewRight() {
    _reviewScrollController.animateTo(
      _reviewScrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void notificationLeft() {
    _notificationScrollController.animateTo(
      _notificationScrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void notificationRight() {
    _notificationScrollController.animateTo(
      _notificationScrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
