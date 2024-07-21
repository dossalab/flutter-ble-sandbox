import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/providers/ble.dart';
import 'package:flutter_ble_sandbox/ui/main_page_fragment.dart';
import 'package:flutter_ble_sandbox/ui/widgets/empty_state.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ScannerFragment implements MainPageFragment {
  @override
  get bottomNavBarItem => BottomNavigationBarItem(
      icon: Consumer<BleProvider>(
          builder: (context, ble, _) => Badge(
              isLabelVisible: ble.isScanning, child: const Icon(Icons.search))),
      label: 'Scanner');

  @override
  get contents => _ScannerContents();

  @override
  get fab => _ScannerFab();

  @override
  get title => 'Scanner';
}

class _ScannerContents extends StatelessWidget {
  @override
  Widget build(context) => Consumer<BleProvider>(
        builder: (context, ble, _) => ble.isBluetoothDisabled
            ? const EmptyState(
                icon: Icons.bluetooth_disabled,
                reason: 'Bluetooth is disabled',
              )
            : ble.isScanningAllowed
                ? _DeviceList()
                : _PermissionRequestFragment(),
      );
}

class _ScannerFab extends StatelessWidget {
  @override
  Widget build(context) => Consumer<BleProvider>(
      builder: (context, ble, _) => Visibility(
          visible: ble.isScanningAllowed,
          child: ble.isScanning
              ? FloatingActionButton(
                  child: const Icon(Icons.clear),
                  onPressed: () => ble.finishScan(),
                )
              : FloatingActionButton(
                  onPressed: () => ble.startScan(),
                  child: const Icon(Icons.search))));
}

class _PermissionRequestFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ble = Provider.of<BleProvider>(context, listen: false);
    return EmptyState(
        icon: Icons.location_pin,
        reason: 'Location access is needed to scan',
        hint: Text.rich(TextSpan(children: [
          TextSpan(
              text: 'Tap here',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  var isGranted = await ble.requestScannerPermission();
                  if (isGranted) {
                    ble.startScan();
                  }
                }),
          const TextSpan(text: ' to request it, or head to your '),
          TextSpan(
              text: 'settings',
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () => openAppSettings()),
          const TextSpan(text: ' and edit permissions manually'),
        ])));
  }
}

class _DeviceList extends StatelessWidget {
  @override
  Widget build(context) => Consumer<BleProvider>(
      builder: (context, ble, _) => ble.discoveredDevices.isEmpty
          ? const EmptyState(
              icon: Icons.sync,
              reason: 'No devices discovered',
              hint: Text('Try scanning!'))
          : RefreshIndicator(
              notificationPredicate: (_) => !ble.isScanning,
              onRefresh: () async {
                ble.startScan();
              },
              child: ListView(
                  children: ble.discoveredDevices
                      .map((device) => _DeviceListTile(device))
                      .toList())));
}

class _DeviceListTile extends StatelessWidget {
  final DiscoveredDevice _device;

  const _DeviceListTile(this._device);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(Icons.bluetooth),
        title: Text(
          _device.name,
          maxLines: 1,
        ),
        subtitle: Text(_device.id, maxLines: 1),
        onTap: () {
          print('someone tapped me O_o');
        },
      );
}
