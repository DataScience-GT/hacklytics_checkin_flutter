import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
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
  bool _checkedRecords = false;
  late ReadNfc _nfc;
  bool _isHacklytics = false;
  late WellknownTextRecord _hacklyticsRecord;
  bool _loadingUser = false;

  @override
  Widget build(BuildContext context) {
    if (!_isReading && !_checkedRecords) {
      // check if has hacklytics record
      var match = _nfc.records
          .where((r) =>
              r is WellknownTextRecord && r.text.contains("hacklytics://"))
          .toList();
      if (match.isNotEmpty) {
        _isHacklytics = true;
        _hacklyticsRecord = match[0] as WellknownTextRecord;
        _loadingUser = true;
        // load the user from amplify
      } else {
        _isHacklytics = false;
      }
      // we have now checked records
      _checkedRecords = true;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: _isReading
            ? Center(child: ScanDialog(onRead: (nfc) {
                setState(() {
                  _nfc = nfc;
                  _isReading = false;
                });
              }))
            : (!_isHacklytics
                ? const Center(child: Text("No Hacklytics Record."))
                : (_loadingUser
                    ? const Center(child: CircularProgressIndicator())
                    : Text('record: ${_hacklyticsRecord.text}'))));
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
