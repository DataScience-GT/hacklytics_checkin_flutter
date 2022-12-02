import "package:flutter/material.dart";
import 'package:nfc_manager/nfc_manager.dart';

class NfcView extends StatelessWidget {
  const NfcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: const Center(
          child: Text("asd"),
        ));
  }
}
