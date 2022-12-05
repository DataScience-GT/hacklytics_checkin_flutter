import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/CheckinCard.component.dart';
import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/model/status.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

import 'package:hacklytics_checkin_flutter/models/Checkin.dart';
import 'package:intl/intl.dart';

class CheckinUserListView extends StatefulWidget {
  const CheckinUserListView({required this.event, super.key});

  final Event event;

  @override
  State<CheckinUserListView> createState() => _CheckinUserListState();
}

class _CheckinUserListState extends State<CheckinUserListView> {
  String _error = "";
  bool _loadingCheckins = true;
  List<FakeCheckin> _checkins = [];

  @override
  void initState() {
    super.initState();
    final subscription = _getCheckinsStream((status) {
      if (!status.success) {
        setState(() {
          _error = status.error.toString();
        });
      }
    });
    subscription.listen((checkin) {
      // print(checkin);

      if (checkin.data != null) {
        var data = jsonDecode(checkin.data);
        if (data['onCreateCheckin'] != null) {
          var c = data['onCreateCheckin'];
          //{event: {id: 792a4ba3-f4ca-47b5-910b-1d32fbd57e78}, id: 30f3b625-d32e-446a-bcbc-cf412d6f0bcf, user: john3, createdBy: john3, createdAt: 2022-12-05T03:34:33.373Z}
          FakeCheckin checkin = FakeCheckin.fromJson(c);
          setState(() {
            _checkins = [checkin, ..._checkins];
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCheckins) {
      // get list of checkins
      // _getCheckins((status) => {
      //       setState(() => {_loadingCheckins = false, _error = status.error})
      //     });
      _getExistingCheckins((status) {
        if (status.success) {
          setState(() {
            _loadingCheckins = false;
          });
        } else {
          setState(() {
            _error = status.error.toString();
            _loadingCheckins = false;
          });
        }
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

  // _buildWithNullCheck() {
  //   return widget.event.checkins == null || widget.event.checkins!.isEmpty
  //       ? const Center(child: Text("No checkins"))
  //       : _buildWithCheckins();
  // }

  _buildWithCheckins() {
    if (_checkins.isEmpty) {
      return const Center(child: Text("No checkins"));
    }
    return RefreshIndicator(
        child: ListView.builder(
          itemCount: _checkins.length,
          itemBuilder: (context, index) {
            return CheckinCard(fakeCheckin: _checkins[index]);
          },
        ),
        onRefresh: () async {
          setState(() => {
                _loadingCheckins = true,
                _checkins = [],
              });
        });
  }

  _getExistingCheckins(Function(Status) callback) async {
    try {
      final where = Checkin.EVENT.eq(widget.event.id);
      final request = ModelQueries.list(Checkin.classType, where: where);
      final result = await Amplify.API.query(request: request).response;

      if (result.data != null) {
        final checkins =
            result.data!.items.map((e) => FakeCheckin(e as Checkin)).toList();
        checkins.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        setState(() {
          _checkins = checkins;
        });
      }
      return callback(
          Status.withSuccess(message: "checkins loaded (if there were any)"));
    } catch (e) {
      return callback(Status.withError(error: e.toString()));
    }
  }

  Stream<GraphQLResponse> _getCheckinsStream(Function(Status) callback) {
    try {
      final request = GraphQLRequest(document: '''subscription MySubscription {
  onCreateCheckin {
    event {
      id
    }
    id
    user
    userName
    createdBy
    createdByName
    createdAt
  }
}''');

      // final subscriprionRequest = ModelSubscriptions.onCreate(Checkin.classType);
      final Stream<GraphQLResponse> operation = Amplify.API
          .subscribe(request,
              onEstablished: () => {print("subscription established")})
          .handleError((e) => {
                setState(() => {
                      _error = e.toString(),
                    })
              });
      return operation;
    } catch (e) {
      return callback(Status.withError(error: e.toString()));
    }
  }
}

class FakeCheckin {
  late String id;
  late String user;
  late String userName;
  late String createdBy;
  late String createdByName;
  late DateTime createdAt;
  late String createdAtString;

  late String eventId;

  FakeCheckin(Checkin checkin) {
    id = checkin.id;
    user = checkin.user;
    createdBy = checkin.createdBy;
    createdByName = checkin.createdByName;
    createdAt = checkin.createdAt!.getDateTimeInUtc().toLocal();
    eventId = checkin.event.id;

    _loadDateString();
  }

  //{event: {id: 792a4ba3-f4ca-47b5-910b-1d32fbd57e78}, id: 30f3b625-d32e-446a-bcbc-cf412d6f0bcf, user: john3, createdBy: john3, createdAt: 2022-12-05T03:34:33.373Z}
  FakeCheckin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    createdBy = json['createdBy'];
    createdAt = DateTime.parse(json['createdAt']).toLocal();
    eventId = json['event']['id'];
    _loadDateString();
  }

  _loadDateString() {
    final DateFormat formatter = DateFormat('MMM d, yyyy h:mm a');
    createdAtString = formatter.format(createdAt);
  }
}
