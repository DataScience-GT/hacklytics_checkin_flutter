import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/components/test.nfc.dart';
import 'package:hacklytics_checkin_flutter/view/nfc.view.dart';

import '../config.dart';
import '../model/AmplifyUser.dart';
import '../model/status.dart';

/// The home page
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// TODO - use FutureBuilder to show loading indicator while getting the user's groups
class _HomeViewState extends State<HomeView> {
  late AmplifyUser _user;
  bool _loadingUser = true;
  late String _error = "";

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      getUserInfo((status) {
        if (status.success) {
          print('message: ${status.message}');
          setState(() {
            _loadingUser = false;
          });
        } else {
          setState(() {
            _error = status.error.toString();
            _loadingUser = false;
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.appName),
      ),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  _buildBody() {
    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : StatusCard(message: _user.toString(), success: true);
  }

  getUserInfo(Function(Status status) callback) async {
    try {
      AuthSession authSessions = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));

      if (authSessions.isSignedIn) {
        final accessToken =
            (authSessions as CognitoAuthSession).userPoolTokens?.accessToken;
        if (accessToken == null || accessToken.isEmpty) {
          callback(Status.withError(error: "No access token."));
          return;
        }

        var attributes = await Amplify.Auth.fetchUserAttributes();

        setState(() {
          _user = AmplifyUser(accessToken: accessToken, attributes: attributes);
        });

        callback(Status.withSuccess(message: "Got user info."));
      }
    } catch (err) {
      return callback(Status.withError(error: err));
    }
    // return callback(Status.withSuccess(message: "Success!"));
  }
}
