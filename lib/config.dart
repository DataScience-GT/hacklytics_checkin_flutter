class Config {
  /// The name of the app (appears at the top of Home page)
  static const String appName = "Hacklytics 2024";

  /// Whether to show the debug logs
  static const bool isDebug = true;

  /// The groups that are allowed to use the app
  static const List<String> allowedGroups = ["Administrator", "Staff"];
}


// String appName = "Hacklytics";

// ///The singleton instance of the config
// static final Config _instance = Config._internal();

// ///The singleton instance of the config
// factory Config() {
//   return _instance;
// }

// Config._internal();