import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import "package:flutter/material.dart";
import 'package:hacklytics_checkin_flutter/model/record.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';

import 'package:hacklytics_checkin_flutter/utils/nfc/read.nfc.dart';

class ReadNfcView extends StatefulWidget {
  const ReadNfcView({super.key});

  @override
  State<ReadNfcView> createState() => _ReadNfcViewState();
}

class _ReadNfcViewState extends State<ReadNfcView> {
  bool _isReading = true;
  bool _checkedRecords = false;
  late ReadNfc _nfc;
  bool _isHacklytics = false;
  late WellknownTextRecord _hacklyticsRecord;
  bool _loadingUser = false;
  late String _error = "";

  late dynamic _user;

  @override
  Widget build(BuildContext context) {
    if (!_isReading && !_checkedRecords) {
      // check if has hacklytics record
      var match = _nfc.records
          .where((r) =>
              r is WellknownTextRecord && r.text.contains("hacklytics://"))
          .toList();
      if (match.isNotEmpty) {
        _isHacklytics = true;
        _hacklyticsRecord = match[0] as WellknownTextRecord;
        _loadingUser = true;
        // load the user from amplify through graphql query getUserById
        getUser((data, error) {
          if (error != null && error.isNotEmpty) {
            setState(() {
              _error = error;
            });
          } else {
            // we have a user!
            _user = data;
          }
          setState(() {
            _loadingUser = false;
          });
        });
      } else {
        _isHacklytics = false;
      }
      // we have now checked records
      _checkedRecords = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: _isReading
            ? Center(child: ScanDialog(onRead: (nfc) {
                setState(() {
                  _nfc = nfc;
                  _isReading = false;
                });
              }))
            : (!_isHacklytics
                ? const Center(child: Text("No Hacklytics Record."))
                : (_loadingUser
                    ? const Center(child: CircularProgressIndicator())
                    : (_error.isNotEmpty
                        ? Row(children: [
                            Expanded(
                                child: Card(
                              color: Colors.red.shade400,
                              child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(_error)),
                            ))
                          ])
                        : (_user is User ? _user.widget() : Text(_user))))));
  }

  getUser(Function(dynamic data, dynamic error) callback) async {
    // hacklytics record is of the form hacklytics://<id>
    var user_uuid = _hacklyticsRecord.text.split("/")[2];
    var request = GraphQLRequest(document: '''
          query getUser {
            getUserById(user_uuid:"$user_uuid")
          }
          ''');
    var operation = Amplify.API.query(request: request);
    var response = await operation.response;
    var data = response.data;
    // var getUserById = data['getUserById'];
    var res = response_getUser(data);
    callback(res.user, res.error);
  }
}

class ScanDialog extends StatelessWidget {
  ScanDialog({required this.onRead, super.key}) {
    ReadNfc(callback: (ReadNfc nfc) {
      onRead(nfc);
      // for (var element in nfc.records) {
      //   print(element);
      // }
      // var hack = nfc.records.where(
      //     (x) => x is WellknownTextRecord && x.text.contains("hacklytics://"));
      // if (hack.isNotEmpty) {
      //   print("hacklytics");
      // } else {
      //   print("not hacklytics");
      // }
    });
  }

  final dynamic Function(ReadNfc nfc) onRead;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan NFC Tag'),
      content: const Text('Please scan a NFC tag'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class response_getUser {
  late dynamic user = "";
  late String error = "";
  response_getUser(String data) {
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
