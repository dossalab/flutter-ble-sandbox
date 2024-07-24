import 'dart:async';
import 'dart:collection';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/model/ble_device.dart';
import 'package:flutter_ble_sandbox/model/devices/symas107g.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logging/logging.dart' as logging;

class BleProvider extends ChangeNotifier {
  final log = logging.Logger('BleProvider');

  final _bleContext = FlutterReactiveBle();
  final _discoveredDevices = HashSet<DiscoveredDevice>(
      equals: (d1, d2) => d1.id == d2.id, hashCode: (d1) => 0);

  DeviceConnectionState? _connectionState;
  StreamSubscription<DiscoveredDevice>? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  BleDevice? _managedDevice;

  Set<DiscoveredDevice> get discoveredDevices => _discoveredDevices;

  bool get isBluetoothDisabled => _bleContext.status == BleStatus.poweredOff;
  bool get isScanningAllowed => _bleContext.status == BleStatus.ready;

  bool get isDeviceConnected =>
      _connectionSubscription != null &&
      !_connectionSubscription!.isPaused &&
      _connectionState == DeviceConnectionState.connected &&
      _managedDevice != null;

  bool get isConnecting => _connectionState == DeviceConnectionState.connecting;
  bool get isDisconnecting =>
      _connectionState == DeviceConnectionState.disconnecting;
  bool get isScanning =>
      _scanSubscription != null && !_scanSubscription!.isPaused;
  bool get isInProgress => isScanning | isConnecting | isDisconnecting;

  BleDevice? get managedDevice => _managedDevice;

  BleProvider() {
    _bleContext.statusStream.listen((status) {
      switch (status) {
        case BleStatus.poweredOff:
          finishScan();
          disconnect();
          break;
        default:
          break;
      }
      notifyListeners();
    });
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

  void startScan() {
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
    log.info('cancelling scan subscription');

    _scanSubscription?.cancel();
    _scanSubscription = null;
    notifyListeners();
  }

  void connect(String deviceId) {
    if (!isDeviceConnected) {
      if (isScanning) {
        finishScan();
      }

      log.info('initiating connection');

      _connectionSubscription = _bleContext
          .connectToDevice(
              connectionTimeout: const Duration(seconds: 5), id: deviceId)
          .listen((event) {
        switch (event.connectionState) {
          case DeviceConnectionState.connecting:
            log.info('connect: managing a new device');
            _managedDevice =
                Symas107g(deviceId: deviceId, notifyListeners: notifyListeners);
            break;

          case DeviceConnectionState.connected:
            log.info('connect: mounting device');
            _managedDevice?.mount(_bleContext);
            break;

          case DeviceConnectionState.disconnected:
            log.info('connect: disconnected');
            disconnect();
            break;

          default:
            break;
        }

        _connectionState = event.connectionState;
        log.info('connect: connection state transition: $_connectionState');
        notifyListeners();
      }, onError: (e) {
        log.warning('connect: connection error thrown');
        notifyListeners();
      }, onDone: () {
        log.info('connect: done');
        notifyListeners();
      }, cancelOnError: true);
    }
  }

  void disconnect() {
    _managedDevice?.unmount();
    _managedDevice = null;
    _connectionSubscription?.cancel();
    _connectionSubscription = null;
    _connectionState = DeviceConnectionState.disconnected;

    notifyListeners();
  }

  cancelConnection() => disconnect();
}
