import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/screens/admin_dashboard_screen.dart';
import 'package:rekreacija_desktop/screens/appointment_screen.dart';
import 'package:rekreacija_desktop/screens/change_password_screen.dart';
import 'package:rekreacija_desktop/screens/clients_screen.dart';
import 'package:rekreacija_desktop/screens/dashboard_screen.dart';
import 'package:rekreacija_desktop/screens/messages_screen.dart';
import 'package:rekreacija_desktop/screens/object_screen.dart';
import 'package:rekreacija_desktop/screens/payment_screen.dart';
import 'package:rekreacija_desktop/screens/pending_approvals.dart';
import 'package:rekreacija_desktop/screens/profile_screen.dart';
import 'package:rekreacija_desktop/screens/review_notification_screen.dart';
import 'package:rekreacija_desktop/screens/user_screen.dart';
import 'package:rekreacija_desktop/widgets/main_drawer.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int selectedIndex = 0;
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  void onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Future<void> _loadUserRole() async {
    final role = await getUserRole();
    setState(() {
      userRole = role;
      selectedIndex = (userRole == 'SuperAdmin') ? 12 : 0; 
    });
  }

  Widget getSelectedScreen() {
    if (userRole == 'SuperAdmin') {
      switch (selectedIndex) {      
        case 6:
          return const ProfileScreen();
        case 9:
          return ChangePassword();
        case 10:
          return const UserScreen();
        case 11:
          return const PendingApprovals();
        case 12:
          return const AdminDashboard();
        default:
          return const Center(child: Text('Select a screen from the menu'));
      }
    } else if (userRole == 'PravnoLice') {
      switch (selectedIndex) {
        case 0:
          return const DashboardScreen();
        case 1:
          return const AppointmentScreen();
        case 2:
          return const ClientsScreen();
        case 3:
          return const PaymentScreen();
        case 4:
          return const MessagesScreen();
        case 5:
          return const ReviewNotificationScreen();
        case 6:
          return const ProfileScreen();
        case 7:
          return const ObjectScreen();
        case 9:
          return ChangePassword();
        default:
          return const Center(child: Text('Select a screen from the menu'));
      }
    } else {
      return const Center(child: Text('Select a screen from the menu'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MainDrawer(
              onItemSelected: onItemSelected,
              selectedIndex: selectedIndex,
              role: userRole),
          Expanded(
            child: getSelectedScreen(),
          )
        ],
      ),
    );
  }
}
