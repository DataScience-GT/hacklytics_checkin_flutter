class Config {
  String a = "";

  ///The singleton instance of the config
  static final Config _instance = Config._internal();

  ///The singleton instance of the config
  factory Config() {
    return _instance;
  }

  Config._internal();
}
