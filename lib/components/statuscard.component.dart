import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  const StatusCard({required this.message, required this.success, super.key});

  final String message;
  final bool success;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Card(
        color: success ? Colors.green.shade400 : Colors.red.shade400,
        child: Padding(padding: const EdgeInsets.all(24), child: Text(message)),
      ))
    ]);
  }
}
