import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../router/app_routes.dart';

@RoutePage()
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  var initialized = false;

  Future setup() async {
    if (!initialized) {
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    setup();
    return AutoTabsScaffold(
      routes: const [
        TimerRoute(),
        StopWatchRoute(),
        SparringRoute(),
        // HelpRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) => buildBottomBar(tabsRouter),
    );
  }

  Widget buildBottomBar(TabsRouter tabsRouter) {
    return BottomNavigationBar(
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        BottomNavigationBarItem(
            icon: Icon(Symbols.watch), label: 'StopWatch'),
        BottomNavigationBarItem(icon: Icon(Icons.accessibility), label: 'Sparring'),
        // BottomNavigationBarItem(
        //     icon: Icon(Icons.help), label: 'Help'),
      ],
      currentIndex: tabsRouter.activeIndex,
      onTap: (index) {
        setState(() {
          tabsRouter.setActiveIndex(index);
        });
      },
    );
  }
}
