import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/providers/ble.dart';
import 'package:flutter_ble_sandbox/ui/fragments/home.dart';
import 'package:flutter_ble_sandbox/ui/fragments/scanner.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    final fragments = [
      HomeFragment(),
      ScannerFragment(),
    ];

    var currentFragment = fragments[_bottomNavIndex];

    return MaterialApp(
        title: 'Flutter Demo',
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: Scaffold(
          appBar: AppBar(
            title: Text(currentFragment.title),
            bottom: _BleProgressIndicator(),
          ),
          floatingActionButton: currentFragment.fab,
          bottomNavigationBar: BottomNavigationBar(
              items: fragments.map((page) => page.bottomNavBarItem).toList(),
              currentIndex: _bottomNavIndex,
              onTap: (index) => setState(() {
                    _bottomNavIndex = index;
                  })),
          body: currentFragment.contents,
        ));
  }
}

class _BleProgressIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) => Consumer<BleProvider>(
      builder: (context, ble, child) => Visibility(
          visible: ble.isInProgress, child: const LinearProgressIndicator()));

  @override
  Size get preferredSize => const Size.fromHeight(4.0);
}
