import 'package:auto_route/auto_route.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:utilities/utilities.dart';

import '../providers.dart';

@RoutePage(name: 'TimerRoute')
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  int hours = 0;
  int minutes = 2;
  int seconds = 0;
  var controller = CountDownController();

  int getDuration() {
    return (hours * 60 * 60) + (minutes * 60) + seconds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                logMessage('Resumed: ${controller.isResumed}');
                logMessage('isPaused: ${controller.isPaused}');
                logMessage('isStarted: ${controller.isStarted}');
                logMessage('isRestarted: ${controller.isRestarted}');
                logMessage('Resumed: ${controller.isResumed}');
                logMessage('Resumed: ${controller.isResumed}');
                logMessage('Resumed: ${controller.isResumed}');
                if (controller.isPaused || (!controller.isStarted && !controller.isResumed)) {
                  logMessage('Starting Controller');
                  controller.restart(duration: getDuration());
                } else {
                  logMessage('Pausing Controller');
                  controller.pause();
                }
              },
              child: CircularCountDownTimer(
                duration: getDuration(),
                initialDuration: 0,
                controller: controller,
                width: MediaQuery.of(context).size.width / 2,
                height: MediaQuery.of(context).size.height / 2,
                ringColor: Colors.grey[300]!,
                ringGradient: null,
                fillColor: Colors.blue[300]!,
                fillGradient: null,
                backgroundColor: Colors.red[500],
                backgroundGradient: null,
                strokeWidth: 20.0,
                strokeCap: StrokeCap.round,
                textStyle: const TextStyle(
                    fontSize: 33.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textFormat: CountdownTextFormat.S,
                isReverse: true,
                isReverseAnimation: false,
                isTimerTextShown: true,
                autoStart: false,
                onStart: () {
                  logMessage(
                      'Countdown Started with duration ${getDuration()}');
                },
                onComplete: () {
                  final soundManager = ref.read(soundProvider);
                  soundManager.playSound(soundManager.soundId);
                  controller.reset();
                },
                onChange: (String timeStamp) {},
                timeFormatterFunction: (defaultFormatterFunction, duration) {
                  if (duration.inSeconds == 0) {
                    return 'Start';
                  } else {
                    return '${formatInt(duration.inHours)}:${getTime(duration.inMinutes)}:${getTime(duration.inSeconds)}';
                    // return Function.apply(defaultFormatterFunction, [duration]);
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Text('Hours'),
                    addVerticalSpace(8),
                    NumberPicker(
                      value: hours,
                      minValue: 0,
                      maxValue: 24,
                      onChanged: (value) {
                        hours = value;
                        resetController();
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hours = 0;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                addHorizontalSpace(8),
                Column(
                  children: [
                    const Text('Minutes'),
                    addVerticalSpace(8),
                    NumberPicker(
                      value: minutes,
                      minValue: 0,
                      maxValue: 60,
                      onChanged: (value) {
                        minutes = value;
                        resetController();
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          minutes = 0;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
                addHorizontalSpace(8),
                Column(
                  children: [
                    const Text('Seconds'),
                    addVerticalSpace(8),
                    NumberPicker(
                      value: seconds,
                      minValue: 0,
                      maxValue: 60,
                      onChanged: (value) {
                        seconds = value;
                        resetController();
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          seconds = 0;
                        });
                      },
                      child: const Text('Reset'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatInt(int number) {
    if (number < 10) {
      return '0$number';
    } else {
      return '$number';
    }
  }

  String getTime(int number) {
    if (number > 59) {
      return formatInt(number%60);
    } else {
      return formatInt(number);
    }
  }

  void resetController() {
    controller.reset();
    // controller.restart(duration: getDuration());
    // controller.pause();
    // controller = CountDownController();
    setState(() {});
  }
}
