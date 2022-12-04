import 'package:hacklytics_checkin_flutter/config.dart';

class Status {
  late String message;
  late bool success;
  late dynamic error;

  Status({required this.message, required this.success});
  Status.withError({required this.error}) {
    if (Config.isDebug) {
      print(error);
    }
    success = false;
  }
  Status.withSuccess({required this.message}) {
    success = true;
  }
}
