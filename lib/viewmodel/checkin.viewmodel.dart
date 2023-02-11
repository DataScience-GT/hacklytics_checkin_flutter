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
    try {
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
    } catch (e) {
      _error = e.toString();
      _loadingUser = false;
      if (_mounted) notifyListeners();
    }
  }

  Future<bool> checkIfUserCheckedIn() async {
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
    if (res.error != null && res.error!.isNotEmpty) {
      _error = res.error!;
      _loadingUser = false;
      if (_mounted) notifyListeners();
      return false;
    }

    if (res.checkedIn) {
      // user is already checked in
      // callback(true, "User is already checked in to this event");
      // _error = "User is already checked in to this event";
      // _loadingUser = false;
      // if (_mounted) notifyListeners();
      return true;
    }

    return false;
  }

  getUser(Function(dynamic data, dynamic error) callback) async {
    // hacklytics record is of the form hacklytics://<id>
    try {
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
    } catch (e) {
      callback(null, e.toString());
    }
  }

  Future<void> checkinUser() async {
    try {
      // print("checking in user to " + event.name);
      // check if user is already checked in
      var res1 = await checkIfUserCheckedIn();
      if (res1 == true) {
        _error = "User is already checked in to this event";
        _loadingUser = false;
        if (_mounted) notifyListeners();
        return;
      }
      // check for rsvp
      if (event.requireRSVP == true) {
        // check if user has rsvp'd
        var rsvps = await Amplify.DataStore.query(EventRSVP.classType,
            where: EventRSVP.EVENTID
                .eq(event.id)
                .and(EventRSVP.USERID.eq(_user.username)));

        if (rsvps.isEmpty) {
          // user has not rsvp'd
          _error = "User has not RSVP'd to this event";
          _loadingUser = false;
          if (_mounted) notifyListeners();
          return;
        }

        // _loadingUser = false;
        // if (_mounted) notifyListeners();
        // return;
        // var request = ModelQueries.list(EventRSVP.classType, where: )

        // var request = GraphQLRequest(document: '''
        //     query queryRSVPs {
        //       listEventRSVPS(filter: {and: {userID: {eq: "${_user.username}"}, eventID: {eq: "${event.id}"}}}) {
        //         items {
        //           id
        //           eventID
        //           userName
        //           userID
        //           deleted:_deleted
        //         }
        //       }
        //     }
        //     ''');

        // var operation = Amplify.API.query(request: request);
        // var response = await operation.response;
        // if (response.errors.isNotEmpty) {
        //   _error = response.errors[0].message;
        //   _loadingUser = false;
        //   if (_mounted) notifyListeners();
        //   return;
        // }
        // var data = response.data;
        // var res = responseGetRsvp(data, event);

        // if (!res.rsvped) {
        //   // user is not rsvp'd
        //   _error = "User is not RSVP'd to this event";
        //   _loadingUser = false;
        //   if (_mounted) notifyListeners();
        //   return;
        // }
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

      // attempt to check in until it works
      var checkinWorked = false;

      while (!checkinWorked) {
        Checkin c = Checkin(
            user: _user.username,
            userName: _user.attributes["name"],
            createdBy: currentUser.username,
            createdByName: currentUserName,
            event: event);

        var request2 = ModelMutations.create(c);
        var operation2 = Amplify.API.mutate(request: request2);
        var response2 = await operation2.response;

        print(response2.data);
        print(response2.errors);
        if (response2.errors.isNotEmpty) {
          _error = response2.errors.first.message;

          _loadingUser = false;
          if (_mounted) notifyListeners();
          return;
        }

        // check if user is already checked in
        var res1 = await checkIfUserCheckedIn();
        if (res1 == true) {
          checkinWorked = true;
        }
      }

      // final predicate = Points.USERID.eq(_user.username);
      // var request3 = ModelQueries.list(Points.classType, where: predicate);
      // var operation3 = Amplify.API.query(request: request3);
      // var response3 = await operation3.response;
      // get user points
      // var request3 = GraphQLRequest(document: '''
      //       query queryPoints {
      //         listPoints(filter: {userID: {eq: "${_user.username}"}}) {
      //           items {
      //             id
      //             userID
      //             points
      //             version: _version
      //           }
      //         }
      //       }
      //       ''');
      // var operation3 = Amplify.API.query(request: request3);
      // var response3 = await operation3.response;

      // if (response3.errors.isNotEmpty) {
      //   _error = response3.errors.first.message;

      //   _loadingUser = false;
      //   if (_mounted) notifyListeners();
      //   return;
      // }

      // var pointsJson = jsonDecode(response3.data);
      // var points = pointsJson["listPoints"]["items"];

      // if (points.isNotEmpty) {
      //   // update points
      //   var p = points.first!;

      //   var request4 = GraphQLRequest(document: '''
      //   mutation updatePoints {
      //     updatePoints(input: {id: "${p["id"]}", points: ${p["points"] + (event.points ?? 0)}, _version: ${p["version"]}}) {
      //       id
      //       points
      //     }
      //   }
      //   ''');
      //   var operation4 = Amplify.API.mutate(request: request4);
      //   var response4 = await operation4.response;

      //   if (response4.errors.isNotEmpty) {
      //     _error = response4.errors.first.message;

      //     _loadingUser = false;
      //     if (_mounted) notifyListeners();
      //     return;
      //   }
      // } else {
      //   // create new points
      //   Points p = Points(
      //       userID: _user.username,
      //       points: event.points ?? 0,
      //       userName: _user.attributes["name"]);
      //   var request4 = ModelMutations.create(p);
      //   var operation4 = Amplify.API.mutate(request: request4);
      //   var response4 = await operation4.response;
      //   if (response4.errors.isNotEmpty) {
      //     _error = response4.errors.first.message;

      //     _loadingUser = false;
      //     if (_mounted) notifyListeners();
      //     return;
      //   }
      // }

      // create user points
      if (event.points != null) {
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
      }

      _loadingUser = false;

      if (_mounted) notifyListeners();
    } catch (e) {
      print(e);
      _error = e.toString();
      _loadingUser = false;
      if (_mounted) notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }

  void resetProvider() {
    _user = null;
    _error = "";
    _loadingUser = false;
    _checkedRecords = false;
    isReading = true;
    _isHacklytics = false;
    if (_mounted) notifyListeners();
  }
}

class responseGetUser {
  late dynamic user = "";
  late String error = "";
  responseGetUser(String data) {
    try {
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
    } catch (e) {
      print(e);
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

// class responseGetRsvp {
//   late bool rsvped = false;
//   late String error = "";
//   responseGetRsvp(String data, Event event) {
//     // print(data);
//     var json = jsonDecode(data);
//     var rsvps = json['listEventRSVPS']['items'];
//     print(rsvps);
//     if (rsvps == null || rsvps.isEmpty) {
//       // user is not rsvped in
//       return;
//     } else {
//       for (var rsvp in rsvps) {
//         if (rsvp['deleted'] == false) {
//           // user is rsvped in
//           rsvped = true;
//           return;
//         }
//       }
//     }
//     // // check if event matches
//     // for (var checkin in checkins) {
//     //   if (checkin['event']['id'] == event.id) {
//     //     // user is checked in
//     //     checkedIn = true;
//     //     return;
//     //   }
//     // }
//   }
// }
