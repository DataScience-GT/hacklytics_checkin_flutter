import "package:flutter/material.dart";
import 'package:hacklytics_checkin_flutter/model/record.dart';

import 'package:hacklytics_checkin_flutter/utils/nfc/read.nfc.dart';

class ReadNfcView extends StatefulWidget {
  const ReadNfcView({super.key});

  @override
  State<ReadNfcView> createState() => _ReadNfcViewState();
}

class _ReadNfcViewState extends State<ReadNfcView> {
  bool _isReading = true;
  late ReadNfc _nfc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: Center(
            child: _isReading
                ? ScanDialog(onRead: (nfc) {
                    print("nfc found");
                    print(nfc);
                    setState(() {
                      _nfc = nfc;
                      _isReading = false;
                    });
                  })
                : const Text("nfc found.")));
  }
}

class ScanDialog extends StatelessWidget {
  ScanDialog({required this.onRead, super.key}) {
    ReadNfc(callback: (ReadNfc nfc) {
      onRead(nfc);
      // for (var element in nfc.records) {
      //   print(element);
      // }
      // var hack = nfc.records.where(
      //     (x) => x is WellknownTextRecord && x.text.contains("hacklytics://"));
      // if (hack.isNotEmpty) {
      //   print("hacklytics");
      // } else {
      //   print("not hacklytics");
      // }
    });
  }

  final dynamic Function(ReadNfc nfc) onRead;

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
