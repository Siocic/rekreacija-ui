import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/my_reservation_model.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/reservation_card.dart';

class MyReservationHistory extends StatefulWidget {
  const MyReservationHistory({super.key});
  @override
  State<StatefulWidget> createState() => _MyReservationHistoryState();
}

class _MyReservationHistoryState extends State<MyReservationHistory> {
  late AppointmentProvider appointmentProvider;
  List<MyReservationModel> reservationModel = [];
  static String? baseUrl =
      String.fromEnvironment("BASE_URL", defaultValue: "http://10.0.2.2:5246/");

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchReservation();
  }

  Future<void> fetchReservation() async {
    try {
      var reservation = await appointmentProvider.getMyReservationHistory();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("My reservations", style: GoogleFonts.ultra(fontSize: 22)),
        backgroundColor: const Color.fromARGB(225, 29, 29, 29),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          decoration: customDecoration,
          child: reservationModel.isEmpty
              ? const Center(
                  child: Text(
                    "No reservations found. Start exploring and book your first one!",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: reservationModel.length,
                  itemBuilder: (context, index) {
                    final myReservation = reservationModel[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ReservationCard(
                          objectName: myReservation.objectName!,
                          objectAddress: myReservation.objectAdress!,
                          objectImage: myReservation.objectImage != null
                              ? Image.network(
                                  '$baseUrl${myReservation.objectImage!}')
                              : Image.asset(
                                  "assets/images/RekreacijaDefault.jpg"),
                          appointmentDate: DateFormat('d/M/y')
                              .format(myReservation.appointmentDate!),
                          appointmentTime: DateFormat('Hm')
                              .format(myReservation.appointmentStartDate!),
                          status: myReservation.is_approved!,
                          appointmentEndTime: DateFormat('Hm')
                              .format(myReservation.appointmentEndDate!),
                          numberOfPlayers: myReservation.number_of_players!,
                          price: myReservation.price!),
                    );
                  },
                )),
    );
  }
}
