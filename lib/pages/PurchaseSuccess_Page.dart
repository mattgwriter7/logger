// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';

//  classes
import '../classes/Utils.dart';
import '../classes/Config.dart';

class PurchaseSuccess_Page extends StatelessWidget {
  const PurchaseSuccess_Page({super.key});
  final String filename = 'PurchaseSuccess_Page';

  @override
  Widget build(BuildContext context) {
    Utils.log( filename, 'loaded $filename' );
    return WillPopScope(
      onWillPop: () async { _pop(context); return false; },
      child: Scaffold(
      appBar: AppBar(
        title: Text( filename ),
      ),
      body:  SafeArea(
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
                        child:  const Text( 'back'),
                        onPressed: () { _pop( context); },
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