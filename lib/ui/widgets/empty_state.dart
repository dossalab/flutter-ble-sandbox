import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String reason;
  final Widget? hint;

  const EmptyState(
      {super.key, required this.icon, required this.reason, this.hint});

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(25.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(
          icon,
          size: 70.0,
        ),
        const SizedBox(height: 10),
        Text(
          reason,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        hint != null
            ? DefaultTextStyle.merge(
                style: const TextStyle(fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
                child: hint!)
            : Container(),
      ]));
}
