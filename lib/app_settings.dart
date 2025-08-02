class AppSettings {
  static String appName = "Eventizer";
  final String firebaseAppName = "EventizerApp";
  final int defaultNavIndex = 2;
  //final String _server = "Release";
  //final String _server = "Development";
  final String _server = "OpenTest";
  String getServer() => _server;
}
