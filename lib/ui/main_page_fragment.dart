import 'package:flutter/widgets.dart';

abstract class MainPageFragment {
  final String title;
  final Widget contents;
  final Widget? fab;
  final BottomNavigationBarItem bottomNavBarItem;

  MainPageFragment(
      {required this.title,
      required this.contents,
      required this.fab,
      required this.bottomNavBarItem});
}
