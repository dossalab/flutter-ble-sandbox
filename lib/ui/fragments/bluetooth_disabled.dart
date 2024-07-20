import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ble_sandbox/providers/ble.dart';
import 'package:provider/provider.dart';

class BluetoothDisabledFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(
          Icons.bluetooth_disabled,
          size: 70.0,
        ),
        RichText(
            textAlign: TextAlign.center,
            text:
                TextSpan(style: DefaultTextStyle.of(context).style, children: [
              const TextSpan(
                  style: TextStyle(fontWeight: FontWeight.bold),
                  text: 'Bluetooth is disabled\n'),
              TextSpan(
                  text: 'Tap here',
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () =>
                        Provider.of<BleProvider>(context, listen: false)
                            .requestBluetoothEnable()),
              const TextSpan(text: ' to request it'),
            ])),
      ]));
}
