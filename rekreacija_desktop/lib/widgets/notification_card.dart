import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';

class NotificationCard extends StatefulWidget {
  final String hallName;
  final String date;
  final String description;

  const NotificationCard(
      {super.key,
      required this.date,
      required this.description,
      required this.hallName});

  @override
  State<StatefulWidget> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SizedBox(
          width: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.hallName,
                style: GoogleFonts.barlow(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textCardColor),
              ),
              Text(
                widget.date,
                style: GoogleFonts.barlow(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: AppColors.dateCardColor),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.description,
                style: GoogleFonts.barlow(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textCardColor),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }
}
