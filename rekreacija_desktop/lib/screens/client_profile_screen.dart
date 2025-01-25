import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rekreacija_desktop/colors.dart';

class ClientProfileScreen extends StatelessWidget {
  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Client Profile')),
        body: Padding(
          padding: EdgeInsets.only(left: 100.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             // const ProfileContainer(isEditable: false),
              const SizedBox(width: 20.0),
              Padding(
                padding: const EdgeInsets.only(top: 100.0, left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next appointment',
                      style: GoogleFonts.barlow(
                          color: AppColors.textCardColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 230.0,
                          height: 140.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '26.12.2024',
                                style: GoogleFonts.barlow(
                                    color: AppColors.textCardColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                '18:00',
                                style: GoogleFonts.barlow(
                                    color: AppColors.textCardColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'Person Name',
                                style: GoogleFonts.barlow(
                                    color: AppColors.textCardColor,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    Text(
                      'Last payments',
                      style: GoogleFonts.barlow(
                          color: AppColors.textCardColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          width: 300.0,
                          height: 100.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(40.0),
                                child: const SizedBox(
                                  width: 100.0,
                                  height: 120.0,
                                  child: Icon(Icons.paid,
                                      size: 80, color: Colors.green),
                                ),
                              ),
                              const SizedBox(width: 30.0),
                              const Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '12.12.2024',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        '70 KM',
                                        style: TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25.0),
                    SizedBox(
                      width: 200.0,
                      height: 60.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(14, 121, 115, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          'Issue invoice',
                          style: GoogleFonts.suezOne(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )

        //  Column(
        //   children: [
        //     const ProfileContainer(isEditable: false),
        //     Padding(
        //       padding: const EdgeInsets.only(left: 100.0),
        //       child: Row(
        //         children: [
        //           Column(
        //             children: [
        //               Text(
        //                 'Next appointment',
        //                 style: GoogleFonts.barlow(
        //                     color: AppColors.textCardColor,
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //               Card(
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(8.0),
        //                   child: SizedBox(
        //                     width: 230.0,
        //                     height: 140.0,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Text(
        //                           '26.12.2024',
        //                           style: GoogleFonts.barlow(
        //                               color: AppColors.textCardColor,
        //                               fontSize: 30,
        //                               fontWeight: FontWeight.bold),
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                         const SizedBox(height: 5.0),
        //                         Text(
        //                           '18:00',
        //                           style: GoogleFonts.barlow(
        //                               color: AppColors.textCardColor,
        //                               fontSize: 30,
        //                               fontWeight: FontWeight.bold),
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                         const SizedBox(height: 5.0),
        //                         Text(
        //                           'Person Name',
        //                           style: GoogleFonts.barlow(
        //                               color: AppColors.textCardColor,
        //                               fontSize: 30,
        //                               fontWeight: FontWeight.bold),
        //                           overflow: TextOverflow.ellipsis,
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //               const SizedBox(height: 10.0),
        //               ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: AppColors.buttonGreen,
        //                   shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(20.0),
        //                   ),
        //                 ),
        //                 onPressed: () {},
        //                 child: Text(
        //                   'Issue invoice',
        //                   style: GoogleFonts.suezOne(
        //                       color: Colors.white,
        //                       fontWeight: FontWeight.w400,
        //                       fontSize: 18),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           const SizedBox(width: 20.0),
        //           Column(
        //             children: [
        //               Text(
        //                 'Last payments',
        //                 style: GoogleFonts.barlow(
        //                     color: AppColors.textCardColor,
        //                     fontSize: 20,
        //                     fontWeight: FontWeight.bold),
        //               ),
        //               Card(
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(15.0),
        //                   child: SizedBox(
        //                     width: 250.0,
        //                     height: 100.0,
        //                     child: Row(
        //                       crossAxisAlignment: CrossAxisAlignment.center,
        //                       children: [
        //                         ClipRRect(
        //                           borderRadius: BorderRadius.circular(40.0),
        //                           child: const SizedBox(
        //                             width: 100.0,
        //                             height: 120.0,
        //                             child: Icon(Icons.paid,
        //                                 size: 80, color: Colors.green),
        //                           ),
        //                         ),
        //                         const SizedBox(width: 30.0),
        //                         const Expanded(
        //                           child: Padding(
        //                             padding:  EdgeInsets.symmetric(
        //                                 vertical: 10.0),
        //                             child: Column(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               mainAxisAlignment: MainAxisAlignment.center,
        //                               children: [
        //                                 Text(
        //                                   '12.12.2024',
        //                                   style:  TextStyle(
        //                                       fontSize: 24.0,
        //                                       fontWeight: FontWeight.normal,
        //                                       color: Colors.black),
        //                                   overflow: TextOverflow.ellipsis,
        //                                 ),
        //                                  SizedBox(height: 4.0),
        //                                 Text(
        //                                   '70 KM',
        //                                   style:  TextStyle(
        //                                       fontSize: 24.0,
        //                                       fontWeight: FontWeight.bold,
        //                                       color: Colors.black),
        //                                   overflow: TextOverflow.ellipsis,
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               )
        //             ],
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        );
  }
}
