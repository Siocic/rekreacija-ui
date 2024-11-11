import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:rekreacija_mobile/widgets/bottom_navigation.dart';
// import 'package:rekreacija_mobile/widgets/custom_appbar.dart';

class ObjektiScreen extends StatefulWidget {
  ObjektiScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ObjektiScreenState();
}

class _ObjektiScreenState extends State<ObjektiScreen> {
  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   // appBar:AppBar(
        //   //   backgroundColor:Color.fromARGB(200, 19, 19, 19),
        //   //   foregroundColor: Colors.white,
        //   //   title: const Text('Objekti'),
        //   // ),
        //   appBar: CustomAppBar(title: 'Objekti',titleAlignment: Alignment.centerLeft,showBackButton: true,),
        //   //bottomNavigationBar: CustomBottomNavigation(),
        //    body:
        Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(225, 19, 19, 19),
            Color.fromARGB(225, 49, 49, 49),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 50.0),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Objekti',
                    style: GoogleFonts.suezOne(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 20.0),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.map_sharp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );

    //);
  }
}
