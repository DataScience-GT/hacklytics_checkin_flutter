import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

class CheckinUserListView extends StatefulWidget {
  const CheckinUserListView({required this.event, super.key});

  final Event event;

  @override
  State<CheckinUserListView> createState() => _CheckinUserListState();
}

class _CheckinUserListState extends State<CheckinUserListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkin User List"),
      ),
      body: const Center(
        child: Text("Checkin User List"),
      ),
    );
  }
}
