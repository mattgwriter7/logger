// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unused_import

//  packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

//  classes
import '../classes/LogCollector.dart';
import '../classes/Utils.dart';
import '../classes/Config.dart';

class Settings_Page extends StatefulWidget {
  const Settings_Page({super.key});

  @override
  State<Settings_Page> createState() => _Settings_PageState();
}

class _Settings_PageState extends State<Settings_Page> {
  // (this page) variables
  final String filename = 'Settings_Page.dart';

  // (this page) init and dispose
  @override
  void initState() {
    super.initState();
    Utils.log(filename, 'initState()');
  }

  @override
  void dispose() {
    Utils.log(filename, 'dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { _pop(context); return false; },
      child: Scaffold(
        appBar: AppBar(
        title: Text( filename ),
      ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text( filename ),
                      const SizedBox( height: 20 ),
                      ElevatedButton(
                        child: const Text( 'back'),
                        onPressed: () { _pop(context); },
                      ),
                    ],
                  )
                )
              ),               
            ],
          ),
        ),
      ),
    );
  }

  void _pop( BuildContext context ) {
    Utils.log( filename, 'popped() $filename' );
    Navigator.pop(context);
  }  

}