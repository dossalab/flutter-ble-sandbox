import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/providers/ble.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';

class DeviceConnectionButton extends StatelessWidget {
  final DiscoveredDevice? _device;

  const DeviceConnectionButton(this._device, {super.key});

  @override
  Widget build(BuildContext context) {
    var ble = context.watch<BleProvider>();

    final String buttonCaption;
    VoidCallback? action;
    final isDeviceConnectable = _device?.connectable == Connectable.available;
    final isConnectedDeviceSelected =
        _device?.id == ble.managedDevice?.deviceId;

    if (ble.isDisconnecting) {
      buttonCaption = 'Disconnecting...';
    } else if (ble.isConnecting) {
      if (isConnectedDeviceSelected) {
        buttonCaption = 'Connecting...';
      } else {
        buttonCaption = 'Connecting to another device...';
      }
    } else if (ble.isDeviceConnected) {
      if (isConnectedDeviceSelected) {
        buttonCaption = 'Disconnect';
        action = () => ble.disconnect();
      } else {
        buttonCaption = 'Connected to another device';
      }
    } else {
      if (_device != null && isDeviceConnectable) {
        buttonCaption = 'Connect';
        action = () => ble.connect(_device.id);
      } else {
        buttonCaption = 'Connection is not possible';
      }
    }

    return FilledButton(
      onPressed: action,
      child: Text(buttonCaption),
    );
  }
}
