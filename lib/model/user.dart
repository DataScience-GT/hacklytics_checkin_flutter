import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const usernameCensorLength = 5;

class User {
  late String username;
  late String censoredUsername;
  late Map<dynamic, String> attributes = <dynamic, String>{};
  late DateTime userCreateDate;
  late String userCreateDateStr;
  late DateTime userLastModifiedDate;
  late String userLastModifiedDateStr;
  late bool enabled;
  late String userStatus;

  User(userData) {
    username = userData['Username'];
    censoredUsername =
        '${username.substring(0, usernameCensorLength)}...${username.substring(username.length - usernameCensorLength)}';

    var attributesData = userData['Attributes'] as List<dynamic>;
    userCreateDate = DateTime.parse(userData['UserCreateDate']);
    userLastModifiedDate = DateTime.parse(userData['UserLastModifiedDate']);
    enabled = userData['Enabled'];
    userStatus = userData['UserStatus'];

    final DateFormat formatter = DateFormat('M/d/yyyy h:mm a');
    userCreateDateStr = formatter.format(userCreateDate);
    userLastModifiedDateStr = formatter.format(userLastModifiedDate);

    // handle attributes
    for (var attr in attributesData) {
      if (attr["Name"] == "name") {
        attributes["name"] = attr["Value"];
      } else if (attr["Name"] == "email") {
        attributes["email"] = attr["Value"];
      } else if (attr["Name"] == "phone_number") {
        attributes["phone_number"] = attr["Value"];
      } else if (attr["Name"] == "email_verified") {
        attributes["email_verified"] = attr["Value"];
      } else if (attr["Name"] == "phone_number_verified") {
        attributes["phone_number_verified"] = attr["Value"];
      }
    }
  }
  // User.v2(userData) {
  //   username = userData['username'];
  //   censoredUsername =
  //       '${username.substring(0, usernameCensorLength)}...${username.substring(username.length - usernameCensorLength)}';
  //   attributes['name'] = userData['name'];
  //   attributes['email'] = userData['email'];
  //   enabled = userData['enabled'];
  // }

  @override
  String toString() {
    return "username: $censoredUsername, attributes: $attributes, userCreateDate: $userCreateDateStr, userLastModifiedDate: $userLastModifiedDateStr, enabled: $enabled, userStatus: $userStatus";
  }

  Widget widget() {
    return Column(children: [
      Row(children: [
        Expanded(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("username: $censoredUsername"),
            Text("attributes: $attributes"),
            Text("userCreateDate: $userCreateDateStr"),
            Text("userLastModifiedDate: $userLastModifiedDateStr"),
            Text("enabled: $enabled"),
            Text("userStatus: $userStatus"),
          ]),
        )))
      ])
    ]);
  }
}
