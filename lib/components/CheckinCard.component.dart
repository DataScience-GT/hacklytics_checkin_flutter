import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';
import 'package:hacklytics_checkin_flutter/view/CheckinUserList.view.dart';

class CheckinCard extends StatelessWidget {
  const CheckinCard({required this.fakeCheckin, super.key});

  final FakeCheckin fakeCheckin;

  @override
  Widget build(BuildContext context) {
    return ListViewCard(children: [
      ListTile(
        title: Text(fakeCheckin.userName),
        subtitle: Text('by ${fakeCheckin.createdByName}'),
        trailing: Text(fakeCheckin.createdAtString),
      )
    ]);
  }

  // _buildRedText(String text) {
  //   return Text(text, style: const TextStyle(color: Colors.red));
  // }

  // _buildGreenText(String text) {
  //   return Text(text, style: const TextStyle(color: Colors.green));
  // }
}
