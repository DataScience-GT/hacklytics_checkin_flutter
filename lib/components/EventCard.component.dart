import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';

import 'package:hacklytics_checkin_flutter/models/Event.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event, super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    // return Row(children: [
    //   Expanded(
    //     child: Card(
    //         child: ListView(
    //       shrinkWrap: true,
    //       physics: const ClampingScrollPhysics(),
    //       children: [
    //         _buildListTile("Name", event.name),
    //         _buildListTile("Description", event.description),
    //         _buildListTile("Location", event.location),
    //         _buildListTileDate("Start", event.start),
    //         _buildListTileDate("End", event.end),
    //         _buildListTileStatus("Status", event.status),
    //       ],
    //     )),
    //   )
    // ]);
    return ListViewCard(children: [
      _buildListTile("Name", event.name),
      // const Divider(),
      _buildListTile("Description", event.description),
      // const Divider(),
      _buildListTile("Location", event.location),
      // const Divider(),
      _buildListTileDate("Start", event.start),
      // const Divider(),
      _buildListTileDate("End", event.end),
      // const Divider(),
      _buildListTileStatus("Status", event.status),
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

  _buildListTileStatus(String title, bool? status) {
    return ListTile(
      title: Text(title),
      subtitle: status != null && status == true
          ? _buildGreenText("Open")
          : _buildRedText("Closed"),
    );
  }

  _buildListTileDate(String title, TemporalDateTime? date) {
    // format date
    String formattedDate = date != null ? date.format() : "";

    return ListTile(
      title: Text(title),
      subtitle: formattedDate.isNotEmpty
          ? Text(formattedDate)
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
