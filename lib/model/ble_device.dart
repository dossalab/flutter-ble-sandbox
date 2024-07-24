import 'dart:ui';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

abstract class BleDevice {
  final VoidCallback notifyListeners;
  final String deviceId;

  BleDevice({required this.deviceId, required this.notifyListeners});

  void mount(FlutterReactiveBle bleContext);
  void unmount();
}
