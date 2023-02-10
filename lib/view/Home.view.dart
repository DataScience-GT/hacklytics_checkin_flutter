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
          child: Text("Hacklytics"),
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
                        // title: Flexible(
                        //   child: Row(children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(right: 8),
                        //       child: Text(
                        //         _events[index].name,
                        //       ),
                        //     ),
                        //     Chip(
                        //       label: _events[index].status == true
                        //           ? const Text("open")
                        //           : const Text("closed"),
                        //       backgroundColor: _events[index].status == true
                        //           ? Colors.green.shade500
                        //           : Colors.red.shade500,
                        //     )
                        //   ]),
                        // ),
                        subtitle: _events[index].description != null &&
                                _events[index].description!.isNotEmpty
                            ? Text(_events[index].description ?? "")
                            : null,
                        // enabled: _events[index].status == true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          // go to event page
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
