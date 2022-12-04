import 'package:flutter/material.dart';

import 'package:hacklytics_checkin_flutter/models/Event.dart';

class EventView extends StatefulWidget {
  const EventView({required this.event, super.key});

  final Event event;

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.name),
      ),
      body: Center(
        child: Text(widget.event.name),
      ),
    );
  }
}
