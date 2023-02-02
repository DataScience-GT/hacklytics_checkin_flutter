import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:hacklytics_checkin_flutter/model/record.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:hacklytics_checkin_flutter/utils/nfc/read.nfc.dart';

class CheckinViewModel extends ChangeNotifier {
  CheckinViewModel({required this.event, required this.currentUser});
  final Event event;
  final AmplifyUser currentUser;

  bool _mounted = true;
  bool isReading = true;
  bool _checkedRecords = false;
  late ReadNfc nfc;
  bool _isHacklytics = false;
  late WellknownTextRecord _hacklyticsRecord;
  bool _loadingUser = false;
  late String _error = "";

  late dynamic _user;

  bool get checkedRecords => _checkedRecords;
  bool get isHacklytics => _isHacklytics;
  bool get loadingUser => _loadingUser;
  String get error => _error;
  dynamic get user => _user;

  loadUser() {
    if (!isReading && !_checkedRecords) {
      // check if has hacklytics record
      var match = nfc.records
          .where((r) =>
              r is WellknownTextRecord && r.text.contains("hacklytics://"))
          .toList();
      if (match.isNotEmpty) {
        _isHacklytics = true;
        _hacklyticsRecord = match[0] as WellknownTextRecord;
        _loadingUser = true;
        if (_mounted) notifyListeners();
        // load the user from amplify through graphql query getUserById
        getUser((data, error) {
          if (error != null && error.isNotEmpty) {
            _error = error;
            _loadingUser = false;

            if (_mounted) notifyListeners();
          } else {
            // we have a user!
            _user = data;
            // attempt to check user into event
            checkinUser();
          }
        });
      } else {
        _isHacklytics = false;
      }
      // we have now checked records
      _checkedRecords = true;
    }
  }

  getUser(Function(dynamic data, dynamic error) callback) async {
    // hacklytics record is of the form hacklytics://<id>
    var userUuid = _hacklyticsRecord.text.split("/")[2];
    var request = GraphQLRequest(document: '''
          query getUser {
            getUserById(user_uuid:"$userUuid")
          }
          ''');
    var operation = Amplify.API.query(request: request);
    var response = await operation.response;
    var data = response.data;
    // var getUserById = data['getUserById'];
    var res = responseGetUser(data);
    callback(res.user, res.error);
  }

  Future<void> checkinUser() async {
    print("checking in user to " + event.name);

    // check if user is already checked in
    var request = GraphQLRequest(document: '''
          query getRecord {
            getRecordByUserAndEvent(user_uuid:"${_user.uuid}", event_uuid:"${event.uuid}")
          }
          ''');

    _loadingUser = false;

    if (_mounted) notifyListeners();
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}

class responseGetUser {
  late dynamic user = "";
  late String error = "";
  responseGetUser(String data) {
    // print(data);
    var json = jsonDecode(data);
    // json = {getUserById: {"statusCode":200,"body":{"ok":1}}}
    var getUserById = jsonDecode(json['getUserById']);
    // getUserById = {"statusCode":200,"body":{"ok":1}}
    var statusCode = getUserById['statusCode'];
    var body = getUserById['body'];
    if (statusCode == 200) {
      // success
      var userStr = body["user"];
      User user = User(userStr);
      // user = {"ok":1}
      // print(user);
      this.user = user;
    } else {
      // error
      error = body["error"].toString();
    }
  }
}
