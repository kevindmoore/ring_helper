import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

// 1. Create the Controller
class StopwatchController extends ChangeNotifier {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(isLapHours: false,
    presetMillisecond: StopWatchTimer.getMilliSecFromMinute(2),
    mode: StopWatchMode.countDown, // Ensure it's a stopwatch
  );

  Stream<int> get rawTime => _stopWatchTimer.rawTime;
  bool get isRunning => _stopWatchTimer.isRunning; // Expose running state if needed

  String get displayTime => StopWatchTimer.getDisplayTime(
    _stopWatchTimer.rawTime.value, // Get current value
    hours: false,
    minute: true,
    second: true,
    milliSecond: false,
  );

  void start() {
    _stopWatchTimer.onStartTimer();
    // notifyListeners(); // Notify if needed immediately (e.g., for button state)
  }

  void stop() {
    _stopWatchTimer.onStopTimer();
    // notifyListeners(); // Notify if needed immediately
  }

  void reset() {
    _stopWatchTimer.onResetTimer();
    // notifyListeners(); // Notify if needed immediately
  }

  // Add lap functionality if needed
  // void addLap() { _stopWatchTimer.onAddLap(); }

  @override
  void dispose() {
    _stopWatchTimer.dispose();
    super.dispose();
  }

  // Constructor can optionally start the timer or listen internally
  StopwatchController() {
    // Listen to rawTime to trigger notifications for UI updates
    // This is less efficient than StreamBuilder but needed for ChangeNotifier
    _stopWatchTimer.rawTime.listen((_) {
      notifyListeners();
    });
  }
}

// 2. Modify the Widget to Use the Controller
class CustomStopwatch extends StatelessWidget {
  final StopwatchController controller;
  final double fontSize; // Allow passing font size

  const CustomStopwatch({
    super.key,
    required this.controller,
    this.fontSize = 48, // Default font size
  });

  @override
  Widget build(BuildContext context) {
    // Listen to the controller for updates
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return AutoSizeText(
          controller.displayTime,
          style: TextStyle(
            fontSize: fontSize, // Use the passed font size
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
          textAlign: TextAlign.center,
        );
      },
    );
  }
}


