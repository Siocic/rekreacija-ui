import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/providers/object_provider.dart';
import 'package:rekreacija_desktop/widgets/card_view.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<StatefulWidget> createState() => _AdminDashboard();
}

class _AdminDashboard extends State<AdminDashboard> {
  late ObjectProvider objectProvider;
  late AuthProvider authProvider;
  int numberOfObjects = 0;
  int numberOfUsers = 0;
  bool isObjects = true;
  bool isUser = true;

  @override
  void initState() {
    super.initState();
    objectProvider = context.read<ObjectProvider>();
    authProvider = context.read<AuthProvider>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      var objects = await objectProvider.Get();
      var users = await authProvider.getAllUser();

      setState(() {
        numberOfObjects = objects.length;
        numberOfUsers = users.length;

        isObjects = false;
        isUser = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));

      setState(() {
        isObjects = false;
        isUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Padding(
        padding: EdgeInsets.all(40.0),
        child: ContentHeader(title: 'Dashboard'),
      ),
      const SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.only(left: 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardView(
                icon: Icons.apartment,
                num: numberOfObjects,
                decription: "Total objects",
                isLoading: isObjects),
            const SizedBox(width: 10),
            CardView(
                icon: Icons.people_alt,
                num: numberOfUsers,
                decription: "Total users",
                isLoading: isUser),
          ],
        ),
      ),
      const SizedBox(height: 10),
    ]);
  }
}
