import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/services.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({required this.user, super.key});

  final AmplifyUser user;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _loadingVersion = true;
  late PackageInfo _packageInfo;

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
    return Column(
      children: [
        ListTile(
          title: const Text("App Name"),
          subtitle: Text(_packageInfo.appName),
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: _packageInfo.appName));
            // show toast

          },
        ),
        ListTile(
          title: const Text("Package Name"),
          subtitle: Text(_packageInfo.packageName),
        ),
        ListTile(
          title: const Text("Version"),
          subtitle: Text(_packageInfo.version),
        ),
        ListTile(
          title: const Text("Build Number"),
          subtitle: Text(_packageInfo.buildNumber),
        ),
        ListTile(
          title: const Text("Build Signature"),
          subtitle: Text(_packageInfo.buildSignature),
        ),
      ],
    );
  }
}
