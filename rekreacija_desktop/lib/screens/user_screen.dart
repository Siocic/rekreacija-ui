import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/models/user_model.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  PravnoLiceSource? pravnoLiceSource;
  FizickoLiceSource? fizikoLiceSource;
  final AuthProvider authProvider = AuthProvider();
  List<UserModel> pravnoLiceList = [];
  List<UserModel> fizickoLiceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      var pLice = await authProvider.getUserOfRolePravnoLice();
      var fLice = await authProvider.getUserOfFizickoLice();
      setState(() {
        pravnoLiceList = pLice;
        fizickoLiceList = fLice;
        pravnoLiceSource = PravnoLiceSource(pravnoLiceList);
        fizikoLiceSource = FizickoLiceSource(fizickoLiceList);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Users'),
        ),
        const SizedBox(height: 10),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (pravnoLiceList.isEmpty && fizickoLiceList.isEmpty)
          const Center(
            child: Text("There are not users yet"),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pravnoLiceList.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Pravno Lice Users",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
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
                      ],
                      source: pravnoLiceSource!,
                      rowsPerPage: 5,
                      showEmptyRows: false,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (fizickoLiceList.isNotEmpty) ...[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Fizicko Lice Users",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Center(
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
                      ],
                      source: fizikoLiceSource!,
                      rowsPerPage: 5,
                      showEmptyRows: false,
                    ),
                  ),
                ),
              ],
            ],
          ),
      ],
    );
  }
}

DataColumn dataColumn(String columName) {
  return DataColumn(label: Expanded(child: Text(columName)));
}

class PravnoLiceSource extends DataTableSource {
  final List<UserModel> _pravnoLiceList;

  PravnoLiceSource(this._pravnoLiceList);

  @override
  DataRow? getRow(int index) {
    if (index >= _pravnoLiceList.length) return null;

    final pravnoLice = _pravnoLiceList[index];
    return DataRow(cells: [
      DataCell(Text(pravnoLice.firstName!)),
      DataCell(Text(pravnoLice.lastName!)),
      DataCell(Text(pravnoLice.email!)),
      DataCell(Text(pravnoLice.address!)),
      DataCell(Text(pravnoLice.city!)),
      DataCell(Text(pravnoLice.phoneNumber ?? "/")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _pravnoLiceList.length;

  @override
  int get selectedRowCount => 0;
}

class FizickoLiceSource extends DataTableSource {
  final List<UserModel> _fizickoLiceList;

  FizickoLiceSource(this._fizickoLiceList);

  @override
  DataRow? getRow(int index) {
    if (index >= _fizickoLiceList.length) return null;

    final pravnoLice = _fizickoLiceList[index];
    return DataRow(cells: [
      DataCell(Text(pravnoLice.firstName!)),
      DataCell(Text(pravnoLice.lastName!)),
      DataCell(Text(pravnoLice.email!)),
      DataCell(Text(pravnoLice.address!)),
      DataCell(Text(pravnoLice.city!)),
      DataCell(Text(pravnoLice.phoneNumber!)),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _fizickoLiceList.length;

  @override
  int get selectedRowCount => 0;
}
