import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/EventCard.component.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';

import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:hacklytics_checkin_flutter/view/CheckinUserList.view.dart';

import 'EventCheckin.view.dart';

class EventView extends StatelessWidget {
  const EventView({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(event.name),
        ),
        body: ListView(
          children: [
            EventCard(event: event),
            ListViewCard(children: [
              ListTile(
                title: const Text("View users checked in for this event"),
                trailing: const Icon(Icons.ballot),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckinUserListView(event: event),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                title: const Text("Check users in for this event"),
                trailing: const Icon(Icons.beenhere),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventCheckinView(event: event),
                    ),
                  );
                },
                enabled: event.status == true,
              )
            ])
          ],
        ));
  }
}
