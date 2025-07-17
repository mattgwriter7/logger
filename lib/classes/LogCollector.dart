// File: lib/classes/LogCollector.dart

class LogCollector {
  static String _logBuffer = '';
  
  // Add log with timestamp (for manual logging)
  static void addLog(String message) {
    String timestamp = DateTime.now().toString();
    _logBuffer += '$timestamp: $message\n';
  }
  
  // Add to buffer directly (used by Zone interceptor)
  static void addToBuffer(String line) {
    String timestamp = DateTime.now().toString();
    _logBuffer += '$timestamp: $line\n';
  }
  
  // Return all collected logs
  static String showLog() {
    return _logBuffer;
  }
  
  // Clear the log buffer
  static void clearLog() {
    _logBuffer = '';
  }
  
  // Get log count
  static int getLogCount() {
    return _logBuffer.split('\n').where((line) => line.isNotEmpty).length;
  }
}