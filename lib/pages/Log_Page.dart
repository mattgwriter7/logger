// ignore_for_file: camel_case_types, prefer_interpolation_to_compose_strings, use_key_in_widget_constructors, unused_import

//  packages
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//  classes
import '../classes/Utils.dart';
import '../classes/Config.dart';
import '../classes/LogCollector.dart'; 

class Log_Page extends StatelessWidget {

  final String filename = 'Log_Page.dart';

  const Log_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async { _pop(context); return false; },
      child: Scaffold(
        appBar: AppBar(
        title: Text( filename ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              //  just for fun I fixed a VS Code squiggle warning
              //  for _trySave(), but left _tryDelete() as-is...
              final ctx = Navigator.of(context);
              await _trySave();
              _pop(ctx as BuildContext);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              await _tryDelete();
              Config.log = '';
              Utils.running_log = '';
              LogCollector.clearLog();
              _pop(context);
            },
          ),
        ],        
      ),
        body: SafeArea(
          child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height-16,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(Utils.formatLogString( Config.log )),
                    //Text( Utils.running_log ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  //  ajax calls

  static Future<int> _trySave() async {
      String status = '';
      int i = -1;
      String header = '\n\n' + Config.app_name + ' version ' + Config.app_version + '' + DateTime.now().toString() + '\n';

      final result = await http.post(Uri.parse( Config.server_log_url ),
        body: {
          "file" : header + Config.log, //  log file
          "pw" : "pw",                  //  password required to save logs 
      });

      Utils.log( 'Log_Page.dart trySave()', result.body );
      status = jsonDecode(result.body)['status'].toString();
      status == 'bad' ? i=0 : i=1;
      return i;
  }
  
static Future<int> _tryDelete() async {
      String status = '';
      int i = -1;

      final result = await http.post(Uri.parse( '${ Config.server_log_url }/delete.php'),
        body: {
          "pw" : "pw",  //  password required to save logs 
      });

      Utils.log( 'Log_Page.dart tryDelete()', result.body );
      status = jsonDecode(result.body)['status'].toString();
      status == 'bad' ? i=0 : i=1;
      return i;
  }

  void _pop( BuildContext context ) {
    Utils.log( filename, 'popped() $filename' );
    Navigator.pop(context);
  }  

}