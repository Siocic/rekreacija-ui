import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rekreacija_mobile/models/appointment_insert_model.dart';
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
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  double totalPrice = 0.0;

  void calculatePrice() {
    final startDate = formKey.currentState?.fields['StartDate']?.value;
    final endDate = formKey.currentState?.fields['EndDate']?.value;
    double pricePerHour = double.tryParse(widget.price.toString()) ?? 0.0;

    if (startDate != null && endDate != null) {
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
                    decoration: const InputDecoration(
                      labelText: 'StartDate',
                      border: OutlineInputBorder(),
                    ),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    //inputType: InputType.time,
                    // validator: FormBuilderValidators.required(
                    //     errorText: "This field is required"),
                    onChanged: (value) {
                      formKey.currentState?.fields['EndDate']?.validate();
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
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    // validator: FormBuilderValidators.compose([
                    //   FormBuilderValidators.required(
                    //       errorText: "This field is required"),
                    // ]),
                    // validator: (value) {
                    //   final startDate =
                    //       formKey.currentState?.fields['StartDate']?.value;
                    //   if (startDate != null &&
                    //       value != null &&
                    //       value.isBefore(startDate)) {
                    //     return 'End Date must be after Start Date';
                    //   }
                    //   return null;
                    // },
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
                                final startDate =
                                    formData['StartDate']?.value ?? '';
                                final endDate =
                                    formData['EndDate']?.value ?? '';

                                if (startDate == null || endDate == null) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text(
                                  //         'You must set both Start and End Dates.'),
                                  //     backgroundColor: Colors.red,
                                  //   ),
                                  // );
                                  formData['StartDate']
                                      ?.invalidate('Start Date is required');
                                  formData['EndDate']
                                      ?.invalidate('End Date is required');

                                  return;
                                }
                                if (startDate != null &&
                                    endDate != null &&
                                    endDate.isBefore(startDate)) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text(
                                  //         'End Date must be after Start Date'),
                                  //     backgroundColor: Colors.red,
                                  //   ),
                                  // );
                                  formData['EndDate']?.invalidate(
                                      'End Date must be after Start Date');
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
