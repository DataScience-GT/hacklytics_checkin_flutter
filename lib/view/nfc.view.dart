import "package:flutter/material.dart";
import 'package:nfc_manager/nfc_manager.dart';

import './read.nfc.view.dart';

class NfcView extends StatelessWidget {
  const NfcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: Column(children: [
          ListTile(
            title: const Text("Read"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReadNfcView())),
              trailing: const Icon(Icons.arrow_right),
          )
        ]));
  }
}
