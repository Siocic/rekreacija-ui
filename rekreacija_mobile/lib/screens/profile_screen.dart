import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_mobile/models/user_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/setting_popup.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  UserModel? profile;
  late Map<String, TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = {
      "firstName": TextEditingController(),
      "lastName": TextEditingController(),
      "email": TextEditingController(),
      "city": TextEditingController(),
      "address": TextEditingController(),
      "phone": TextEditingController(),
    };
    _loadUserProfile();
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _authProvider.getUserProfile();
      setState(() {
        profile = user;
        controllers["firstName"]?.text = profile?.firstName ?? "";
        controllers["lastName"]?.text = profile?.lastName ?? "";
        controllers["email"]?.text = profile?.email ?? "";
        controllers["city"]?.text = profile?.city ?? "-";
        controllers["address"]?.text = profile?.address ?? "-";
        controllers["phone"]?.text = profile?.phone ?? "-";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: customDecoration,
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Profil',
                    style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                ),
                const Spacer(),
                const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: SettingsPopupMenu())
              ],
            ),
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: controllers["firstName"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllers["lastName"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllers["email"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllers["city"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon:
                            Icon(Icons.location_city, color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllers["address"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon:
                            Icon(Icons.location_on, color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controllers["phone"],
                      readOnly: true,
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(225, 49, 49, 49),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(14, 119, 62, 1.0),
                              width: 2.0),
                        ),
                        prefixIcon: Icon(Icons.phone_android_sharp,
                            color: Colors.black),
                        isDense: true,
                        contentPadding: EdgeInsets.only(left: 0, top: 12),
                      ),
                      style: GoogleFonts.suezOne(
                          color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            backgroundColor: Color.fromRGBO(14, 119, 62, 1.0),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        child: const Text('Edit profile',
                            style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
