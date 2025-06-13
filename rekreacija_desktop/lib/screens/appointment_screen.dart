import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/providers/holiday_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:rekreacija_desktop/models/appointment_model.dart';
import 'package:rekreacija_desktop/models/holiday_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/widgets/add_holiday_modal.dart'; // Create this dialog

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late AppointmentProvider _appointmentProvider;
  late HolidayProvider _holidayProvider;
  List<AppointmentModel> _allAppointments = [];
  List<HolidayModel> _holidays = [];

  Map<DateTime, List<AppointmentModel>> _groupedAppointments = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
  @override
  void initState() {
    super.initState();
    _appointmentProvider = context.read<AppointmentProvider>();
    _holidayProvider = context.read<HolidayProvider>();
    _loadAppointmentsAndHolidays();
  }

Future<void> _loadAppointmentsAndHolidays() async {
  try {
    final objectProvider = context.read<ObjectProvider>();
    final objects = await objectProvider.getObjectOfLoggedUser();

    if (objects.isEmpty) {
      throw Exception("No objects found for user.");
    }

    final objectId = objects.first.id!;
    final appointments = await _appointmentProvider.getAppointments();
    final holidays = await _holidayProvider.getObjectHolidays(objectId);

    setState(() {
      _allAppointments = appointments;
      _holidays = holidays;
      _groupAppointmentsByDate();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to load data: $e')),
    );
  }
}


  void _groupAppointmentsByDate() {
    _groupedAppointments.clear();
    for (var appointment in _allAppointments) {
      final date = DateTime(
        appointment.appointment_date!.year,
        appointment.appointment_date!.month,
        appointment.appointment_date!.day,
      );
      _groupedAppointments.putIfAbsent(date, () => []).add(appointment);
    }
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    return _groupedAppointments[DateTime(day.year, day.month, day.day)] ?? [];
  }

  bool _isHoliday(DateTime day) {
    return _holidays
        .any((h) => !day.isBefore(h.startDate!) && !day.isAfter(h.endDate!));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Appointments & Holidays Calendar',
              style: GoogleFonts.suezOne(fontSize: 24),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async {
                final bool? added = await showDialog(
                  context: context,
                  builder: (_) => const AddHolidayModal(),
                );
                if (added == true) {
                  _loadAppointmentsAndHolidays();
                }
              },
              child: const Text("Add Holiday"),
            )
          ],
        ),
        const SizedBox(height: 20),
        TableCalendar<AppointmentModel>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange.shade300,
              shape: BoxShape.circle,
            ),
            selectedDecoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            holidayDecoration: BoxDecoration(
              color: Colors.red.shade300,
              shape: BoxShape.circle,
            ),
          ),
          holidayPredicate: _isHoliday,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          eventLoader: _getAppointmentsForDay,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: _selectedDay == null
              ? const Center(child: Text("Select a day to see appointments"))
              : ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  children: _getAppointmentsForDay(_selectedDay!).map((a) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          a.object_name ?? 'Unknown Object',
                          style: GoogleFonts.suezOne(),
                        ),
                        subtitle: Text(
                          'By ${a.fullname ?? 'Unknown'}\n'
                          '${DateFormat.Hm().format(a.start_time!)} - '
                          '${DateFormat.Hm().format(a.end_time!)}',
                        ),
                        trailing: Icon(
                          a.is_approved == true
                              ? Icons.check_circle
                              : Icons.hourglass_empty,
                          color: a.is_approved == true
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
