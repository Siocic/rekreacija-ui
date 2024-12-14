import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/appointment_card.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<StatefulWidget> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
            title: 'Appointment',
            onLogout: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Row(
            children: [
              Text(
                'Work time: ',
                style: GoogleFonts.suezOne(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 10.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed: () => _setTime(context, true),
                child: Text(
                  startTime != null ? formatTime24Hours(startTime!) : 'start',
                  style:
                      GoogleFonts.suezOne(fontSize: 20.0, color: Colors.black),
                ),
              ),
              const SizedBox(width: 5.0),
              Text('-',
                  style:
                      GoogleFonts.suezOne(fontSize: 20.0, color: Colors.black)),
              const SizedBox(width: 5.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
                onPressed:
                    startTime != null ? () => _setTime(context, false) : null,
                child: Text(
                  endTime != null ? formatTime24Hours(endTime!) : 'end',
                  style:
                      GoogleFonts.suezOne(fontSize: 20.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New appointment requests',
                style: GoogleFonts.suezOne(fontSize: 18),
              ),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  TextButton(
                    onPressed: scrollLeft,
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
                    onPressed: scrollRight,
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
            height: 160.0,
            width: 1590.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: AppointmentCard(
                    customer: 'Person Name',
                    date: '12.12.2024',
                    time: '15:00',
                    approveAppointment: approveAppointment,
                    declineAppointment: declineAppointment,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _setTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime
          ? (startTime ?? TimeOfDay.now())
          : (endTime ?? TimeOfDay.now()),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            materialTapTargetSize: MaterialTapTargetSize.padded,
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
          if (endTime != null &&
              (endTime!.hour < startTime!.hour ||
                  (endTime!.hour == startTime!.hour &&
                      endTime!.minute == startTime!.minute))) {
            endTime = null;
          }
        } else {
          if (startTime == null ||
              pickedTime.hour > startTime!.hour ||
              (pickedTime.hour == startTime!.hour &&
                  pickedTime.minute == startTime!.minute)) {
            endTime = pickedTime;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'End time must be later than start time',
                style: GoogleFonts.suezOne(),
              ),
              backgroundColor: Colors.red,
            ));
          }
        }
      });
    }
  }

  String formatTime24Hours(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hour:$minutes';
  }

  void approveAppointment() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'You approved appointment for .....',
        style: GoogleFonts.suezOne(),
      ),
      backgroundColor: AppColors.buttonGreen,
      duration: Durations.extralong4,
    ));
  }

  void declineAppointment() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'You declined appointment for .....',
        style: GoogleFonts.suezOne(),
      ),
      backgroundColor: AppColors.buttonRed,
      duration: Durations.extralong4,
    ));
  }

  final ScrollController _scrollController = ScrollController();

  void scrollLeft() {
    _scrollController.animateTo(
      _scrollController.offset - 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollRight() {
    _scrollController.animateTo(
      _scrollController.offset + 200,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
