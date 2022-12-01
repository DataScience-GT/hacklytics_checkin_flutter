import 'package:amplify_authenticator/amplify_authenticator.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged In'),
      ),
      body: Center(
        child: Column(
          children: const [
            Text('Logged In'),
            SignOutButton(),
          ],
        ),
      ),
    );
  }
}
