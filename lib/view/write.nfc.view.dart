import 'package:flutter/material.dart';

class WriteNfcView extends StatefulWidget {
  const WriteNfcView({super.key});

  @override
  State<WriteNfcView> createState() => _WriteNfcViewState();
}

class _WriteNfcViewState extends State<WriteNfcView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Write NFC"),
        ),
        body: const Center(child: Text("Write NFC")));
  }
}
