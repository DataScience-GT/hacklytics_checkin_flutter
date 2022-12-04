import 'dart:ui';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:badges/badges.dart';

import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/models/ModelProvider.dart';
import 'package:hacklytics_checkin_flutter/view/nfc.view.dart';
import 'package:hacklytics_checkin_flutter/view/settings.view.dart';

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
      endDrawer: Drawer(
          child: ListView(children: [
        const DrawerHeader(
          child: Text("Hacklytics"),
        ),
        _loadingUser == false && _user.hasAccess
            ? Column(children: [
                ListTile(
                  title: const Text("General NFC"),
                  leading: const Icon(Icons.sensors),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const NfcView();
                    }));
                  },
                ),
                const Divider()
              ])
            : const SizedBox(
                width: 0,
                height: 0,
              ),
        ListTile(
          title: const Text("Settings"),
          leading: const Icon(Icons.settings),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const SettingsView();
            }));
          },
        ),
        const Divider(),
        ListTile(
          title: const Text("Logout"),
          leading: const Icon(Icons.logout),
          onTap: () {
            Amplify.Auth.signOut();
          },
        )
      ])),
    );
  }

  _buildBody() {
    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : _buildBodyCheckGroups();
  }

  _buildBodyCheckGroups() {
    return !_user.hasAccess
        ? StatusCard(
            message:
                "Invalid Access: Requires one of the following groups: ${Config.allowedGroups}",
            success: false)
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
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : Column(children: [
            ListTile(
                title: Text(
              "Events",
              style: textTheme.headline5,
            )),
            Expanded(
                child: ListView.separated(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(_events[index].name),
                          ),
                          Chip(
                            label: _events[index].status == true
                                ? const Text("open")
                                : const Text("closed"),
                            backgroundColor: _events[index].status == true
                                ? Colors.green.shade500
                                : Colors.red.shade500,
                          )
                        ]),
                        subtitle: Text(_events[index].description ?? ""),
                        enabled: _events[index].status == true,
                        onTap: () {
                          // go to event page
                          print("event pressed ${_events[index].name}");
                        },
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
