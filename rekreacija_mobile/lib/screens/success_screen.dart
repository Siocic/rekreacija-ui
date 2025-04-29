import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/appointment_insert_model.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/screens/tabs_screen.dart';

class SuccessPage extends StatefulWidget {
  final AppointmentInsertModel appointmentInsertModel;

  const SuccessPage({super.key, required this.appointmentInsertModel});

  @override
  State<StatefulWidget> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late AppointmentProvider _appointmentProvider;

  @override
  void initState() {
    super.initState();
    _appointmentProvider = context.read<AppointmentProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            Text(
              "Your payment is success",
              style: GoogleFonts.suezOne(
                  fontSize: 24, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _appointmentProvider.Insert(
                    widget.appointmentInsertModel);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const TabsScreen(),
                  ),
                );
              },
              child: const Text("Go To Home"),
            )
          ],
        ),
      ),
    );
  }
}
