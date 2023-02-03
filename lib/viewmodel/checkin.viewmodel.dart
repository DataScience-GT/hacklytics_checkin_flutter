import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:hacklytics_checkin_flutter/model/record.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:hacklytics_checkin_flutter/utils/nfc/read.nfc.dart';

class CheckinViewModel extends ChangeNotifier {
  CheckinViewModel({required this.event, required this.currentUser}) {}
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
    // print("checking in user to " + event.name);
    // check if user is already checked in
    var request = GraphQLRequest(document: '''
          query queryCheckins {
            listCheckins(filter: {user: {eq: "${_user.username}"}}) {
              items {
                user
                updatedAt
                createdBy
                event {
                  id
                }
              }
            }
          }
          ''');

    var operation = Amplify.API.query(request: request);
    var response = await operation.response;
    var data = response.data;
    var res = responseGetCheckins(data, event);

    if (res.checkedIn) {
      // user is already checked in
      _error = "User is already checked in to this event";
      _loadingUser = false;
      if (_mounted) notifyListeners();
      return;
    }

    String currentUserName = currentUser.attributes
        .where((a) => a.userAttributeKey.key == "name")
        .first
        .value;

    // check the user in
    var request2 = GraphQLRequest(document: '''
          mutation createCheckin {
            createCheckin(input: {user: "${_user.username}", userName: "${_user.attributes["name"]}", createdBy: "${currentUser.username}", createdByName: "$currentUserName", event: "${event.id}"}) {
              id
            }
          }
          ''');

    var operation2 = Amplify.API.mutate(request: request2);
    var response2 = await operation2.response;
    print(response2.data);

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

class responseGetCheckins {
  late bool checkedIn = false;
  late String error = "";
  responseGetCheckins(String data, Event event) {
    // print(data);
    var json = jsonDecode(data);
    var checkins = json['listCheckins']['items'];
    if (checkins == null || checkins.isEmpty) {
      // user is not checked in
      return;
    }
    // check if event matches
    for (var checkin in checkins) {
      if (checkin['event']['id'] == event.id) {
        // user is checked in
        checkedIn = true;
        return;
      }
    }
  }
}
