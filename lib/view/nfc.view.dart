import "package:flutter/material.dart";

class NfcPage extends StatelessWidget {
  const NfcPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC'),
      ),
      body: const Center(child: Text("test123")),
    );
  }
}
