import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'ui/main_page.dart';
import 'package:provider/provider.dart';
import 'providers/ble.dart';

void main() {
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(ChangeNotifierProvider(
      create: (context) => BleProvider(), child: MainPage()));
}
