import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rekreacija_desktop/models/appointment_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late AppointmentProvider _appointmentProvider;
  List<AppointmentModel> _allAppointments = [];
  Map<DateTime, List<AppointmentModel>> _groupedAppointments = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _appointmentProvider = context.read<AppointmentProvider>();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    try {
      final appointments = await _appointmentProvider.getAppointments();
      setState(() {
        _allAppointments = appointments;
        _groupAppointmentsByDate();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load appointments: $e')),
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
      if (_groupedAppointments[date] == null) {
        _groupedAppointments[date] = [];
      }
      _groupedAppointments[date]!.add(appointment);
    }
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    return _groupedAppointments[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          'Appointments Calendar',
          style: GoogleFonts.suezOne(fontSize: 24),
        ),
        const SizedBox(height: 20),
        TableCalendar<AppointmentModel>(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          calendarStyle: const CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
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
                          '${DateFormat.Hm().format(a.start_time!)} - ${DateFormat.Hm().format(a.end_time!)}',
                        ),
                        trailing: a.is_approved == true
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.hourglass_empty, color: Colors.orange),
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}
