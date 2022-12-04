import 'package:flutter/material.dart';
import 'package:hacklytics_checkin_flutter/model/amplifyuser.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
        body: _buildWithVersionInfo());
  }

  _buildWithVersionInfo() {
    return _loadingVersion
        ? const Center(child: CircularProgressIndicator())
        : _buildBody();
  }

  _buildBody() {
    return Column(
      children: [
        ListTile(
          title: Text("AppName"),
          subtitle: Text(_packageInfo.appName),
        ),
        ListTile(
          title: Text("PackageName"),
          subtitle: Text(_packageInfo.packageName),
        ),
        ListTile(
          title: Text("Version"),
          subtitle: Text(_packageInfo.version),
        ),
        ListTile(
          title: Text("BuildNumber"),
          subtitle: Text(_packageInfo.buildNumber),
        ),
      ],
    );
  }
}
