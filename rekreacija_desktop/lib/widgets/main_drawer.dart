import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final Function(int) onItemSelected;
  final int selectedIndex;

  const MainDrawer(
      {super.key, required this.onItemSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey[100],
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(Icons.sports, size: 50),
                SizedBox(width: 18),
                Text('Rekreacija', style: TextStyle(fontSize: 24)),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home, size: 30),
            title: const Text('Dashboard'),
            selected: selectedIndex == 0,
            selectedColor: Colors.green,            
            onTap: () => onItemSelected(0),
          ),
          ListTile(
            leading: const Icon(Icons.list, size: 30),
            title: const Text('Termini'),
            selected: selectedIndex == 1,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(1),
          ),
          ListTile(
            leading: const Icon(Icons.person, size: 30),
            title: const Text('Klijenti'),
            selected: selectedIndex == 2,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(2),
          ),
          ListTile(
            leading: const Icon(Icons.payment, size: 30),
            title: const Text('Uplate'),
            selected: selectedIndex == 3,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(3),
          ),
          ListTile(
            leading: const Icon(Icons.message, size: 30),
            title: const Text('Poruke'),
            selected: selectedIndex == 4,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(4),
          ),
          ListTile(
            leading: const Icon(Icons.notifications, size: 30),
            title: const Text('Recenzije i obavijesti'),
            selected: selectedIndex == 5,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(5),
          ),
          ListTile(
            leading: const Icon(Icons.account_box, size: 30),
            title: const Text('Moj profil'),
            selected: selectedIndex == 6,
            selectedColor: Colors.green,    
            onTap: () => onItemSelected(6),
          ),
        ],
      ),
    );
  }
}
