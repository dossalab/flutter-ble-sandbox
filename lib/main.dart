import 'package:flutter/material.dart';
import 'ui/main_page.dart';
import 'package:provider/provider.dart';
import 'providers/ble.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (context) => BleProvider(), child: MainPage()));
