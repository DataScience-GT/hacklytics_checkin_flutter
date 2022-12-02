import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/test.nfc.dart';

import "../config.dart";

/// The home page
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// TODO - use FutureBuilder to show loading indicator while getting the user's groups
class _HomeScreenState extends State<HomeScreen> {
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
          children: const [Text('Logged In'), SignOutButton(), NFCTest()],
        ),
      ),
    );
  }
}


// OLD CODE

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(""),
//       ),
//       body: Center(
//         child: Column(
//           children: const [
//             Text('Logged In'),
//             SignOutButton(),
//           ],
//         ),
//       ),
//     );
//   }
// }