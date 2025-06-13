import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/object_holiday_model.dart';
import 'package:rekreacija_desktop/models/object_model.dart';
import 'package:rekreacija_desktop/providers/holiday_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/models/holiday_model.dart';

class AddHolidayModal extends StatefulWidget {
  const AddHolidayModal({super.key});

  @override
  State<AddHolidayModal> createState() => _AddHolidayModalState();
}

class _AddHolidayModalState extends State<AddHolidayModal> {
  final _formKey = GlobalKey<FormState>();
  String _holidayName = '';
  DateTime? _startDate;
  DateTime? _endDate;
  List<ObjectModel> _objects = [];
  List<int> _selectedObjectIds = [];

  late ObjectProvider _objectProvider;
  late HolidayProvider _holidayProvider;

  @override
  void initState() {
    super.initState();
    _objectProvider = context.read<ObjectProvider>();
    _holidayProvider = context.read<HolidayProvider>();
    _loadObjects();
  }

  Future<void> _loadObjects() async {
    try {
      final fetched = await _objectProvider.getObjectOfLoggedUser();
      setState(() => _objects = fetched);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load objects: $e")),
      );
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _startDate == null ||
        _endDate == null ||
        _selectedObjectIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill all fields and select objects.")),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      print("🚀 SUBMIT: Creating holiday $_holidayName from $_startDate to $_endDate");

      final holiday = await _holidayProvider.addHoliday(
        HolidayModel(
          name: _holidayName,
          startDate: _startDate!,
          endDate: _endDate!,
        ),
      );

      print("✅ HOLIDAY CREATED: ${holiday.toJson()}");

      for (final id in _selectedObjectIds) {
        print("🔁 Assigning holiday ID ${holiday.id} to object ID $id");
        await _holidayProvider.assignObjectHoliday(
          ObjectHolidayModel(objectId: id, holidayId: holiday.id!),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Holiday successfully added!")),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      print("❌ ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add holiday: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Holiday', style: GoogleFonts.suezOne(fontSize: 22)),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Holiday name"),
                  onSaved: (value) => _holidayName = value ?? '',
                  validator: (value) =>
                      (value == null || value.isEmpty) ? "Name required" : null,
                ),
                const SizedBox(height: 10),
                _buildDatePicker("Start Date", _startDate, (date) {
                  setState(() => _startDate = date);
                }),
                _buildDatePicker("End Date", _endDate, (date) {
                  setState(() => _endDate = date);
                }),
                const SizedBox(height: 20),
                Text("Select Objects:", style: GoogleFonts.suezOne(fontSize: 16)),
                ..._objects.map((o) => CheckboxListTile(
                      value: _selectedObjectIds.contains(o.id),
                      title: Text(o.name ?? 'Unnamed'),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedObjectIds.add(o.id!);
                          } else {
                            _selectedObjectIds.remove(o.id);
                          }
                        });
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text("Add Holiday"),
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? date, Function(DateTime) onPick) {
    return Row(
      children: [
        Text("$label: ", style: GoogleFonts.suezOne()),
        TextButton(
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              onPick(picked);
            }
          },
          child: Text(
            date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Select',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
