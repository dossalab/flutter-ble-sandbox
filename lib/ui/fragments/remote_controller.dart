import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/model/devices/symas107g.dart';
import 'package:flutter_ble_sandbox/providers/ble.dart';
import 'package:flutter_ble_sandbox/ui/fragments/device_connection_button.dart';
import 'package:flutter_ble_sandbox/ui/main_page_fragment.dart';
import 'package:flutter_ble_sandbox/ui/widgets/empty_state.dart';
import 'package:provider/provider.dart';

class RemoteControllerFragment implements MainPageFragment {
  @override
  get bottomNavBarItem =>
      const BottomNavigationBarItem(icon: Icon(Icons.devices), label: 'Device');

  @override
  get contents => _RemoteControllerContents();

  @override
  get fab => null;

  @override
  get title => 'Controller';
}

class _RemoteControllerContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleProvider>();
    final device = ble.managedDevice;

    if (device is Symas107g) {
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Device\'s battery:'),
          Text(
            '${device.batteryLevel ?? '--'}',
            style: const TextStyle(fontSize: 100),
          ),
          Visibility(
              visible: ble.isDeviceConnected,
              // TODO: this is very similar to bottom sheet connection button, may be reuse?
              child: ElevatedButton(
                  onPressed: () => ble.disconnect(),
                  child: const Text('Disconnect')))
        ],
      ));
    } else {
      return const EmptyState(
        reason: 'Please connect the device first!',
        icon: Icons.no_drinks,
      );
    }
  }
}
