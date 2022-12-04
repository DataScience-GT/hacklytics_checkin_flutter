import 'dart:convert';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    getUserInfo((status) {
      if (status.success) {
        print('message: ${status.message}');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.appName),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Logged In'),
            // SignOutButton(),
            ElevatedButton(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NfcView())),
                child: const Text("Nfc"))
          ],
        ),
      ),
    );
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

        _user = AmplifyUser(accessToken: accessToken, attributes: attributes);

        callback(Status.withSuccess(message: "Got user info."));
      }
    } catch (err) {
      return callback(Status.withError(error: err));
    }
    // return callback(Status.withSuccess(message: "Success!"));
  }
}
