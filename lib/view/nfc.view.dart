import "package:flutter/material.dart";
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';
import 'package:hacklytics_checkin_flutter/view/userlist.view.dart';
import './read.nfc.view.dart';

class NfcView extends StatelessWidget {
  const NfcView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('NFC'),
        ),
        body: ListViewCard(children: [
          ListTile(
            title: const Text("Read existing Hacklytics NFC"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ReadNfcView())),
            trailing: const Icon(Icons.assignment_ind),
          ),
          const Divider(),
          ListTile(
            title: const Text("Write new Hacklytics NFC"),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserListView())),
            trailing: const Icon(Icons.create),
          )
        ]));
  }
}
