// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unused_import

// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

//  classes
import '../classes/Config.dart';
import '../classes/Utils.dart';
import '../classes/LogCollector.dart';  // ADD: Import LogCollector

//  pages
import '../pages/Start_Page.dart';
import '../pages/Log_Page.dart';
import '../pages/Settings_Page.dart';
import '../pages/Subscription_Page.dart';
import '../pages/PurchaseFail_Page.dart';
import '../pages/PurchaseSuccess_Page.dart';

// ADD: Import subscription service
import '../services/subscription_service.dart';

void main() async {
  // Wrap everything in a Zone to capture all print statements
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // ADD: Initialize subscription service (singleton)
    await SubscriptionService.instance.initialize();
    Utils.log( 'main.dart', 'Subscription service loaded successfully!');

    //  Force portrait only
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    //  ok, all systems go! Run the app!
    runApp(const MyApp());
    
  }, (error, stack) {
    // Handle any errors and log them
    LogCollector.addLog('Error in main: $error');
  }, zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
      // Intercept all print calls and add to LogCollector
      LogCollector.addToBuffer(line);
      
      // Still print to console for debugging
      parent.print(zone, line);
    },
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // (this page) variables
  final String filename = 'main.dart';

  // (this page) methods
  void _buildTriggered() {
    Utils.log(filename, '== "${Config.app_name}" ver ${Config.app_version} ==');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _buildTriggered();
    return MaterialApp(
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontSize: 16.0, // Default body text
              height: 1.5,
              color: Colors.black,
            ), 
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
            ),
          ),    
          useMaterial3: false,
        ),
        themeMode: ThemeMode.light, //  fix in July
        debugShowCheckedModeBanner: false,
        initialRoute: 'Start_Page',
        routes: {
          'Start_Page': (context) => const Start_Page(),
          'Log_Page': (context) => Log_Page(),
          'Settings_Page': (context) => const  Settings_Page(),
          'Subscription_Page': (context) => const  Subscription_Page(),
          'PurchaseFail_Page': (context) => const  PurchaseFail_Page(),
          'PurchaseSuccess_Page': (context) => const  PurchaseSuccess_Page(),
        },
      );
  }
}