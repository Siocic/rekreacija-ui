import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/client_profile_screen.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = MyDataSource(context: context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Clients'),
        ),
        const SizedBox(height: 20.0),
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: SizedBox(
            width: 1200.0,
            child: PaginatedDataTable(
              columns: const [
                DataColumn(
                    label: Expanded(
                  child: Text('Person Name'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Sport'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Phone number'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Email'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('City'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Status'),
                )),
                DataColumn(
                    label: Expanded(
                  child: Text('Profile'),
                )),
              ],
              source: dataSource,
              rowsPerPage: 5,
              showEmptyRows: false,
            ),
          ),
        ),
      ],
    );
  }
}

//final DataTableSource dataSource = MyDataSource(context);

class MyDataSource extends DataTableSource {
  final BuildContext context;
  final List<List<String>> dummyData = [
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Inactive'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Inactive'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Inactive'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Inactive'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Active'
    ],
    [
      'Admin Admin',
      'Football',
      '123456789',
      'admin@email.com',
      'Admin',
      'Inactive'
    ],
  ];

  MyDataSource({required this.context});
  @override
  DataRow? getRow(int index) {
    if (index >= dummyData.length) return null;

    final row = dummyData[index];
    final isActive = row[5] == 'Active';
    return DataRow(cells: [
      DataCell(Text(row[0])),
      DataCell(Text(row[1])),
      DataCell(Text(row[2])),
      DataCell(Text(row[3])),
      DataCell(Text(row[4])),
      DataCell(
        Container(
          decoration: BoxDecoration(
              color: isActive ? Colors.green[100] : Colors.red[100],
              border: Border.all(color: isActive ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(4.0)),
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
          child: Text(
            row[5],
            style: TextStyle(
                color: isActive ? Colors.green[900] : Colors.red[900],
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      DataCell(
        IconButton(
          icon: const Icon(Icons.open_in_new),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ClientProfileScreen()));
          },
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => dummyData.length;

  @override
  int get selectedRowCount => 0;
}
