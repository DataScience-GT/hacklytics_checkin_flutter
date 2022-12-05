import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/model/status.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

import 'package:hacklytics_checkin_flutter/models/Checkin.dart';

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
      // _getCheckins((status) => {
      //       setState(() => {_loadingCheckins = false, _error = status.error})
      //     });
      var x = _getCheckinsStream();
      x.listen((event) {
        print(event);
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
    try {
      final queryPredicate = Checkin.EVENT.eq(widget.event.id);
      final request =
          ModelQueries.list(Checkin.classType, where: queryPredicate);
      final response = await Amplify.API.query(request: request).response;
      if (response.errors.isNotEmpty) {
        return callback(Status.withError(error: response.errors.toString()));
      }
      var data = response.data;
      print(data);

      callback(Status.withSuccess(message: "Not implemented"));
    } catch (e) {
      callback(Status.withError(error: e.toString()));
    }
  }

  Stream<GraphQLResponse<Checkin>> _getCheckinsStream() {
    final subscriprionRequest = ModelSubscriptions.onCreate(Checkin.classType);
    final Stream<GraphQLResponse<Checkin>> operation = Amplify.API
        .subscribe(subscriprionRequest,
            onEstablished: () => {print("subscription established")})
        .handleError((e) => {
              setState(() => {
                    _error = e.toString(),
                  })
            });
    return operation;
  }
}
