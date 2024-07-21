import 'dart:async';
import 'dart:collection';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleProvider extends ChangeNotifier {
  final _bleContext = FlutterReactiveBle();
  final _discoveredDevices = HashSet<DiscoveredDevice>(
      equals: (d1, d2) => d1.id == d2.id, hashCode: (d1) => 0);

  StreamSubscription<DiscoveredDevice>? _scanSubscription;

  Set<DiscoveredDevice> get discoveredDevices => _discoveredDevices;

  get isBluetoothDisabled => _bleContext.status == BleStatus.poweredOff;
  get isScanningAllowed => _bleContext.status == BleStatus.ready;

  get isScanning => _scanSubscription != null && !_scanSubscription!.isPaused;
  get isInProgress => isScanning;

  BleProvider() {
    _bleContext.statusStream.listen((status) => notifyListeners());
  }

  Future<void> requestScannerPermission() async {
    await Permission.location.request();
    notifyListeners();
  }

  void requestBluetoothEnable() async {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.bluetooth.adapter.action.REQUEST_ENABLE',
    );

    await intent.launch();
    notifyListeners();
  }

  Future<void> startScan() async {
    if (!isScanning) {
      discoveredDevices.clear();

      _scanSubscription =
          _bleContext.scanForDevices(withServices: []).listen((device) {
        if (device.name.isNotEmpty && _discoveredDevices.add(device)) {
          notifyListeners();
        }
      }, onError: (e) => finishScan(), onDone: () => finishScan());
    }
  }

  void finishScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    notifyListeners();
  }
}
