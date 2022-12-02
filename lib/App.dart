// amplify packages
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:hacklytics_checkin_flutter/screens/nfc.page.dart';

// amplify config file
import 'amplifyconfiguration.dart';
// material
import 'package:flutter/material.dart';
// import pages
import "./view/Home.page.dart";
import "./view/nfc.page.dart";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      print('Could not configure Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Authenticator(
      signUpForm: SignUpForm.custom(fields: [
        SignUpFormField.email(required: true),
        SignUpFormField.custom(
            title: 'GT Email',
            attributeKey: const CognitoUserAttributeKey.custom('gtemail'),
            hintText: "Enter your GaTech email",
            validator: ((value) {
              // if value is not null
              if (value != null && value.isNotEmpty) {
                // if value is not a valid GT email
                if (!value.contains('@gatech.edu')) {
                  return 'Please enter a valid GT email';
                }
              }
            })),
        SignUpFormField.name(required: true),
        SignUpFormField.birthdate(required: true),
        SignUpFormField.password(),
        SignUpFormField.passwordConfirmation(),
      ]),
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        builder: Authenticator.builder(),
        home: NfcPage.withDependency(),
      ),
    );
  }
}
