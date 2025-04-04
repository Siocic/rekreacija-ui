import 'package:flutter/material.dart';
import 'package:rekreacija_mobile/screens/homepage_screen.dart';
import 'package:rekreacija_mobile/screens/objekti_screen.dart';
import 'package:rekreacija_mobile/screens/profile_screen.dart';
import 'package:rekreacija_mobile/screens/rezervacije_screen.dart';
import 'package:rekreacija_mobile/utils/utils.dart';
import 'package:rekreacija_mobile/widgets/expired_dialog.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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

    Widget activePage = const HomePageScreen();

    if (_selectedPageIndex == 1) {
      activePage = const ObjektiScreen();
    } else if (_selectedPageIndex == 2) {
      activePage = const RezervacijeScreen();
    } else if (_selectedPageIndex == 3) {
      activePage = ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(14, 119, 62, 1.0),
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.white,
        currentIndex: _selectedPageIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: 'Objects'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Reservation'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
