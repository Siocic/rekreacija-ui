import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rekreacija_desktop/colors.dart';
import 'package:rekreacija_desktop/screens/login.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;
  final String role;

  const MainDrawer(
      {super.key,
      required this.onItemSelected,
      required this.selectedIndex,
      required this.role});

  @override
  Widget build(BuildContext context) {
    Widget buildNavItem({
      required IconData icon,
      required String title,
      required bool isSelected,
      required VoidCallback onTap,
    }) {
      return ListTile(
        leading: Icon(icon,
            color: isSelected ? AppColors.iconGreen : AppColors.iconBlack),
        title: Text(
          title,
          style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.green : Colors.black),
        ),
        selected: isSelected,
        onTap: onTap,
      );
    }

    return Container(
      width: 270,
      color: Colors.grey[200],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.sports, size: 50),
                SizedBox(width: 16),
                Text('Rekreacija',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                if (role == 'SuperAdmin') ...[
                  buildNavItem(
                    icon: Icons.home,
                    title: 'Dashboard',
                    isSelected: selectedIndex == 12,
                    onTap: () => onItemSelected(12),
                  ),
                  buildNavItem(
                    icon: Icons.people_outline,
                    title: 'Users',
                    isSelected: selectedIndex == 10,
                    onTap: () => onItemSelected(10),
                  ),
                  buildNavItem(
                    icon: Icons.pending_actions_sharp,
                    title: 'Pending approvals',
                    isSelected: selectedIndex == 11,
                    onTap: () => onItemSelected(11),
                  ),
                  buildNavItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    isSelected: selectedIndex == 6,
                    onTap: () => onItemSelected(6),
                  ),
                ],
                if (role == 'PravnoLice') ...[
                  buildNavItem(
                    icon: Icons.home,
                    title: 'Dashboard',
                    isSelected: selectedIndex == 0,
                    onTap: () => onItemSelected(0),
                  ),
                  buildNavItem(
                    icon: Icons.apartment,
                    title: 'Objects',
                    isSelected: selectedIndex == 7,
                    onTap: () => onItemSelected(7),
                  ),
                  buildNavItem(
                    icon: Icons.calendar_month,
                    title: 'Appointments',
                    isSelected: selectedIndex == 1,
                    onTap: () => onItemSelected(1),
                  ),
                  buildNavItem(
                    icon: Icons.people,
                    title: 'Clients',
                    isSelected: selectedIndex == 2,
                    onTap: () => onItemSelected(2),
                  ),
                  buildNavItem(
                    icon: Icons.payment,
                    title: 'Payments',
                    isSelected: selectedIndex == 3,
                    onTap: () => onItemSelected(3),
                  ),
                  buildNavItem(
                    icon: Icons.message,
                    title: 'Messages',
                    isSelected: selectedIndex == 4,
                    onTap: () => onItemSelected(4),
                  ),
                  buildNavItem(
                    icon: Icons.notifications,
                    title: 'Reviews & notifications',
                    isSelected: selectedIndex == 5,
                    onTap: () => onItemSelected(5),
                  ),
                  buildNavItem(
                    icon: Icons.person,
                    title: 'My Profile',
                    isSelected: selectedIndex == 6,
                    onTap: () => onItemSelected(6),
                  ),
                ]
              ],
            ),
          ),
          const Divider(),
          if (role == 'SuperAdmin' || role == 'PravnoLice') ...[
            buildNavItem(
              icon: Icons.lock,
              title: 'Security',
              isSelected: selectedIndex == 9,
              onTap: () => onItemSelected(9),
            ),
            buildNavItem(
              icon: Icons.logout,
              title: 'Logout',
              isSelected: selectedIndex == 8,
              onTap: () => _logout(context),
            ),
          ],
        ],
      ),
    );
  }
}

Future<void> _logout(BuildContext context) async {
  const secureStorage = FlutterSecureStorage();
  await secureStorage.delete(key: 'jwt_token');
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
    (route) => false,
  );
}
