import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'stop_watch_widget.dart';

enum StopWatchState { initial, started, paused }

@RoutePage(name: 'StopWatchRoute')
class StopWatch extends ConsumerStatefulWidget {
  const StopWatch({super.key});

  @override
  ConsumerState<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends ConsumerState<StopWatch> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: StopWatchWidget(
            Colors.black, Duration(hours: 0, minutes: 0, seconds: 0), false),
      ),
    );
  }
}
