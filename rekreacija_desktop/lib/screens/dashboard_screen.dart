import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/login.dart';
import 'package:rekreacija_desktop/widgets/content_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: ContentHeader(
            title: 'Dashboard',
            onLogout: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Row(
            children: [
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: SizedBox(
                  width: 350.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.insert_drive_file,
                                color: Colors.green[500],
                                size: 100.0,
                              ),
                              Positioned(
                                top: 15.0,
                                right: 20.0,
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.arrow_downward,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '75',
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Open requests',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 16.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      '4% (30 days)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: SizedBox(
                  width: 350.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.inventory_sharp,
                                color: Colors.green[500],
                                size: 100.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '375',
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Finished appointments',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 16.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      '4% (30 days)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: SizedBox(
                  width: 350.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.insert_drive_file,
                                color: Colors.green[500],
                                size: 100.0,
                              ),
                              Positioned(
                                top: 15.0,
                                right: 20.0,
                                child: Container(
                                  width: 35.0,
                                  height: 35.0,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '65',
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Canceled appointments',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_downward,
                                      color: Colors.red,
                                      size: 16.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      '4% (30 days)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                child: SizedBox(
                  width: 350.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          height: 100.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.paid,
                                color: Colors.green[500],
                                size: 100.0,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  '1200 KM',
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4.0),
                                Text(
                                  'Total revenue',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 4.0),
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_upward,
                                      color: Colors.green,
                                      size: 16.0,
                                    ),
                                    SizedBox(width: 4.0),
                                    Text(
                                      '4% (30 days)',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
