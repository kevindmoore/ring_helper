import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_helper/ui/stop_watch.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:utilities/utilities.dart';

class StopWatchWidget extends ConsumerStatefulWidget {
  final Color textColor;
  final Duration startTime;
  final bool countDown;

  const StopWatchWidget(this.textColor, this.startTime, this.countDown,
      {super.key});

  @override
  ConsumerState<StopWatchWidget> createState() => _StopWatchWidgetState();
}

class _StopWatchWidgetState extends ConsumerState<StopWatchWidget> {
  int hours = 0;
  int minutes = 0;
  int seconds = 0;
  TextStyle style = const TextStyle(fontSize: 56, fontWeight: FontWeight.bold);
  String startButtonText = 'Start';
  StopWatchState state = StopWatchState.initial;
  late StopWatchTimer stopWatchTimer;
  int rawTime = 0;
  late StreamSubscription stopWatchSubscription;

  @override
  void initState() {
    super.initState();
    hours = widget.startTime.inHours;
    minutes = getTime(widget.startTime.inMinutes);
    seconds = getTime(widget.startTime.inSeconds);
    stopWatchTimer = StopWatchTimer(
        mode:
        widget.countDown ? StopWatchMode.countDown : StopWatchMode.countUp, presetMillisecond: widget.startTime.inMilliseconds);
    stopWatchSubscription = stopWatchTimer.rawTime.listen((value) {
      if (mounted) {
        setState(() {
          rawTime = value;
        });
      }
    });
  }


  @override
  void dispose() {
    stopWatchSubscription.cancel();
    super.dispose();
  }

  int getTime(int number) {
    if (number > 59) {
      return number % 60;
    } else {
      return number;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(StopWatchTimer.getDisplayTime(rawTime, milliSecond: false),
              style: style.copyWith(color: widget.textColor)),
        ]),
        addVerticalSpace(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  state = StopWatchState.initial;
                  stopWatchTimer.onResetTimer();
                  startButtonText = 'Start';
                  setState(() {});
                },
                child: const Text('Reset')),
            addHorizontalSpace(16),
            ElevatedButton(
                onPressed: () {
                  switch (state) {
                    case StopWatchState.initial:
                      stopWatchTimer.onStartTimer();
                      state = StopWatchState.started;
                      startButtonText = 'Pause';
                    case StopWatchState.started:
                      stopWatchTimer.onStopTimer();
                      state = StopWatchState.paused;
                      startButtonText = 'Resume';
                    case StopWatchState.paused:
                      stopWatchTimer.onStartTimer();
                      state = StopWatchState.started;
                      startButtonText = 'Pause';
                  }
                },
                child: Text(startButtonText)),
          ],
        ),
      ],
    );
  }
}
