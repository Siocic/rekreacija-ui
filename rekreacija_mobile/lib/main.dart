import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rekreacija_mobile/providers/appointment_provider.dart';
import 'package:rekreacija_mobile/providers/auth_provider.dart';
import 'package:rekreacija_mobile/providers/favorites_provider.dart';
import 'package:rekreacija_mobile/providers/holiday_provider.dart';
import 'package:rekreacija_mobile/providers/notification_provider.dart';
import 'package:rekreacija_mobile/providers/object_provider.dart';
import 'package:rekreacija_mobile/providers/review_provider.dart';
import 'package:rekreacija_mobile/providers/sport_category_provider.dart';
import 'package:rekreacija_mobile/routes.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SportCategoryProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ObjectProvider()),
    ChangeNotifierProvider(create: (_) => ReviewProvider()),
    ChangeNotifierProvider(create: (_) => FavoritesProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      Provider<HolidayProvider>(create: (_) => HolidayProvider()),

  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(14, 121, 115, 0)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
