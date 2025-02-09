import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/models/user_model.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class PendingApprovals extends StatefulWidget {
  const PendingApprovals({super.key});
  @override
  State<StatefulWidget> createState() => _PendingApprovalsState();
}

class _PendingApprovalsState extends State<PendingApprovals> {
  NotApprovedUserSource? notApprovedUser;

  final AuthProvider authProvider = AuthProvider();
  List<UserModel> notApproveList = [];

  @override
  void initState() {
    super.initState();
    getUserThatNotApproved();
  }

  Future<void> getUserThatNotApproved() async {
    try {
      var notApproved = await authProvider.getUserThatNotApprovedYet();
      setState(() {
        notApproveList = notApproved;
        notApprovedUser = NotApprovedUserSource(notApproveList, context, refreshList);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }
    void refreshList() {
    getUserThatNotApproved();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Pending approvals'),
        ),
        const SizedBox(height: 20.0),
        if (notApproveList.isEmpty)
          Center(
            child: Text(
              "No new registrations at the moment",
              style: GoogleFonts.suezOne(
                  fontSize: 20, fontWeight: FontWeight.w400),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(0),
                child: Text(
                  "Pravno lice users",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: SizedBox(
                  width: 1200.0,
                  child: PaginatedDataTable(
                    columns: [
                      dataColumn("First Name"),
                      dataColumn("Last Name"),
                      dataColumn("Email"),
                      dataColumn("Address"),
                      dataColumn("City"),
                      dataColumn("Phone number"),
                      dataColumn("Approve"),
                    ],
                    source: notApprovedUser!,
                    rowsPerPage: 5,
                    showEmptyRows: false,
                  ),
                ),
              )
            ],
          ),
      ],
    );
  }
}

DataColumn dataColumn(String columName) {
  return DataColumn(label: Expanded(child: Text(columName)));
}

class NotApprovedUserSource extends DataTableSource {
  final List<UserModel> _notApprovedList;
  final BuildContext context;
 final VoidCallback refreshList; 
  NotApprovedUserSource(this._notApprovedList, this.context,this.refreshList);

  @override
  DataRow? getRow(int index) {
    if (index >= _notApprovedList.length) return null;

    final pravnoLice = _notApprovedList[index];
    return DataRow(cells: [
      DataCell(Text(pravnoLice.firstName!)),
      DataCell(Text(pravnoLice.lastName!)),
      DataCell(Text(pravnoLice.email!)),
      DataCell(Text(pravnoLice.address!)),
      DataCell(Text(pravnoLice.city!)),
      DataCell(Text(pravnoLice.phoneNumber ?? '/')),
      DataCell(ElevatedButton(
        onPressed: () async {
          final AuthProvider authProvider = AuthProvider();

          try {
            bool success =
                await authProvider.approveRegistartion(pravnoLice.id!);
            if (success) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('User registration approved successfully'),
                  backgroundColor: Colors.green,
                ),
              );
              refreshList();
              
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to approve user.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } catch (e) {
            String errorMessage = e.toString();

            if (errorMessage.startsWith("Exception:")) {
              errorMessage = errorMessage.replaceFirst("Exception:", "").trim();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          }
        },
        child: const Text("Approve registatrion"),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _notApprovedList.length;

  @override
  int get selectedRowCount => 0;
}
