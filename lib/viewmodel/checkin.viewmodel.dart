import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_api/model_mutations.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:hacklytics_checkin_flutter/model/record.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/models/Checkin.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:hacklytics_checkin_flutter/models/ModelProvider.dart';
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
    // var request2 = GraphQLRequest(document: '''
    //       mutation createCheckin {
    //         createCheckin(input: {user: "${_user.username}", userName: "${_user.attributes["name"]}", createdBy: "${currentUser.username}", createdByName: "$currentUserName", event: "${event.id}"}) {
    //           id
    //         }
    //       }
    //       ''');
    Checkin c = Checkin(
        user: _user.username,
        userName: _user.attributes["name"],
        createdBy: currentUser.username,
        createdByName: currentUserName,
        event: event);

    var request2 = ModelMutations.create(c);

    var operation2 = Amplify.API.mutate(request: request2);
    var response2 = await operation2.response;
    if (response2.errors.isNotEmpty) {
      _error = response2.errors.first.message;

      _loadingUser = false;
      if (_mounted) notifyListeners();
      return;
    }

    // get user points
    final predicate = Points.USERID.eq(_user.username);
    var request3 = ModelQueries.list(Points.classType, where: predicate);
    var operation3 = Amplify.API.query(request: request3);
    var response3 = await operation3.response;

    if (response3.errors.isNotEmpty) {
      _error = response3.errors.first.message;

      _loadingUser = false;
      if (_mounted) notifyListeners();
      return;
    }

    var points = response3.data?.items as List<Points?>;
    if (points.isEmpty) {
      // create new points
      Points p = Points(
          userID: _user.username,
          points: event.points ?? 0,
          userName: _user.attributes["name"]);
      var request4 = ModelMutations.create(p);
      var operation4 = Amplify.API.mutate(request: request4);
      var response4 = await operation4.response;
      if (response4.errors.isNotEmpty) {
        _error = response4.errors.first.message;

        _loadingUser = false;
        if (_mounted) notifyListeners();
        return;
      }
    } else {
      // update points
      Points p = points.first!;
      // var request5 = GraphQLRequest(document: '''
      // mutation updatePoints {
      //   updatePoints(input: {id: "${p.id}", points: ${p.points + (event.points ?? 0)}}) {
      //     id
      //     points
      //   }
      // }
      // ''');
      Points updated = p.copyWith(points: p.points + (event.points ?? 0));
      await Amplify.DataStore.save(updated);
      // if (response5.errors.isNotEmpty) {
      //   _error = response5.errors.first.message;

      //   _loadingUser = false;
      //   if (_mounted) notifyListeners();
      //   return;
      // }
      // print(response5.data);
    }

    _loadingUser = false;

    if (_mounted) notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
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
