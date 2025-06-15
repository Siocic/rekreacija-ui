import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/my_reservation_model.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/reservation_card.dart';

class RezervacijeScreen extends StatefulWidget {
  const RezervacijeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RezervacijaScreen();
}

class _RezervacijaScreen extends State<RezervacijeScreen> {
  late AppointmentProvider appointmentProvider;
  List<MyReservationModel> reservationModel = [];
    static String? baseUrl = String.fromEnvironment("BASE_URL",defaultValue:"http://10.0.2.2:5246/");

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchReservation();
  }

  Future<void> fetchReservation() async {
    try {
      var reservation = await appointmentProvider.getMyReservation();
      setState(() {
        reservationModel = reservation;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: customDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Reservations',
                  style: GoogleFonts.suezOne(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20),
                ),
              ),
            ],
          ),
          if(reservationModel.isEmpty)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  SizedBox(height: 10),
                  Text(
                    "No reservations found.",
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemCount: reservationModel.length,
                itemBuilder: (context, index) {
                  final reservation = reservationModel[index];
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ReservationCard(
                        objectName: reservation.objectName!,
                        objectAddress: reservation.objectAdress!,
                        objectImage: reservation.objectImage != null
                            ? Image.network('$baseUrl${reservation.objectImage!}')
                            : Image.asset("assets/images/RekreacijaDefault.jpg"),
                        appointmentDate: DateFormat('d/M/y')
                            .format(reservation.appointmentDate!),
                        appointmentTime: DateFormat('Hm')
                            .format(reservation.appointmentDate!)),
                  );
                },
              ),
            )
        ],
      ),
    );
  }
}
