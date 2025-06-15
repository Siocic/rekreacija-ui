import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/appointment_model.dart';
import 'package:rekreacija_desktop/models/holiday_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/providers/holiday_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/add_holiday_modal.dart';
import 'package:rekreacija_desktop/widgets/appointment_card.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<StatefulWidget> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  late AppointmentProvider _appointmentProvider;
  late HolidayProvider _holidayProvider;
  List<AppointmentModel> appointmentModel = [];
  List<AppointmentModel> _approveAppointments = [];
  List<HolidayModel> _holidays = [];
  Map<DateTime, List<AppointmentModel>> _groupedAppointments = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _appointmentProvider = context.read<AppointmentProvider>();
    _holidayProvider = context.read<HolidayProvider>();
    fetchAppointments();
    _loadAppointmentsAndHolidays();
  }

  Future<void> fetchAppointments() async {
    try {
      final appointment = await _appointmentProvider.getAppointments();
      setState(() {
        appointmentModel = appointment;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  Future<void> _loadAppointmentsAndHolidays() async {
    try {
      final objectProvider = context.read<ObjectProvider>();
      final objects = await objectProvider.getObjectOfLoggedUser();

      if (objects.isEmpty) {
        throw Exception("No objects found for user.");
      }

      final objectId = objects.first.id!;
      final appointments = await _appointmentProvider.getApprovedAppointments();
      final holidays = await _holidayProvider.getObjectHolidays(objectId);

      setState(() {
        _approveAppointments = appointments;
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
    for (var appointment in _approveAppointments) {
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

  List<HolidayModel> _getHolidaysForDay(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _holidays.where((h) {
      final start =
          DateTime(h.startDate.year, h.startDate.month, h.startDate.day);
      final end = DateTime(h.endDate.year, h.endDate.month, h.endDate.day);
      return !date.isBefore(start) && !date.isAfter(end);
    }).toList();
  }

  bool _isHoliday(DateTime day) {
    final date = DateTime(day.year, day.month, day.day);
    return _holidays.any((h) {
      final start =
          DateTime(h.startDate.year, h.startDate.month, h.startDate.day);
      final end = DateTime(h.endDate.year, h.endDate.month, h.endDate.day);
      return !date.isBefore(start) && !date.isAfter(end);
    });
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
          child: ContentHeader(title: 'Appointment'),
        ),
        const SizedBox(height: 10.0),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                appointmentModel.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: Text(
                          "You currently have no reservation requests.",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Text(
                              'New appointment requests',
                              style: GoogleFonts.suezOne(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 30.0),
                            child: Row(
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
                          ),
                          const SizedBox(height: 5.0),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: SizedBox(
                              height: 180.0,
                              width: 1590.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                itemCount: appointmentModel.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointmentModel[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: AppointmentCard(
                                      customer: appointment.fullname ?? '',
                                      objectName: appointment.object_name ?? '',
                                      date: DateFormat('d.M.y').format(
                                          appointment.appointment_date!),
                                      startTime: DateFormat('Hm')
                                          .format(appointment.start_time!),
                                      endTime: DateFormat('Hm')
                                          .format(appointment.end_time!),
                                      approveAppointment: () async {
                                        bool isExpired = await isTokenExpired();
                                        if (isExpired) {
                                          showTokenExpiredDialog(context);
                                          return;
                                        }
                                        try {
                                          await _appointmentProvider
                                              .approveAppointment(
                                                  appointment.id!);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "You successfully approved the appointment for object: ${appointment.object_name} and user: ${appointment.fullname}."),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          fetchAppointments();
                                          _loadAppointmentsAndHolidays();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Failed to approve appointment: $e')));
                                        }
                                      },
                                      declineAppointment: () async {
                                        bool isExpired = await isTokenExpired();
                                        if (isExpired) {
                                          showTokenExpiredDialog(context);
                                          return;
                                        }
                                        try {
                                          await _appointmentProvider.Delete(
                                              appointment.id!);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  "You declined the appointment for object: ${appointment.object_name} and user: ${appointment.fullname}"),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                          fetchAppointments();
                                          _loadAppointmentsAndHolidays();
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Failed to decline appointment: $e')));
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Appointmets & Holidays Calendar",
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 15),
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
                      ),
                      const SizedBox(height: 15),
                      TableCalendar<AppointmentModel>(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),
                        focusedDay: _focusedDay,
                        selectedDayPredicate: (day) =>
                            isSameDay(_selectedDay, day),
                        eventLoader: _getAppointmentsForDay,
                        holidayPredicate: _isHoliday,
                        availableCalendarFormats: const {
                          CalendarFormat.month: 'Month'
                        },
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
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            final normalizedDay =
                                DateTime(day.year, day.month, day.day);
                            final isHoliday = _isHoliday(normalizedDay);
                            if (isHoliday) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.red.shade300,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${day.day}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }
                            return null;
                          },
                        ),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_selectedDay != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              // Appointments
                              ..._getAppointmentsForDay(_selectedDay!).map((a) {
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
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
                              }),
                              // Holidays
                              ..._getHolidaysForDay(_selectedDay!).map((h) {
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  color: Colors.red.shade50,
                                  child: ListTile(
                                    title: Text(
                                      "Holiday: ${h.name}",
                                      style: GoogleFonts.suezOne(
                                          color: Colors.red.shade800),
                                    ),
                                    subtitle: Text(
                                      '${DateFormat.yMMMd().format(h.startDate)}'
                                      '${h.startDate != h.endDate ? " to ${DateFormat.yMMMd().format(h.endDate)}" : ""}',
                                    ),
                                    leading: const Icon(Icons.beach_access,
                                        color: Colors.red),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatTime24Hours(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hour:$minutes';
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
