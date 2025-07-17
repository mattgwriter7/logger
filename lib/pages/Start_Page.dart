// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unused_import

//  packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

//  classes
import '../classes/LogCollector.dart';
import '../classes/Utils.dart';
import '../classes/Config.dart';


class Start_Page extends StatefulWidget {
  const Start_Page({super.key});
  @override
  State<Start_Page> createState() => _Start_PageState();
}

class _Start_PageState extends State<Start_Page> {
  // (this page) variables
  final String filename = 'Start_Page.dart';

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

  // (this page) methods
  void _buildTriggered() {
    Utils.log(filename, '_buildTriggered()');
  }

  // addPostFrameCallback" is called after build completed
  void _addPostFrameCallbackTriggered(context) async {
    Utils.log(filename, '_addPostFrameCallbackTriggered() (build completed)');
  }

  @override
  Widget build(BuildContext context) {
    _buildTriggered();

    return WillPopScope(
      onWillPop: () async {
        Utils.log(filename, 'pop() forbidden!');
        return false; //  this allows the back button to work (if true)
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text( filename ),
      ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  color: Colors.grey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text( 'settings'),
                        onPressed: () { Navigator.pushNamed(context, 'Settings_Page'); },
                      ),
                      const SizedBox( height: 20 ),
                      ElevatedButton(
                        child: const Text( 'subscription'),
                        onPressed: () { Navigator.pushNamed(context, 'Subscription_Page'); },
                      ),
                    ],
                  )
                )
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15,8,10,2),
                    child: Wrap(
                      children: 
                        [ 
                          TextButton(
                            child: const Text('settings'),
                            onPressed: () { Navigator.pushNamed(context, 'Settings_Page'); },
                          ),
                          TextButton(
                            child: const Text('subscriptions'),
                            onPressed: () { Navigator.pushNamed(context, 'Subscription_Page'); },
                          ),
                          TextButton(
                            child: const Text('full log'),
                            onPressed: () {
                              Config.log = LogCollector.showLog();
                              Navigator.pushNamed(context, 'Log_Page');
                            } 
                          ),                          
                          TextButton(
                            child: const Text('my log'),
                            onPressed: () {
                              Config.log = Utils.running_log;
                              Navigator.pushNamed(context, 'Log_Page');
                            } 
                          ),
                          TextButton(
                            child: const Text('purchase fail'),
                            onPressed: () { Navigator.pushNamed(context, 'PurchaseFail_Page'); } 
                          ),
                          TextButton(
                            child: const Text('purchase success'),
                            onPressed: () { Navigator.pushNamed(context, 'PurchaseSuccess_Page'); } 
                          ),
                        ],
                      ),
                  )
                )
              ),                
            ],
          ),
        ),
      ),
    );
  }
}