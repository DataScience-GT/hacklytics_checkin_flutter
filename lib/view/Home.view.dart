import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/models/ModelProvider.dart';

import '../config.dart';
import '../model/AmplifyUser.dart';
import '../model/status.dart';
import '../models/Event.dart';

/// The home page
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late AmplifyUser _user;
  bool _loadingUser = true;
  late String _error = "";
  bool _loadingEvents = true;
  List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      getUserInfo((status) {
        if (status.success) {
          setState(() {
            _loadingUser = false;
          });
        } else {
          setState(() {
            _error = status.error.toString();
            _loadingUser = false;
          });
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(Config.appName),
      ),
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator())
          : _buildBody(),
    );
  }

  _buildBody() {
    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : _buildBodyLoadEvents();
  }

  _buildBodyLoadEvents() {
    if (_loadingEvents) {
      getEvents((status) {
        if (status.success) {
          setState(() {
            _loadingEvents = false;
          });
        } else {
          setState(() {
            _error = status.error.toString();
            _loadingEvents = false;
          });
        }
      });
    }

    return _loadingEvents
        ? const Center(child: CircularProgressIndicator())
        : _buildBodyWithEvents();
  }

  _buildBodyWithEvents() {
    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : Column(children: [
            ListTile(title: Text("Events:")),
            Expanded(
                child: ListView.separated(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_events[index].name),
                        subtitle: Text(_events[index].description ?? ""),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    }))
          ]);
  }

  getUserInfo(Function(Status) callback) async {
    try {
      AuthSession authSessions = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));

      if (authSessions.isSignedIn) {
        final accessToken =
            (authSessions as CognitoAuthSession).userPoolTokens?.accessToken;
        if (accessToken == null || accessToken.isEmpty) {
          callback(Status.withError(error: "No access token."));
          return;
        }

        var attributes = await Amplify.Auth.fetchUserAttributes();

        setState(() {
          _user = AmplifyUser(accessToken: accessToken, attributes: attributes);
        });

        callback(Status.withSuccess(message: "Got user info."));
      }
    } catch (err) {
      return callback(Status.withError(error: err));
    }
    // return callback(Status.withSuccess(message: "Success!"));
  }

  getEvents(Function(Status) callback) async {
    try {
      final request = ModelQueries.list(Event.classType);
      // final request = GraphQLRequest(
      //     document: req.document, apiName: "AMAZON_COGNITO_USER_POOLS", variables: );
      // request.apiName = "hacklyticsportal2023_AMAZON_COGNITO_USER_POOLS";
      final response = await Amplify.API.query(request: request).response;
      if (response.errors.isNotEmpty) {
        return callback(Status.withError(error: response.errors));
      }
      final events = response.data?.items;

      if (events != null && events.isNotEmpty) {
        setState(() {
          _events = events.map((x) => x as Event).toList();
        });
      }

      // print('Events: $events');
      return callback(Status.withSuccess(message: "Got events."));
    } on ApiException catch (e) {
      callback(Status.withError(error: e));
    }
  }
}
