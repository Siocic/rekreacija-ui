import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/models/user_model.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/widgets/custom_decoration.dart';
import 'package:rekreacija_mobile/widgets/edit_profile.dart';
import 'package:rekreacija_mobile/widgets/setting_popup.dart';
import '../utils/utils.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  late AuthProvider _authProvider;
  UserModel? profile;
  late Map<String, TextEditingController> controllers;
  Image? image;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthProvider>();
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
        controllers["phone"]?.text = profile?.phoneNumber ?? "-";
        if (profile?.profilePicture != null) {
          image = imageFromString(profile!.profilePicture!);
        } else {
          image = null; 
        }
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
      child: SingleChildScrollView(
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
              CircleAvatar(
                radius: 60,
                backgroundImage: image != null
                    ? image!.image
                    : const AssetImage(
                        'assets/images/RekreacijaDefaultProfilePicture.png'),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(height: 20),
              readOnlyTextField(controllers["firstName"]!, Icons.person),
              readOnlyTextField(controllers["lastName"]!, Icons.person),
              readOnlyTextField(controllers["email"]!, Icons.email),
              readOnlyTextField(controllers["city"]!, Icons.location_city),
              readOnlyTextField(controllers["address"]!, Icons.location_on),
              readOnlyTextField(
                  controllers["phone"]!, Icons.phone_android_sharp),
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    final bool? result = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return EditProfile(
                          firstNameController: controllers["firstName"]!,
                          lastNameController: controllers["lastName"]!,
                          emailController: controllers["email"]!,
                          cityController: controllers["city"]!,
                          addressController: controllers["address"]!,
                          phoneController: controllers["phone"]!,
                          currentImage: image?.image ??
                              const AssetImage(
                                  'assets/images/RekreacijaDefaultProfilePicture.png'),
                        );
                      },
                    );

                    if (result == true) {
                      _loadUserProfile();
                    }
                  },
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
      ),
    );
  }
}

Widget readOnlyTextField(TextEditingController controller, IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    child: TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(225, 49, 49, 49),
        enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromRGBO(14, 119, 62, 1.0), width: 2.0),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black,
          size: 30,
        ),
        isDense: true,
        contentPadding: const EdgeInsets.only(left: 0, top: 10),
      ),
      style: GoogleFonts.suezOne(color: Colors.white, fontSize: 20),
    ),
  );
}
