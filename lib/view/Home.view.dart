import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/test.nfc.dart';
import 'package:hacklytics_checkin_flutter/view/nfc.view.dart';

import '../config.dart';

/// The home page
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

// TODO - use FutureBuilder to show loading indicator while getting the user's groups
class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
//     final session =
//     await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
// final idToken = session.userPoolTokens!.idToken;
// final userGroups = idToken.groups;

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
                child: Text("Nfc"))
          ],
        ),
      ),
    );
  }
}
