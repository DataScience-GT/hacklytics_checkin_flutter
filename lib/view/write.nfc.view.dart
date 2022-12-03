import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/utils/nfc/write.nfc.dart';

class WriteNfcView extends StatefulWidget {
  const WriteNfcView({required this.user, super.key});

  final User user;

  @override
  State<WriteNfcView> createState() => _WriteNfcViewState();
}

class _WriteNfcViewState extends State<WriteNfcView> {
  bool _writing = true;
  late WriteNfc _nfc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Write NFC"),
        ),
        body: _writing
            ? Center(
                child: ScanDialog(
                user: widget.user,
                onWrite: (writeNfc) {
                  setState(() {
                    _writing = false;
                    _nfc = writeNfc;
                  });
                },
              ))
            : (_nfc.error.isNotEmpty
                ? Row(children: [
                    Expanded(
                        child: Card(
                      color: Colors.red.shade400,
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(_nfc.error)),
                    ))
                  ])
                : Row(children: [
                    Expanded(
                        child: Card(
                      color: Colors.green.shade400,
                      child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(_nfc.success)),
                    ))
                  ])));
  }
}

class ScanDialog extends StatelessWidget {
  ScanDialog({required this.user, required this.onWrite, super.key}) {
    WriteNfc(
        user: user,
        callback: (WriteNfc nfc) {
          onWrite(nfc);
        });
  }

  final User user;

  final dynamic Function(WriteNfc nfc) onWrite;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan NFC Card'),
      content: const Text('Please scan an NFC card to write to.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
