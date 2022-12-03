import 'package:nfc_manager/nfc_manager.dart';

import '../../model/record.dart';

class WriteNfc {
  WriteNfc({required this.userUUID, required this.callback}) {
    _init();
  }

  final String userUUID;

  /// the callback function to be called when a tag is written and processed.
  final dynamic Function(WriteNfc) callback;

  /// the nfc tag read
  late NfcTag _tag;

  /// whether the tag is ndef
  late bool isNdef;

  /// the nfc tag's records
  List<Record> records = [];

  /// Any error that occurs during the process.
  String error = "";
  String success = "";

  _init() async {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      _tag = tag;
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        error = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: error);
        callback(this);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('hacklytics://$userUUID'),
      ]);

      try {
        await ndef.write(message);
        success = 'Successfully wrote to tag';
        NfcManager.instance.stopSession();
      } catch (e) {
        error = e.toString();
        NfcManager.instance.stopSession(errorMessage: error);
      } finally {
        callback(this);
      }
    });
  }
}
