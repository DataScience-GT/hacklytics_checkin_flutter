import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';

import 'package:hacklytics_checkin_flutter/models/Event.dart';
import 'package:intl/intl.dart';

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
      _buildListTile("ID", event.id),
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
      _buildListTileStatus("Requires RSVP", event.requireRSVP,
          greenText: "Yes", redText: "No"),
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

  _buildListTileStatus(
    String title,
    bool? status, {
    greenText = "Open",
    redText = "Closed",
  }) {
    return ListTile(
      title: Text(title),
      subtitle: status != null && status == true
          ? _buildGreenText(greenText)
          : _buildRedText(redText),
    );
  }

  _buildListTileDate(String title, TemporalDateTime? date) {
    final DateFormat formatter = DateFormat('EEEEE h:mm a');
    // final DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
    // format date
    // String formattedDate =
    //     date != null ? formatter.format(date as DateTime) : "";
    String formattedDate = "";
    if (date != null) {
      var d = DateTime.parse(date.toString()).toLocal();
      formattedDate = formatter.format(d);
    }

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
