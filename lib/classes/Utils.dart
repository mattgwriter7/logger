// ignore_for_file: file_names, non_constant_identifier_names

//  packages
import 'package:flutter/foundation.dart';

class Utils {
  // (this page) variables
  static const String filename = 'Utils.dart';
  //  the first timestamp
  static final int original_timestamp = DateTime.now().millisecondsSinceEpoch;
  //  running Log String
  static String running_log =
      ''; //  this is a capture of what console.log has printed

  static int timeStampNow() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String showTimeDiff([bool allowHtml = false]) {
    String val = '';
    int diff = timeStampNow() - original_timestamp;
    double minute = 0;
    if (diff < 60000) {
      double seconds = diff * .001;
      val = '${seconds.toStringAsFixed(1)}s';
    } else {
      minute = diff / 60000;
      double remainder = diff % 60000;
      remainder = remainder * .001;
      val = '${minute.toInt()}m ${remainder.toStringAsFixed(1)}s';
    }
    //  if value has a minus, remove it!
    if (val == '-0.0s') {
      val = '0.0s';
    }
    return val;
  }

  static void log(String filename, String message) {
    if (!blacklist.contains(filename)) {
      if (kDebugMode) {
        print('(${showTimeDiff()}) >> ($filename) $message');
      }
      running_log += "(${showTimeDiff()}) >> ($filename) $message\r\n";
    }
  }

  //  BLACKLIST (do not show logging info from these files)
  static List<String> blacklist = [
    //  'Start_Page.dart',
    'Date.dart',
  ];

  

  static String formatLogString(String input) {
  if (input.isEmpty) return '';
  
  List<String> lines = input.split('\n');
  List<String> result = [];
  
  for (String line in lines) {
    if (line.trim().isEmpty) continue;
    
    // Find the second ")" in the line
    int firstParen = line.indexOf(')');
    if (firstParen != -1) {
      int secondParen = line.indexOf(')', firstParen + 1);
      if (secondParen != -1) {
        // First line: everything up to and including the second ")"
        String firstPart = line.substring(0, secondParen + 1);
        result.add(firstPart);
        
        // Second line: everything after the second ")"
        String secondPart = line.substring(secondParen + 1).trim();
        if (secondPart.isNotEmpty) {
          result.add(secondPart);
          result.add(''); // Add extra newline for spacing
        }
      } else {
        // If no second ")", just add the line as-is
        result.add(line);
      }
    } else {
      // If no ")" at all, just add the line as-is
      result.add(line);
    }
  }
  
  return result.join('\n');}
}