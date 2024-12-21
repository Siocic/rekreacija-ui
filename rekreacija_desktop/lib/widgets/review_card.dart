import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';

class ReviewCard extends StatefulWidget {
  final String customer;
  final String date;
  final String comment;
  final String rating;
  const ReviewCard(
      {super.key,
      required this.comment,
      required this.date,
      required this.customer,
      required this.rating});

  @override
  State<StatefulWidget> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cardColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0),
        child: SizedBox(
          width: 400.0,
          height: 300.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.customer,
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
                    color: AppColors.dateCardColor ),
              ),
              const SizedBox(height: 15.0),
              Text(
                widget.comment,
                style: GoogleFonts.barlow(
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textCardColor),
              ),
              const SizedBox(height: 15.0),
              Row(
                children: [
                  const Icon(Icons.star, color: AppColors.iconYellow),
                  const SizedBox(width: 15.0),
                  Text(
                    widget.rating,
                    style: GoogleFonts.barlow(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textCardColor),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Reply',
                  style: GoogleFonts.suezOne(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
