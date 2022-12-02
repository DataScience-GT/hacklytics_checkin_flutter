import "package:flutter/material.dart";
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ReadNfcView extends StatefulWidget {
  const ReadNfcView({super.key});

  @override
  State<ReadNfcView> createState() => _ReadNfcViewState();
}

class _ReadNfcViewState extends State<ReadNfcView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: const Center(
          child: ScanDialog(),
        ));
  }
}

class ScanDialog extends StatefulWidget {
  const ScanDialog({super.key});

  // final Future<String?> Function(NfcTag tag) handleTag;

  @override
  State<ScanDialog> createState() => _ScanDialogState();
}

class _ScanDialogState extends State<ScanDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan NFC Tag'),
      content: const Text('Please scan a NFC tag'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
