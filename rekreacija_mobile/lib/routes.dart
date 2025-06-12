import 'package:flutter/material.dart';
import 'package:rekreacija_mobile/screens/change_password_screen.dart';
import 'package:rekreacija_mobile/screens/fizickolice_screen.dart';
import 'package:rekreacija_mobile/screens/hall_message_screen.dart';
import 'package:rekreacija_mobile/screens/homepage_screen.dart';
import 'package:rekreacija_mobile/screens/login_screen.dart';
import 'package:rekreacija_mobile/screens/messages_screen.dart';
import 'package:rekreacija_mobile/screens/notifications_screen.dart';
import 'package:rekreacija_mobile/screens/objekti_screen.dart';
import 'package:rekreacija_mobile/screens/pravnolice_screen.dart';
import 'package:rekreacija_mobile/screens/profile_screen.dart';
import 'package:rekreacija_mobile/screens/rezervacije_screen.dart';
import 'package:rekreacija_mobile/screens/role_selection_screen.dart';
import 'package:rekreacija_mobile/screens/tabs_screen.dart';

class AppRoutes{

  static const String home='/home';
  static const String login='/login';  
  static const String tabsscreen='/tabsscreen';
  static const String objekti='/objekti';
  static const String rezervacije='/rezervacije';
  static const String profil='/profil';
  static const String messages='/messages';
  static const String nottification='/nottification';
  static const String pravnolice='/pravnolice';
  static const String fizickolice='/fizickolice';
  static const String roleselection='/roleselction';
  static const String hallmessage='/hallMessage';
  static const String changePassord='/changePassword';

  static Map<String,WidgetBuilder>getRoutes(){
    return{
      home:(context)=>const HomePageScreen(),
      login:(context)=>LoginScreen(),
      tabsscreen:(context)=>const TabsScreen(),
      objekti:(context)=>const ObjektiScreen(),
      rezervacije:(context)=>const RezervacijeScreen(),
      profil:(context)=>ProfileScreen(),
      messages:(context)=>const MessagesScreen(),
      nottification:(context)=>const NotificationsScreen(),
      pravnolice:(context)=>PravnoliceScreen(),
      fizickolice:(context)=>FizickoliceScreen(),
      roleselection:(context)=>const RoleSelectionScreen(),
      changePassord:(context)=> ChangePassword(),
    };
  }
}