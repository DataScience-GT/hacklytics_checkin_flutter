import 'package:flutter/material.dart';

class ConfirmToast extends StatelessWidget {
  const ConfirmToast({required this.labelText, super.key});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green.shade500,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check),
          const SizedBox(
            width: 12.0,
          ),
          Text(labelText),
        ],
      ),
    );
  }
}

class ErrorToast extends StatelessWidget {
  const ErrorToast({required this.labelText, super.key});

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red.shade500,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error),
          const SizedBox(
            width: 12.0,
          ),
          Text(labelText),
        ],
      ),
    );
  }
}
