import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

class EventCheckinView extends StatefulWidget {
  const EventCheckinView({required this.event, super.key});

  final Event event;

  @override
  State<EventCheckinView> createState() => _EventCheckinState();
}

class _EventCheckinState extends State<EventCheckinView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event Checkin"),
      ),
      body: const Center(
        child: Text("Event Checkin"),
      ),
    );
  }
}
