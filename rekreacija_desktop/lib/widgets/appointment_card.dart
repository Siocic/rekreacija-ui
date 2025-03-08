import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';

class AppointmentCard extends StatefulWidget {
  final String date;
  final String startTime;
  final String endTime;
  final String customer;
  final String objectName;
  final VoidCallback approveAppointment;
  final VoidCallback declineAppointment;

  const AppointmentCard(
      {super.key,
      required this.customer,
      required this.objectName,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.approveAppointment,
      required this.declineAppointment});

  @override
  State<StatefulWidget> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: 300.0,
          height: 130.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.date,
                style: GoogleFonts.barlow(
                    color: AppColors.textCardColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.startTime} - ${widget.endTime}',
                style: GoogleFonts.barlow(
                    color: AppColors.textCardColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Object: ${widget.objectName}',
                style: GoogleFonts.barlow(
                    color: AppColors.textCardColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'Customer: ${widget.customer}',
                    style: GoogleFonts.barlow(
                        color: AppColors.textCardColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(
                      Icons.check_circle,
                      color: AppColors.iconGreen,
                    ),
                    onPressed: widget.approveAppointment,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: AppColors.iconRed,
                    ),
                    onPressed: widget.declineAppointment,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
