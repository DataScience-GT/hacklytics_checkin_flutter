import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/components/HeadingListTile.component.dart';
import 'package:hacklytics_checkin_flutter/components/ListViewCard.component.dart';
import 'package:hacklytics_checkin_flutter/components/toast.component.dart';
import 'package:hacklytics_checkin_flutter/main.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({required this.user, super.key});

  final AmplifyUser user;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _loadingVersion = true;
  late PackageInfo _packageInfo;

  late FToast ftoast;

  @override
  Widget build(BuildContext context) {
    if (_loadingVersion) {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          _packageInfo = value;
          _loadingVersion = false;
        });
      });
    }

    return Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: _buildWithVersionInfo(context));
  }

  _buildWithVersionInfo(BuildContext context) {
    return _loadingVersion
        ? const Center(child: CircularProgressIndicator())
        : _buildBody(context);
  }

  _buildBody(BuildContext context) {
    ftoast = FToast();
    ftoast.init(globalKey.currentState!.context);
    return SingleChildScrollView(
        child: Column(
      children: [
        // const HeadingListTile(labelText: "App Info"),
        // const Divider(),
        ListViewCard(labelText: "App Info", children: [
          ListTile(
            title: const Text("App Name"),
            subtitle: Text(_packageInfo.appName),
            onLongPress: () {
              _copyToClipboard(_packageInfo.appName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Package Name"),
            subtitle: Text(_packageInfo.packageName),
            onLongPress: () {
              _copyToClipboard(_packageInfo.packageName);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Version"),
            subtitle: Text(_packageInfo.version),
            onLongPress: () {
              _copyToClipboard(_packageInfo.version);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Build Number"),
            subtitle: Text(_packageInfo.buildNumber),
            onLongPress: () {
              _copyToClipboard(_packageInfo.buildNumber);
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Build Signature"),
            subtitle: Text(_packageInfo.buildSignature),
            onLongPress: () {
              _copyToClipboard(_packageInfo.buildSignature);
            },
          ),
        ]),

        // const HeadingListTile(labelText: "User Info"),
        // // const Divider(),
        ListViewCard(labelText: "User Info", children: [
          ListTile(
            title: const Text("Group(s)"),
            subtitle: Text(widget.user.groups.join(", ")),
            onLongPress: () {
              _copyToClipboard(widget.user.groups.join(", "));
            },
          ),
          const Divider(),
          _userAttributesMap()
        ])
      ],
    ));
  }

  _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    // show toast
    ftoast.showToast(
      child: const ConfirmToast(labelText: "Copied to clipboard"),
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  _userAttributesMap() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          var a = widget.user.attributes[index];
          return ListTile(
            title: Text(a.userAttributeKey.key.capitalize()),
            subtitle: Text(a.value),
            onLongPress: () {
              _copyToClipboard(a.value);
            },
          );
        },
        separatorBuilder: ((context, index) {
          return const Divider();
        }),
        itemCount: widget.user.attributes.length);
    // widget.user.attributes.map((e) => ListTile(
    //       title: Text(e.userAttributeKey.key.capitalize()),
    //       subtitle: Text(e.value),
    //       onLongPress: () {
    //         _copyToClipboard(e.value);
    //       },
    //     ));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
