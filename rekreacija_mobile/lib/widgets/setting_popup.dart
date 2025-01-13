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
            print('Location selected');
            break;
          case 1:
            print('Security selected');
            break;
          case 2:
            print('Help selected');
            break;
          case 3:
            print('Information selected');
            break;
          case 4:
            await _logout(context);
          default:
            print('Invalid');
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.location_on_sharp, color: Colors.white),
              SizedBox(width: 8),
              Text('Location', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.lock, color: Colors.white),
              SizedBox(width: 8),
              Text('Security', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Icons.help, color: Colors.white),
              SizedBox(width: 8),
              Text('Help', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 3,
          child: Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text('Information', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 4,
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
  
  // Remove the JWT token
  await secureStorage.delete(key: 'jwt_token');

  // Navigate to the login screen
  Navigator.pushReplacementNamed(context, AppRoutes.login);
}

}
