import 'package:colorize_lumberdash/colorize_lumberdash.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utilities/utilities.dart';

import 'providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  putLumberdashToWork(withClients: [
    ColorizeLumberdash(),
  ]);
  if (isDesktop()) {
    await DesktopWindow.setWindowSize(const Size(700, 600));

    await DesktopWindow.setMinWindowSize(const Size(700, 600));
  }

  globalSharedPreferences = await SharedPreferences.getInstance();

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  var initialized = false;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (initialized) {
        return;
      }
      initialized = true;
      // ref.read(soundProvider).loadSound(alarm);
    });
    return MaterialApp.router(
      routerConfig: ref.read(routeProvider).config(),
      title: 'Ring Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        dividerTheme: const DividerThemeData(
          space: 0,
          thickness: 1,
        ),
        useMaterial3: true,
      ),
    );
  }
}
