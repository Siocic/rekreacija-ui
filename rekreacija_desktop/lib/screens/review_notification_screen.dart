import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/colors.dart';
import 'package:rekreacija_desktop/models/notification_model.dart';
import 'package:rekreacija_desktop/models/review_model.dart';
import 'package:rekreacija_desktop/providers/notification_provider.dart';
import 'package:rekreacija_desktop/providers/review_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';
import 'package:rekreacija_desktop/widgets/notification_card.dart';
import 'package:rekreacija_desktop/widgets/notification_modal.dart';
import 'package:rekreacija_desktop/widgets/review_card.dart';

class ReviewNotificationScreen extends StatefulWidget {
  const ReviewNotificationScreen({super.key});
  @override
  State<StatefulWidget> createState() => _ReviewNotificationState();
}

class _ReviewNotificationState extends State<ReviewNotificationScreen> {
  late NotificationProvider _notificationProvider;
  late ReviewProvider _reviewProvider;
  List<NotificationModel>? notifications;
  List<ReviewModel>? reviws;
  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    _reviewProvider = context.read<ReviewProvider>();
    fetch();
  }

  Future<void> fetch() async {
    try {
      final userNotification =
          await _notificationProvider.getNotificationsOfUser();
      final objectReviews = await _reviewProvider.getReviewsForMyObjects();
      setState(() {
        notifications = userNotification;
        reviws = objectReviews;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Review & Notification'),
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
                onPressed: () async {
                  final bool? result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return NotificationModal();
                      });
                  if (result == true) {
                    fetch();
                  }
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
              (notifications == null || notifications!.isEmpty)
                  ? const Text("")
                  : Row(
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
            height: 230.0,
            width: double.infinity,
            child: (notifications == null || notifications!.isEmpty)
                ? Center(
                    child: Text(
                      "You haven't created any notifications yet.",
                      style: GoogleFonts.suezOne(
                          fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _notificationScrollController,
                    itemCount: notifications!.length,
                    itemBuilder: (context, index) {
                      final ourNotification = notifications![index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: NotificationCard(
                            date: DateFormat('d/M/y')
                                .format(ourNotification.created_date!),
                            description: ourNotification.description ?? '',
                            hallName: ourNotification.name ?? ''),
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
                'Review',
                style: GoogleFonts.suezOne(fontSize: 20),
              ),
              const SizedBox(height: 10.0),
              (reviws == null || reviws!.isEmpty)
                  ? const Text('')
                  : Row(
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
            height: 200.0,
            width: 1590.0,
            child: (reviws == null || reviws!.isEmpty)
                ? Center(
                    child: Text(
                      "You don't have any reviews yet.",
                      style: GoogleFonts.suezOne(
                          fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _reviewScrollController,
                    itemCount: reviws!.length,
                    itemBuilder: (context, index) {
                      final objReview = reviws![index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: ReviewCard(
                            comment: objReview.comment!,
                            date: DateFormat('d/M/y')
                                .format(objReview.created_date!),
                            customer:
                                '${objReview.user!.firstName!} ${objReview.user!.lastName!}',
                            rating: objReview.rating.toString()),
                      );
                    },
                  ),
          ),
        ),
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
