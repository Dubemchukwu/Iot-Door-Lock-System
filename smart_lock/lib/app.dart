import 'package:flutter/material.dart';
import 'package:smart_lock/core/router.dart';
import 'package:smart_lock/core/utils/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: SAppTheme.lightTheme,
      darkTheme: SAppTheme.darkTheme,
      title: 'Smart Lock',
      routerConfig: router,
    );
  }
}
