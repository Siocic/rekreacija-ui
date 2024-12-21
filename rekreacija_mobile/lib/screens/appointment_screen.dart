import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/widgets/custom_appbar.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<StatefulWidget> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Reservation'),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: customDecoration,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                SfDateRangePicker(
                  selectionMode: DateRangePickerSelectionMode.single,
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                    setState(() {
                      selectedDate = args.value;
                    });
                    print('object');
                  },
                  initialSelectedDate: DateTime.now(),
                  backgroundColor: Colors.white.withOpacity(0.1),
                  headerStyle: DateRangePickerHeaderStyle(
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 20),
                    backgroundColor: Colors.white.withOpacity(0.1),
                  ),
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    todayTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  selectionColor: Colors.blue,
                  todayHighlightColor: Colors.blue,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Text(
                      'Choose time: ',
                      style: GoogleFonts.suezOne(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: () => _setTime(context, true),
                      child: Text(
                        startTime != null
                            ? formatTime24Hours(startTime!)
                            : 'start',
                        style: GoogleFonts.suezOne(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      onPressed: startTime != null
                          ? () => _setTime(context, false)
                          : null,
                      child: Text(
                        endTime != null ? formatTime24Hours(endTime!) : 'end',
                        style: GoogleFonts.suezOne(
                            fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      print('object');
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(16.0)),
                    ),
                    child: const Text(
                      'Payment',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  DateTime? selectedDate;

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
        final adjustedTime = TimeOfDay(hour: pickedTime.hour, minute: 0);

        if (isStartTime) {
          startTime = adjustedTime;
          if (endTime != null &&
              (endTime!.hour < startTime!.hour ||
                  (endTime!.hour == startTime!.hour &&
                      endTime!.minute == startTime!.minute))) {
            endTime = null;
          }
        } else {
          if (startTime == null ||
              adjustedTime.hour > startTime!.hour ||
              (adjustedTime.hour == startTime!.hour &&
                  adjustedTime.minute == startTime!.minute)) {
            endTime = adjustedTime;
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
}
