import 'package:auto_route/auto_route.dart';

import '../ui/help.dart';
import '../ui/main_screen.dart';
import '../ui/sparring.dart';
import '../ui/stop_watch.dart';
import '../ui/timer_screen.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(path: '/', page: MainRoute.page, children: [
      AutoRoute(path: 'timer', page: TimerRoute.page),
      AutoRoute(path: 'stopwatch', page: StopWatchRoute.page),
      AutoRoute(path: 'sparring', page: SparringRoute.page),
      AutoRoute(path: 'help', page: HelpRoute.page),
    ]),
  ];
}