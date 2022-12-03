import 'package:nfc_manager/nfc_manager.dart';

import "package:hacklytics_checkin_flutter/model/record.dart";

class ReadNfc {
  // constructor
  ReadNfc({required this.callback}) {
    _init();
  }

  /// The callback function to be called when a tag is read and processed.
  final dynamic Function(ReadNfc) callback;

  /// the nfc tag read
  late NfcTag _tag;
  late bool isNdef;
  List<Record> records = [];

  /// initializes the NFC manager and starts listening for NFC tags.
  _init() {
    // print("scanning");
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // print("tag found");
      _tag = tag;
      NfcManager.instance.stopSession();
      _readData();
    });
  }

  _readData() {
    try {
      var tech = Ndef.from(_tag);
      if (tech is Ndef) {
        isNdef = true;
        final cachedMessage = tech.cachedMessage;
        if (cachedMessage != null) {
          for (var i in Iterable.generate(cachedMessage.records.length)) {
            final recordSrc = cachedMessage.records[i];
            final Record record = Record.fromNdef(recordSrc);
            records.add(record);
          }
          callback(this);
        }
      } else {
        isNdef = false;
      }

      // ndefRecords.forEach((element) {
      //   print(element);
      // });
    } catch (e) {
      print(e);
    }
  }
}
