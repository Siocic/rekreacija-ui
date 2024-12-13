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
        child: Container(
          width: 400.0,
          height: 250.0,
          child: Column(
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
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: GoogleFonts.suezOne(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Delete',
                      style: GoogleFonts.suezOne(
                          color: AppColors.textWhite,
                          fontWeight: FontWeight.w400,
                          fontSize: 18),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
