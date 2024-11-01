import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/widgets/profile_parts.dart';

class ProfileContainer extends StatefulWidget {
  const ProfileContainer({super.key});

  @override
  State<ProfileContainer> createState() => _ProfileContainer();
}

class _ProfileContainer extends State<ProfileContainer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 900,
        padding: const EdgeInsets.all(15.0),
        color: Colors.grey[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 60),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    print("Edit podataka");
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    const NetworkImage('https://via.placeholder.com/150'),
                backgroundColor: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 30),
            const ProfileParts(labelText: 'FirstName:', inputText: 'FirstName'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'LastName:', inputText: 'LastName'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'Username:', inputText: 'Admin'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'Email:', inputText: 'Email'),
            const SizedBox(height: 15),
            const ProfileParts(
                labelText: 'Datum rodjenja:', inputText: '1/1/2001'),
            const SizedBox(height: 15),
            const ProfileParts(
                labelText: 'Broj telefona:', inputText: '123/456-789'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'Grad:', inputText: 'Grad'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'Clan od: ', inputText: '1/1/2025'),
            const SizedBox(height: 15),
            const ProfileParts(labelText: 'Status:', inputText: 'Status'),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
