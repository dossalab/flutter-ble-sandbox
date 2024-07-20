import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final IconData? icon;
  final Widget caption;

  const EmptyState({super.key, this.icon, required this.caption});

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        icon != null
            ? Icon(
                icon,
                size: 70.0,
              )
            : Container(),
        caption
      ]));
}
