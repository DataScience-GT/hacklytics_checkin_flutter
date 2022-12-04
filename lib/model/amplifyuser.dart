import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import '../config.dart';

class AmplifyUser {
  final String accessToken;
  final List<AuthUserAttribute> attributes;
  late List<dynamic> groups;
  late String username;
  late String deviceKey;
  late String clientId;
  bool hasAccess = false;

  AmplifyUser({required this.accessToken, required this.attributes}) {
    // decode the access token
    final parts = accessToken.split('.');
    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final response = utf8.decode(base64Url.decode(normalized));

    var json = jsonDecode(response);
    groups = json['cognito:groups'];
    username = json['username'];
    deviceKey = json['device_key'];
    clientId = json['client_id'];

    // check if the user is in the allowed groups
    for (var group in groups) {
      if (Config.allowedGroups.contains(group)) {
        hasAccess = true;
        break;
      }
    }
  }
}

// stuff from access token
// {
//     sub: "04b3aa8f-b917-4721-9347-3cb4afc7c79d",
//     device_key: "us-east-1_d28df39c-e32d-49ef-b1ae-5dd3cda170e0",
//     "cognito:groups": ["Administrator"],
//     iss: "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_AbPgED2Yg",
//     client_id: "4jk6f9u5ifju8u5a0ab8bkfle4",
//     origin_jti: "7c11a44d-54cb-4bd5-8a63-d76f649d6e4b",
//     event_id: "d9157f8c-778a-4dba-8dd9-0e710a5d556b",
//     token_use: "access",
//     scope: "aws.cognito.signin.user.admin",
//     auth_time: 1670117913,
//     exp: 1670121513,
//     iat: 1670117913,
//     jti: "c8b56c0b-e129-42f4-87e6-58aa732e9e1c",
//     username: "04b3aa8f-b917-4721-9347-3cb4afc7c79d",
// };