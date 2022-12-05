import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';
import 'package:hacklytics_checkin_flutter/view/CheckinUserList.view.dart';

class CheckinCard extends StatelessWidget {
  CheckinCard({required this.fakeCheckin, super.key});

  FakeCheckin fakeCheckin;

  @override
  Widget build(BuildContext context) {
    return ListViewCard(children: [
      _buildListTile("User: ${fakeCheckin.user}", fakeCheckin.createdAtString),
    ]);
  }

  _buildListTile(String title, String? subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null && subtitle.isNotEmpty
          ? Text(subtitle)
          : _buildRedText("Not set"),
    );
  }

  _buildRedText(String text) {
    return Text(text, style: const TextStyle(color: Colors.red));
  }

  _buildGreenText(String text) {
    return Text(text, style: const TextStyle(color: Colors.green));
  }
}
