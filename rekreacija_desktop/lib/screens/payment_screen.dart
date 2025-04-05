import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/models/my_client_payments_model.dart';
import 'package:rekreacija_desktop/providers/appointment_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentScreen> {
  MyPaymentSource? paymentSource;
  late AppointmentProvider appointmentProvider;
  List<MyClientPaymentsModel> myPayments = [];

  @override
  void initState() {
    super.initState();
    appointmentProvider = context.read<AppointmentProvider>();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      var payment = await appointmentProvider.getMyClientPayments();
      setState(() {
        myPayments = payment;
        paymentSource = MyPaymentSource(myPayments);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
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
          child: ContentHeader(title: 'Payment'),
        ),
        const SizedBox(height: 20.0),
        if (myPayments.isEmpty)
          Center(
            child: Text(
              "You don't have any payments yet",
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
                      dataColumn("Object name"),
                      dataColumn("Ammount"),
                      dataColumn("Appointment date"),
                    ],
                    source: paymentSource!,
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

class MyPaymentSource extends DataTableSource {
  final List<MyClientPaymentsModel> myPaymentList;
  MyPaymentSource(this.myPaymentList);

  @override
  DataRow? getRow(int index) {
    if (index >= myPaymentList.length) return null;

    final myPayment = myPaymentList[index];
    return DataRow(cells: [
      DataCell(Text(myPayment.fullName!)),
      DataCell(Text(myPayment.email!)),
      DataCell(Text(myPayment.phone!)),
      DataCell(Text(myPayment.objectName!)),
      DataCell(Text(myPayment.amount.toString())),
      DataCell(Text(DateFormat('d/M/y').format(myPayment.appointmentDate!))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => myPaymentList.length;

  @override
  int get selectedRowCount => 0;
}
