import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_lock/core/models/destination.dart';
import 'package:smart_lock/core/utils/constants/colors.dart';
import 'package:smart_lock/features/control/presentation/screens/control_screen.dart';
import 'package:smart_lock/features/door/presentation/screens/door_screen.dart';
import 'package:smart_lock/features/pin/presentation/screens/pin_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  initialLocation: '/door',
  navigatorKey: _rootNavigatorKey,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          LayoutScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.doorPage,
              builder: (context, state) => const DoorScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.pinPage,
              builder: (context, state) => const PinScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.controlPage,
              builder: (context, state) => const ControlScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class Routes {
  Routes._();

  static const String doorPage = "/door";
  static const String pinPage = "/pin";
  static const String controlPage = "/control";
}

class LayoutScaffold extends StatelessWidget {
  const LayoutScaffold({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey<String>('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: navigationShell,
    bottomNavigationBar: NavigationBar(
      backgroundColor: SColor.navBackgroundColor,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: navigationShell.goBranch,
      indicatorColor: SColor.navBackgroundColor,
      destinations: destinations
          .map(
            (destination) => NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Icon(destination.icon, color: SColor.textColor2, size: 24.0),
                  Positioned(
                    bottom: -20,
                    child: Text(
                      destination.label,
                      style: const TextStyle(
                        color: SColor.textColor2,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              label: '',
              selectedIcon: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Icon(destination.icon, color: SColor.white, size: 24.0),
                  Positioned(
                    bottom: -20,
                    child: Text(
                      destination.label,
                      style: const TextStyle(color: SColor.white, fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}
