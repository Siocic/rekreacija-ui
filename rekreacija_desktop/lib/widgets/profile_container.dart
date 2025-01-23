// import 'package:flutter/material.dart';
// import 'package:rekreacija_desktop/widgets/edit_profile.dart';
// import 'package:rekreacija_desktop/widgets/profile_parts.dart';

// class ProfileContainer extends StatefulWidget {
//   final bool isEditable;
//   const ProfileContainer({super.key, required this.isEditable});

//   @override
//   State<ProfileContainer> createState() => _ProfileContainer();
// }

// class _ProfileContainer extends State<ProfileContainer> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Container(
//         width: 900,
//         height: 780,
//         padding: const EdgeInsets.all(15.0),
//         color: Colors.grey[200],
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (widget.isEditable)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const SizedBox(width: 60),
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return EditProfile();
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 10),
//             Center(
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage:
//                     const NetworkImage('https://via.placeholder.com/150'),
//                 backgroundColor: Colors.grey[300],
//               ),
//             ),
//             const SizedBox(height: 30),
//             const ProfileParts(labelText: 'FirstName:', inputText: 'FirstName'),
//             const SizedBox(height: 15),
//             const ProfileParts(labelText: 'LastName:', inputText: 'LastName'),
//             const SizedBox(height: 15),
//             const ProfileParts(labelText: 'Email:', inputText: 'Email'),          
//             const SizedBox(height: 15),
//             const ProfileParts(labelText: 'Phone number:', inputText: '123/456-789'),
//             const SizedBox(height: 15),
//             const ProfileParts(labelText: 'City:', inputText: 'Grad'),
//             const SizedBox(height: 15),
//             if (!widget.isEditable) ...[
//               const ProfileParts(labelText: 'Status:', inputText: 'Status'),
//               const SizedBox(height: 15),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
