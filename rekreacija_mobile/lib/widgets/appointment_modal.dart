import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/appointment_insert_model.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/screens/paypal_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';

class AppointmentModal extends StatefulWidget {
  final String? price;
  final String userId;
  final int? object_id;
  AppointmentModal(
      {super.key,
      required this.price,
      required this.object_id,
      required this.userId});
  final TextEditingController comment = TextEditingController();

  @override
  State<StatefulWidget> createState() => _AppointmentModalState();
}

class _AppointmentModalState extends State<AppointmentModal> {
  late AppointmentProvider _appointmentProvider;

  @override
  void initState() {
    _appointmentProvider = context.read<AppointmentProvider>();
    super.initState();
  }

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  double totalPrice = 0.0;

  void calculatePrice() {
    final startDate = formKey.currentState?.fields['StartDate']?.value;
    final endDate = formKey.currentState?.fields['EndDate']?.value;
    double pricePerHour = double.tryParse(widget.price.toString()) ?? 0.0;

    if (startDate != null && endDate != null && endDate.isAfter(startDate)) {
      double totalHours = endDate.difference(startDate).inHours.toDouble();
      setState(() {
        totalPrice = totalHours * pricePerHour;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  const Text(
                    'Create appointment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: 'StartDate',
                    valueTransformer: (val) => val,
                    decoration: const InputDecoration(
                      labelText: 'StartDate',
                      border: OutlineInputBorder(),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    onChanged: (DateTime? selectedTime) async {
                      if (selectedTime != null) {
                        var reservedTime =
                            await _appointmentProvider.getReservedTimes(
                                widget.object_id!,
                                selectedTime,
                                selectedTime.add(Duration(minutes: 1)));
                                 final autoEndTime = selectedTime.add(Duration(hours: 1));
                                             formKey.currentState?.fields['EndDate']?.didChange(autoEndTime);

                        if (reservedTime == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('This time is already reserved'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          formKey.currentState?.fields['StartDate']
                              ?.didChange(null);
                                            formKey.currentState?.fields['EndDate']?.didChange(null);

                        } else {
                          formKey.currentState?.fields['EndDate']?.validate();
                          calculatePrice();
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  FormBuilderDateTimePicker(
                    name: 'EndDate',
                    valueTransformer: (val) => val,
                    enabled: true,
                    decoration: const InputDecoration(
                      labelText: 'EndDate',
                      border: OutlineInputBorder(),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    onChanged: (value) {
                      calculatePrice();
                    },
                  ),
                  const SizedBox(height: 10),
                  Text("Price ${totalPrice.toStringAsFixed(2)} KM/h"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            bool isExpired = await isTokenExpired();
                            if (isExpired) {
                              showTokenExpiredDialog(context);
                              return;
                            }

                            if (formKey.currentState?.saveAndValidate() ??
                                false) {
                              try {
                                final formData = formKey.currentState!.fields;
                                final startDate = formData['StartDate']?.value;
                                final endDate = formData['EndDate']?.value;

                                if (startDate == null || endDate == null) {
                                  formData['StartDate']
                                      ?.invalidate('Start Date is required');
                                  formData['EndDate']
                                      ?.invalidate('End Date is required');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'You must select both start and end time.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }
                                if (startDate != null &&
                                    endDate != null &&
                                    endDate.isBefore(startDate)) {
                                  formData['EndDate']?.invalidate(
                                      'End Date must be after Start Date');
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'End Date must be after Start Date.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                bool overlap =
                                    await _appointmentProvider.getReservedTimes(
                                        widget.object_id!, startDate, endDate);
                                if (overlap) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Selected time range overlaps with an existing reservation.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                AppointmentInsertModel appointmentInsert =
                                    AppointmentInsertModel(
                                        startDate,
                                        startDate,
                                        endDate,
                                        widget.object_id,
                                        widget.userId,
                                        totalPrice);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => PayPalScreen(
                                            appointmentInsertModel:
                                                appointmentInsert)));
                              } catch (e) {
                                String errorMessage = e.toString();

                                if (errorMessage.startsWith("Exception:")) {
                                  errorMessage = errorMessage
                                      .replaceFirst("Exception:", "")
                                      .trim();
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorMessage)),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          "Please fix the errors in form.")));
                            }
                          },
                          child: const Text('Submit')),
                      const SizedBox(width: 10),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'))
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
