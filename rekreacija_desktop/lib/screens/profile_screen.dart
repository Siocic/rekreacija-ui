import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/models/user_model.dart';
import 'package:rekreacija_desktop/providers/auth_provider.dart';
import 'package:rekreacija_desktop/utils/utils.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';
import 'package:rekreacija_desktop/widgets/edit_profile.dart';
import 'package:rekreacija_desktop/widgets/expired_dialog.dart';
import 'package:rekreacija_desktop/widgets/profile_parts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthProvider _authProvider = AuthProvider();
  UserModel? profile;
  late Map<String, TextEditingController> controllers;
  Image? image;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(40.0),
          child: ContentHeader(title: 'Profile'),
        ),
        Center(
          child: Container(
              width: 900.0,
              height: 700.0,
              padding: const EdgeInsets.all(15.0),
              color: Colors.grey[200],
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: image != null
                        ? image!.image
                        : const AssetImage(
                            'assets/images/RekreacijaDefaultProfilePicture.png'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(height: 20),
                  ProfileParts(
                      labelText: 'FirstName',
                      inputText: controllers["firstName"]!),
                  const SizedBox(height: 15),
                  ProfileParts(
                      labelText: 'LastName',
                      inputText: controllers["lastName"]!),
                  const SizedBox(height: 15),
                  ProfileParts(
                      labelText: 'Email', inputText: controllers["email"]!),
                  const SizedBox(height: 15),
                  ProfileParts(
                      labelText: 'City', inputText: controllers["city"]!),
                  const SizedBox(height: 15),
                  ProfileParts(
                      labelText: 'Address', inputText: controllers["address"]!),
                  const SizedBox(height: 15),
                  ProfileParts(
                      labelText: 'Phone', inputText: controllers["phone"]!),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 500.0,
                    height: 50,
                    child: TextButton(
                        onPressed: () async {
                          final bool? result = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext context) {
                                return EditProfile(
                                  firstNameController:
                                      controllers["firstName"]!,
                                  lastNameController: controllers["lastName"]!,
                                  emailController: controllers["email"]!,
                                  cityController: controllers["city"]!,
                                  addressController: controllers["address"]!,
                                  phoneController: controllers["phone"]!,
                                  currentImage: image?.image ??
                                      const AssetImage(
                                          'assets/images/RekreacijaDefaultProfilePicture.png'),
                                );
                              });
                          if (result == true) {
                            _loadUserProfile();
                          }
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0))),
                        child: const Text(
                          'Edit profile',
                          style: TextStyle(fontSize: 18),
                        )),
                  )
                ],
              )),
        )
      ],
    );
  }
}
