class AppSettings {
  //final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final String appName = "EventizerApp";
  final int defaultNavIndex = 2;
  // String _server = "Release";
  final String _server = "Development";
  //String _server = "OpenTest";
  String getServer() => _server;
}
