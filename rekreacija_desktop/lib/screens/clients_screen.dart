import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/my_clients_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ClientsScrenns();
}

class _ClientsScrenns extends State<ClientsScreen> {
  MyClientsSource? clientsSource;

  late AppointmentProvider appointmentProvider;
  List<MyClientsModel> clients = [];

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      var client = await appointmentProvider.getMyClients();
      setState(() {
        clients = client;
        clientsSource = MyClientsSource(clients);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Clients'),
        ),
        const SizedBox(height: 20.0),
        if (clients.isEmpty)
          Center(
            child: Text(
              "You don't have any client yet",
              style: GoogleFonts.suezOne(
                  fontSize: 20, fontWeight: FontWeight.w400),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  width: 1200.0,
                  child: PaginatedDataTable(
                    columns: [
                      dataColumn("FullName"),
                      dataColumn("Email"),
                      dataColumn("Phone number"),
                      dataColumn("Number of Appointments"),
                      dataColumn("Last Appointment"),
                    ],
                    source: clientsSource!,
                    rowsPerPage: 5,
                    showEmptyRows: false,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

DataColumn dataColumn(String columName) {
  return DataColumn(label: Center(child: Text(columName)));
}

class MyClientsSource extends DataTableSource {
  final List<MyClientsModel> myClientsList;
  MyClientsSource(this.myClientsList);

  @override
  DataRow? getRow(int index) {
    if (index >= myClientsList.length) return null;

    final myClient = myClientsList[index];
    return DataRow(cells: [
      DataCell(Text(myClient.fullName!)),
      DataCell(Text(myClient.email!)),
      DataCell(Text(myClient.phoneNumber!)),
      DataCell(Text(myClient.numberOfAppointments.toString())),
      DataCell(Text(DateFormat('d/M/y').format(myClient.lastAppointmentDate!))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => myClientsList.length;

  @override
  int get selectedRowCount => 0;
}
