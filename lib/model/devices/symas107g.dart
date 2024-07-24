import 'dart:async';
import 'package:flutter_ble_sandbox/model/ble_device.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logging/logging.dart' as logging;

class Symas107g extends BleDevice {
  final log = logging.Logger('SymaS107g');
  final QualifiedCharacteristic _batteryLevelCharacteristic;
  int? _batteryLevel;

  StreamSubscription<List<int>>? _batteryLevelStream;
  int? get batteryLevel => _batteryLevel;

  Symas107g({required super.deviceId, required super.notifyListeners})
      : _batteryLevelCharacteristic = QualifiedCharacteristic(
            serviceId: Uuid.parse("180F"),
            characteristicId: Uuid.parse("2A19"),
            deviceId: deviceId);

  void updateBatteryLevel(List<int> incoming) {
    if (incoming.length == 1) {
      _batteryLevel = incoming[0];
      log.info('new battery level: $_batteryLevel');
      notifyListeners();
    } else {
      log.warning('bad characteristic length');
    }
  }

  @override
  void mount(FlutterReactiveBle bleContext) {
    _batteryLevelStream = bleContext
        .subscribeToCharacteristic(_batteryLevelCharacteristic)
        .listen(updateBatteryLevel, onError: (e) {
      log.warning('got error while listening for battery events - $e');
      _batteryLevel = null;
    });

    // read it once to get the initial value
    bleContext.readCharacteristic(_batteryLevelCharacteristic);
  }

  @override
  void unmount() {
    _batteryLevelStream?.cancel();
    _batteryLevelStream = null;
  }
}
