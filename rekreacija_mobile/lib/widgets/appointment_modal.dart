import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/appointment_insert_model.dart';
import 'package:rekreacija_mobile/models/appointment_model.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/providers/holiday_provider.dart';
import 'package:rekreacija_mobile/screens/paypal_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class AppointmentModal extends StatefulWidget {
  final String? price;
  final String userId;
  final int? object_id;

  const AppointmentModal({
    super.key,
    required this.price,
    required this.object_id,
    required this.userId,
  });

  @override
  State<AppointmentModal> createState() => _AppointmentModalState();
}

class _AppointmentModalState extends State<AppointmentModal> {
  late AppointmentProvider _appointmentProvider;
  late HolidayProvider _holidayProvider;
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  double totalPrice = 0.0;
  List<DateTime> holidayDates = [];
  List<AppointmentModel> allAppointments = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _appointmentProvider = context.read<AppointmentProvider>();
    _holidayProvider = context.read<HolidayProvider>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final holidays =
          await _holidayProvider.getHolidaysForObject(widget.object_id!);
      final appointments = await _appointmentProvider.getAppointments();

      setState(() {
        holidayDates = holidays.expand((h) {
          final diff = h.endDate.difference(h.startDate).inDays + 1;
          return List.generate(diff, (i) {
            final date = h.startDate.add(Duration(days: i));
            return DateTime(date.year, date.month, date.day);
          });
        }).toList();

        allAppointments = appointments;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  bool _isHoliday(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return holidayDates.contains(normalized);
  }

  List<AppointmentModel> _getAppointmentsForDay(DateTime day) {
    final target = DateTime(day.year, day.month, day.day);
    final matching = allAppointments.where((a) {
      if (a.appointment_date == null) {
        print("Appointment missing date: $a");
        return false;
      }

      final date = DateTime(
        a.appointment_date!.year,
        a.appointment_date!.month,
        a.appointment_date!.day,
      );

      final match = isSameDay(date, target);
      return match;
    }).toList();
    return matching;
  }

  void calculatePrice() {
    final startDate = formKey.currentState?.fields['StartDate']?.value;
    final endDate = formKey.currentState?.fields['EndDate']?.value;
    double pricePerHour = double.tryParse(widget.price ?? '0') ?? 0.0;

    if (startDate != null && endDate != null && endDate.isAfter(startDate)) {
      double totalHours = endDate.difference(startDate).inHours.toDouble();
      setState(() {
        totalPrice = totalHours * pricePerHour;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("🗓️ Selected day: $_selectedDay");
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  holidayTextStyle: const TextStyle(color: Colors.grey),
                  todayDecoration: BoxDecoration(
                    color: Colors.orange.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                holidayPredicate: _isHoliday,
              ),
              const SizedBox(height: 15),
              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    const Text(
                      'Create appointment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDateTimePicker(
                      name: 'StartDate',
                      decoration: const InputDecoration(
                        labelText: 'StartDate',
                        border: OutlineInputBorder(),
                      ),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                      onChanged: (DateTime? selectedTime) async {
                        if (selectedTime == null) return;

                        final day = DateTime(selectedTime.year,
                            selectedTime.month, selectedTime.day);
                        if (_isHoliday(day)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cannot select holiday date"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          formKey.currentState?.fields['StartDate']
                              ?.didChange(null);
                          formKey.currentState?.fields['EndDate']
                              ?.didChange(null);
                          return;
                        }

                        final reserved =
                            await _appointmentProvider.getReservedTimes(
                          widget.object_id!,
                          selectedTime,
                          selectedTime.add(const Duration(minutes: 1)),
                        );

                        if (reserved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Time already reserved"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          formKey.currentState?.fields['StartDate']
                              ?.didChange(null);
                          formKey.currentState?.fields['EndDate']
                              ?.didChange(null);
                          return;
                        }

                        final autoEnd =
                            selectedTime.add(const Duration(hours: 1));
                        formKey.currentState?.fields['EndDate']
                            ?.didChange(autoEnd);
                        calculatePrice();
                      },
                    ),
                    const SizedBox(height: 10),
                    FormBuilderDateTimePicker(
                      name: 'EndDate',
                      decoration: const InputDecoration(
                        labelText: 'EndDate',
                        border: OutlineInputBorder(),
                      ),
                      enabled: false,
                    ),
                    const SizedBox(height: 10),
                    Text("Price ${totalPrice.toStringAsFixed(2)} KM"),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (await isTokenExpired()) {
                              showTokenExpiredDialog(context);
                              return;
                            }

                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              final form = formKey.currentState!.fields;
                              final start = form['StartDate']?.value;
                              final end = form['EndDate']?.value;

                              if (start == null || end == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Both dates must be filled"),
                                  backgroundColor: Colors.red,
                                ));
                                return;
                              }

                              final reserved =
                                  await _appointmentProvider.getReservedTimes(
                                widget.object_id!,
                                start,
                                end,
                              );
                              if (reserved) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Slot already taken"),
                                  backgroundColor: Colors.red,
                                ));
                                return;
                              }

                              final insert = AppointmentInsertModel(
                                appointment_date: start,
                                start_time: start,
                                end_time: end,
                                is_approved: true,
                                object_id: widget.object_id!,
                                user_id: widget.userId,
                                amount: totalPrice,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PayPalScreen(
                                      appointmentInsertModel: insert),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Please fix the form errors"),
                              ));
                            }
                          },
                          child: const Text('Submit'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
