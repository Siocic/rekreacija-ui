import 'package:flutter/material.dart';
import 'package:rekreacija_desktop/screens/dashboard.dart';
import 'package:rekreacija_desktop/screens/klijenti.dart';
import 'package:rekreacija_desktop/screens/moj_profil.dart';
import 'package:rekreacija_desktop/screens/poruke.dart';
import 'package:rekreacija_desktop/screens/recenzije_obavijesti.dart';
import 'package:rekreacija_desktop/screens/termini.dart';
import 'package:rekreacija_desktop/screens/uplate.dart';
import 'package:rekreacija_desktop/widgets/main_drawer.dart';

class HomePageScreen extends StatefulWidget{
  const HomePageScreen({super.key});

  @override
  State<StatefulWidget> createState() =>_HomePageState();
}

class _HomePageState extends State<HomePageScreen>{
  int selectedIndex=0;

 void onDrawerItemSelected(int index){
  setState(() {
    selectedIndex=index;
  });
 }

  Widget getSelectedScreen() {
    switch (selectedIndex) {
      case 0:
        return const DashboardScreen();  
      case 1:
        return const TerminiScreen();    
      case 2:
        return const KlijentiScreen();
      case 3:
        return const UplateScren();
      case 4:
        return const PorukeScreen();
      case 5: 
        return const RecenzijeObavijestiScreen();
      case 6:
        return const MojProfilScreen();
      default:
        return const Center(child: Text('Select a screen from the menu'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MainDrawer(onItemSelected: onDrawerItemSelected,selectedIndex: selectedIndex,),
          Expanded(
            child: getSelectedScreen(),
          ),
        ],
      ),
    );
  }
}