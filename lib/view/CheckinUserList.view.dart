import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/model/status.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

class CheckinUserListView extends StatefulWidget {
  const CheckinUserListView({required this.event, super.key});

  final Event event;

  @override
  State<CheckinUserListView> createState() => _CheckinUserListState();
}

class _CheckinUserListState extends State<CheckinUserListView> {
  bool _loadingCheckins = true;
  List<dynamic> _checkins = [];
  String _error = "";

  @override
  Widget build(BuildContext context) {
    if (_loadingCheckins) {
      // get list of checkins
      _getCheckins((status) => {
            setState(() => {_loadingCheckins = false, _error = status.error})
          });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Checkin User List"),
        ),
        body: _loadingCheckins
            ? const Center(child: CircularProgressIndicator())
            : (_error.isNotEmpty
                ? StatusCard(message: _error, success: false)
                : _buildWithCheckins()));
  }

  _buildWithCheckins() {
    return ListView.builder(
      itemCount: _checkins.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_checkins[index]["user"]["name"]),
          subtitle: Text(_checkins[index]["user"]["email"]),
        );
      },
    );
  }

  _getCheckins(Function(Status) callback) async {
    callback(Status.withError(error: "Not implemented"));
  }
}
