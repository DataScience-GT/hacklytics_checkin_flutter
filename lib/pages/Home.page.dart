import 'package:amplify_authenticator/amplify_authenticator.dart';

import 'package:flutter/material.dart';

import "../config.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.appName),
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