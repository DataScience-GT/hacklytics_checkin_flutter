// amplify packages
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:hacklytics_checkin_flutter/models/ModelProvider.dart';
// import 'package:hacklytics_checkin_flutter/screens/nfc.page.dart';

// amplify config file
import 'amplifyconfiguration.dart';
// material
import 'package:flutter/material.dart';
// import pages
import "./view/Home.view.dart";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

// changes 12.31

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());

      await Amplify.addPlugin(
          AmplifyAPI(modelProvider: ModelProvider.instance));

      var dataPlugin = AmplifyDataStore(
          modelProvider: ModelProvider.instance,
          authModeStrategy: AuthModeStrategy.multiAuth);
      await Amplify.addPlugin(dataPlugin);

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
            title: 'School Email',
            attributeKey: const CognitoUserAttributeKey.custom('gtemail'),
            hintText: "Enter your school email",
            validator: ((value) {
              if (value != null && value.isNotEmpty) {
                if (!value.contains('.edu')) {
                  return 'Please enter a valid school email';
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
        home: HomeView(),
      ),
    );
  }
}
