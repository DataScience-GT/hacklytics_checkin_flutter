import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';

import 'package:flutter/material.dart';

import 'package:hacklytics_checkin_flutter/model/user.dart';
import 'package:hacklytics_checkin_flutter/view/write.nfc.view.dart';

class UserListView extends StatefulWidget {
  const UserListView({super.key});

  @override
  State<UserListView> createState() => _UserListViewState();
}

class _UserListViewState extends State<UserListView> {
  bool _loading = false;
  List<dynamic> _users = [];
  // late List<dynamic> _filteredUsers;
  String currentSearch = "";
  late String _error = "";

  @override
  Widget build(BuildContext context) {
    // if (_loading == true) {
    //   getUsers((data, error) {
    //     if (error != null && error.isNotEmpty) {
    //       setState(() {
    //         _error = error;
    //         _loading = false;
    //       });
    //     } else {
    //       setState(() {
    //         _users = data;
    //         // _filteredUsers = data;
    //         _loading = false;
    //       });
    //     }
    //   });
    // }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Users"),
        ),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : (_error.isNotEmpty
                    ? Row(children: [
                        Expanded(
                            child: Card(
                          color: Colors.red.shade400,
                          child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Text(_error)),
                        ))
                      ])
                    : Column(children: [
                        Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(children: [
                              Expanded(
                                child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Search",
                                    hintText: "Enter a name...",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      currentSearch = value;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  getUsers((data, error) {
                                    if (error != null && error.isNotEmpty) {
                                      setState(() {
                                        _error = error;
                                        _loading = false;
                                        currentSearch = "";
                                      });
                                    } else {
                                      setState(() {
                                        _users = data;
                                        // _filteredUsers = data;
                                        _loading = false;
                                        currentSearch = "";
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.search),
                              )
                            ])),
                        Expanded(
                            child: ListView.separated(
                          itemCount: _users.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(_users[index].attributes["name"]),
                                subtitle:
                                    Text(_users[index].attributes["email"]),
                                trailing: const Icon(Icons.save_as),
                                onTap: () => {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  WriteNfcView(
                                                      user: _users[index])))
                                    });
                          },
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                        ))
                      ]))));
  }

  getUsers(Function(dynamic data, dynamic error) callback) async {
    if (currentSearch == "") {
      return;
    }
    setState(() {
      _loading = true;
    });
    // hacklytics record is of the form hacklytics://<id>
    var request = GraphQLRequest(document: '''
          query {
            getUserByName(userName: "$currentSearch")
          }
          ''');
    var response = await Amplify.API.query(request: request).response;

    // print(response);
    var data = response.data;
    // var getUserById = data['getUserById'];
    var res = ResponseListUsers(data);
    callback(res.users, res.error);
  }
}

class ResponseListUsers {
  late List<dynamic> users = [];
  late String error = "";
  ResponseListUsers(String data) {
    print(data);
    var json = jsonDecode(data);
    var listUsers = jsonDecode(json['getUserByName']);
    var statusCode = listUsers['statusCode'];
    var body = listUsers['body'];
    if (statusCode == 200) {
      // success
      List<dynamic> usersStr = body['users'];

      for (var userStr in usersStr) {
        User user = User(userStr);
        users.add(user);
      }
    } else {
      // error
      error = body["error"].toString();
    }
  }
}
