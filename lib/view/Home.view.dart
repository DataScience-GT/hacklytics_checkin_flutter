import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';

import 'package:hacklytics_checkin_flutter/components/statuscard.component.dart';
import 'package:hacklytics_checkin_flutter/models/ModelProvider.dart';
import 'package:hacklytics_checkin_flutter/view/event.view.dart';
import 'package:hacklytics_checkin_flutter/view/nfc.view.dart';
import 'package:hacklytics_checkin_flutter/view/settings.view.dart';

import 'package:hacklytics_checkin_flutter/config.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:hacklytics_checkin_flutter/model/status.dart';
import 'package:hacklytics_checkin_flutter/models/Event.dart';

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
              child: Text("Hacklytics 2024"),
            ),
            _loadingUser == false && _error.isEmpty && _user.hasAccess
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
                  return SettingsView(user: _user);
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
        : (_events.isEmpty
            ? const Center(child: Text("No events found."))
            : _buildBodyWithEvents());
  }

  _buildBodyWithEvents() {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return _error.isNotEmpty
        ? StatusCard(message: _error, success: false)
        : RefreshIndicator(
            // child: ListView(children: [
            //   ListView.builder(
            //     shrinkWrap: true,
            //     physics: const ClampingScrollPhysics(),
            //     itemBuilder: (context, index) {
            //       return const ListTile(title: Text("Test Tile"));
            //     },
            //     itemCount: 12,
            //   ),
            // ]),

            child: ListView(children: [
              ListViewCard(labelText: "Events", children: [
                ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Chip(
                          label: _events[index].status == true
                              ? const Text("open")
                              : const Text("closed"),
                          backgroundColor: _events[index].status == true
                              ? Colors.green.shade500
                              : Colors.red.shade500,
                        ),
                        title: Text(_events[index].name),
                        subtitle: _events[index].description != null &&
                                _events[index].description!.isNotEmpty
                                && _events[index].start != null &&
                                _events[index].location != null
                            ? Text("${_events[index].description ?? ""}\n"
                            "Location: ${_events[index].location ?? ""}\n")
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // TODO: implement
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EventView(
                                      event: _events[index], user: _user)));
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    })
              ])
            ]),
            onRefresh: () async {
              setState(() {
                _loadingEvents = true;
                _error = "";
                _events = [];
              });
            });
  }

  getUserInfo(Function(Status) callback) async {
    try {
      AuthSession authSessions = await Amplify.Auth.fetchAuthSession(
          options: CognitoSessionOptions(getAWSCredentials: true));

      if (authSessions.isSignedIn) {
        final accessToken =
            (authSessions as CognitoAuthSession).userPoolTokens?.accessToken;
        if (accessToken == null || accessToken.raw.isEmpty) {
          callback(Status.withError(error: "No access token."));
          return;
        }
        var attributes = await Amplify.Auth.fetchUserAttributes();

        setState(() {
          _user = AmplifyUser(accessToken: accessToken.raw, attributes: attributes);
        });

        callback(Status.withSuccess(message: "Got user info."));
      }
    } catch (err) {
      return callback(Status.withError(error: err));
    }
  }

  getEvents(Function(Status) callback) async {
    try {
      var request = GraphQLRequest(document: '''
          query ListEvents(
            \$limit: Int
            \$nextToken: String
          ) {
            listEvents(
              limit: \$limit
              nextToken: \$nextToken
              filter: {
                _deleted: {
                  ne: true
                }
              }
            ) {
              items {
                id
                name
                description
                status
                requireRSVP
                canRSVP
                start
                end
                location
                points
                createdAt
                updatedAt
                _version
                _deleted
                _lastChangedAt
              }
              nextToken
              startedAt
            }
          }
      ''');

      var operation = Amplify.API.query(request: request);
      var response = await operation.response;
      if (response.errors.isNotEmpty) {
        return callback(Status.withError(error: response.errors));
      }
      var data = response.data;
      var json = jsonDecode(data);
      var eventsJson = json['listEvents']['items'];

      if (eventsJson != null && eventsJson.isNotEmpty) {
        List<Event> events = eventsJson.map<Event>((item) {
          return Event.fromJson(item);
        }).toList();
        setState(() {
          _events = events;
        });
      }
      return callback(Status.withSuccess(message: "Got events."));
    } on ApiException catch (e) {
      callback(Status.withError(error: e));
    }
  }
}
