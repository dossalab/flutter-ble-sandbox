import 'package:flutter/material.dart';
import 'package:flutter_ble_sandbox/ui/main_page_fragment.dart';

class HomeFragment implements MainPageFragment {
  @override
  get bottomNavBarItem =>
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home');

  @override
  get contents => _HomeContents();

  @override
  get fab => null;

  @override
  get title => 'Home';
}

class _HomeContents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Homepage'));
  }
}
