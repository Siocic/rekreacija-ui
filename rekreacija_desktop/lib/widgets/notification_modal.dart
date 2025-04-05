import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/notification_insert.dart';
import 'package:rekreacija_desktop/providers/notification_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

class NotificationModal extends StatefulWidget {
  NotificationModal({super.key});
  final TextEditingController subject = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  State<StatefulWidget> createState() => _NotificationModalState();
}

class _NotificationModalState extends State<NotificationModal> {
  late NotificationProvider _notificationProvider;
  String userId = '';

  @override
  void initState() {
    super.initState();
    _notificationProvider = context.read<NotificationProvider>();
    getIdUser();
  }

  Future<void> getIdUser() async {
    final iduser = await getUserId();
    setState(() {
      userId = iduser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'New notice',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: "Subject",
                      maxLength: 50,
                      controller: widget.subject,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText:
                                "The subject of notification is required"),
                        FormBuilderValidators.minLength(2,
                            errorText: "Minimum 2 charcters"),
                        FormBuilderValidators.maxLength(50,
                            errorText: "Maximum 50 charcters"),
                      ]),
                    ),
                    const SizedBox(height: 10),
                    FormBuilderTextField(
                      name: "Description",
                      maxLength: 100,
                      controller: widget.description,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        border: OutlineInputBorder(),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText:
                                "The description of notification is required"),
                        FormBuilderValidators.minLength(2,
                            errorText: "Minimum 2 charcters"),
                        FormBuilderValidators.maxLength(100,
                            errorText: "Maximum 100 charcters"),
                      ]),
                    ),
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
                                  final subject =
                                      formData['Subject']?.value ?? '';
                                  final description =
                                      formData['Description']?.value ?? '';
                                  DateTime now = DateTime.now();

                                  NotificationInsert notificationInsert =
                                      NotificationInsert(
                                          subject, description, now, userId);

                                  await _notificationProvider.Insert(
                                      notificationInsert);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'You added a new notification successfully.'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  Navigator.pop(context, true);
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
                            child: Text('Submit')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Close')),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
