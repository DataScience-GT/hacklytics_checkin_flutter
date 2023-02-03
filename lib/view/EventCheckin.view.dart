// import 'dart:convert';

// import 'package:amplify_api/amplify_api.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:hacklytics_checkin_flutter/model/user.dart';
// import 'package:hacklytics_checkin_flutter/model/record.dart';
// import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:hacklytics_checkin_flutter/utils/nfc/read.nfc.dart';
import 'package:hacklytics_checkin_flutter/viewmodel/checkin.viewmodel.dart';
import 'package:provider/provider.dart';

class EventCheckinView extends StatefulWidget {
  const EventCheckinView({required this.event, required this.user, super.key});

  final Event event;
  final AmplifyUser user;

  @override
  State<EventCheckinView> createState() => _EventCheckinState();
}

class _EventCheckinState extends State<EventCheckinView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Check-in - ${widget.event.name}"),
        ),
        body: ChangeNotifierProvider<CheckinViewModel>(
          create: (context) =>
              CheckinViewModel(event: widget.event, currentUser: widget.user),
          child: Consumer<CheckinViewModel>(
            builder: (context, value, child) {
              return value.isReading
                  ? Center(child: ScanDialog(onRead: (nfc) {
                      value.isReading = false;
                      value.nfc = nfc;
                      value.loadUser();
                    }))
                  : (!value.isHacklytics
                      ? const Center(
                          child: Text("Card not formatted properly."))
                      : (value.loadingUser
                          ? const Center(child: CircularProgressIndicator())
                          : (value.error.isNotEmpty
                              ? Row(children: [
                                  Expanded(
                                      child: Card(
                                    color: Colors.red.shade400,
                                    child: Padding(
                                        padding: const EdgeInsets.all(24),
                                        child: Text(value.error)),
                                  ))
                                ])
                              : Row(children: [
                                  Expanded(
                                      child: Card(
                                    color: Colors.green.shade400,
                                    child: const Padding(
                                        padding: EdgeInsets.all(24),
                                        child:
                                            Text("User has been checked in.")),
                                  ))
                                ]))));
            },
          ),
        ));
  }
}

class ScanDialog extends StatelessWidget {
  ScanDialog({required this.onRead, super.key}) {
    ReadNfc(callback: (ReadNfc nfc) {
      onRead(nfc);
    });
  }

  final dynamic Function(ReadNfc nfc) onRead;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Scan NFC Card'),
      content: const Text('Please scan a Hacklytics NFC card.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
