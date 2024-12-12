import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/colors.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const MainDrawer(
      {super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    Widget _buildNavItem({
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
      width: 250,
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
                _buildNavItem(
                  icon: Icons.home,
                  title: 'Dashboard',
                  isSelected: selectedIndex == 0,
                  onTap: () => onItemSelected(0),
                ),
                _buildNavItem(
                  icon: Icons.calendar_month,
                  title: 'Appointments',
                  isSelected: selectedIndex == 1,
                  onTap: () => onItemSelected(1),
                ),
                _buildNavItem(
                  icon: Icons.people,
                  title: 'Clients',
                  isSelected: selectedIndex == 2,
                  onTap: () => onItemSelected(2),
                ),
                _buildNavItem(
                  icon: Icons.payment,
                  title: 'Payments',
                  isSelected: selectedIndex == 3,
                  onTap: () => onItemSelected(3),
                ),
                _buildNavItem(
                  icon: Icons.message,
                  title: 'Messages',
                  isSelected: selectedIndex == 4,
                  onTap: () => onItemSelected(4),
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  title: 'Reviews & notifications',
                  isSelected: selectedIndex == 5,
                  onTap: () => onItemSelected(5),
                ),
                _buildNavItem(
                  icon: Icons.notifications,
                  title: 'My Profile',
                  isSelected: selectedIndex == 6,
                  onTap: () => onItemSelected(6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
