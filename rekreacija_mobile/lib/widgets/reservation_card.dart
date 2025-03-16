import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservationCard extends StatefulWidget {
  final String objectName;
  final String objectAddress;
  final Image objectImage;
  final String appointmentDate;
  final String appointmentTime;

  ReservationCard({
    super.key,
    required this.objectName,
    required this.objectAddress,
    required this.objectImage,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  State<StatefulWidget> createState() => _ReservationCardState();
}

class _ReservationCardState extends State<ReservationCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromRGBO(49, 49, 49, 0.8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SizedBox(
        width: 400.0,
        child: Stack(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0.0),
                  child: Container(
                      width: 100.0,
                      height: 120.0,
                      color: Colors.grey[300],
                      child: Image(
                          image: widget.objectImage.image, fit: BoxFit.cover)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.objectName,
                        style: GoogleFonts.suezOne(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.objectAddress,
                        style: GoogleFonts.suezOne(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.appointmentDate,
                        style: GoogleFonts.suezOne(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        widget.appointmentTime,
                        style: GoogleFonts.suezOne(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.near_me_sharp,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
