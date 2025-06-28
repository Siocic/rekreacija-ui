import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rekreacija_mobile/routes.dart';

class SettingsPopupMenu extends StatefulWidget {
  const SettingsPopupMenu({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPopupMenuState();
}

class _SettingsPopupMenuState extends State<SettingsPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.settings,
        color: Colors.white,
      ),
      color: const Color.fromARGB(225, 49, 49, 49),
      onSelected: (int value) async {
        switch (value) {
          case 0:
            Navigator.pushNamed(context, AppRoutes.changePassord);
            break;
          case 1:
            await _logout(context);
          case 2:
            Navigator.pushNamed(context, AppRoutes.myFavorites);
          case 3:
            Navigator.pushNamed(context, AppRoutes.myReservation);
          default:
            print('Invalid');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text("My favorites", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.history_rounded, color: Colors.white),
              SizedBox(width: 8),
              Text("My reservations", style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.white),
              SizedBox(width: 8),
              Text('Security', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.white),
              SizedBox(width: 8),
              Text('Log out', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _logout(BuildContext context) async {
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'jwt_token');
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }
}
