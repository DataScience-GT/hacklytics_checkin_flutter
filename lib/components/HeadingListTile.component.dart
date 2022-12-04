import 'package:flutter/material.dart';

class HeadingListTile extends StatelessWidget {
  const HeadingListTile({required this.labelText, super.key});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
      labelText,
      style: Theme.of(context).textTheme.headline5,
    ));
  }
}
