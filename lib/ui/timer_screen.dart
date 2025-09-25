import 'package:auto_route/auto_route.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lumberdash/lumberdash.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:ring_helper/sounds.dart';
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
    final orientation = MediaQuery.of(context).orientation;
    final isLandscape = orientation == Orientation.landscape;

    // Adaptive values
    final timerSizedBoxHeight = isLandscape ? 130.0 : 250.0; // Changed from 140.0
    final  timerPaddingVertical = isLandscape ? 8.0 : 16.0;
    final  timerDiameter = isLandscape ? 100.0 : 180.0;
    final  timerStrokeWidth = isLandscape ? 15.0 : 20.0;
    final  timerTextStyleFontSize = isLandscape ? 20.0 : 33.0;

    final  pickerColumnVerticalSpacing = isLandscape ? 1.0 : 6.0; // Changed from 2.0
    final pickerLabelTextStyle =
        TextStyle(fontSize: isLandscape ? 12.0 : 14.0, color: Theme.of(context).textTheme.bodyLarge?.color); // Added color for visibility
    final  pickerItemHeight = isLandscape ? 28.0 : 45.0; // Changed from 30.0
    final  pickerItemWidth = isLandscape ? 40.0 : 50.0;

    final TextStyle resetButtonStyle = TextStyle(fontSize: isLandscape ? 10 : 12, inherit: false, color: Colors.black);


    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.isPaused.value ||
                      (!controller.isStarted.value &&
                          !controller.isResumed.value)) {
                    controller.restart(duration: getDuration());
                  } else {
                    controller.pause();
                  }
                },
                child: SizedBox(
                  height: timerSizedBoxHeight,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: timerPaddingVertical),
                    child: CircularCountDownTimer(
                      duration: getDuration(),
                      initialDuration: 0,
                      controller: controller,
                      width: timerDiameter,
                      height: timerDiameter,
                      ringColor: Colors.grey[300]!,
                      ringGradient: null,
                      fillColor: Colors.blue[300]!,
                      fillGradient: null,
                      backgroundColor: Colors.red[500],
                      backgroundGradient: null,
                      strokeWidth: timerStrokeWidth,
                      strokeCap: StrokeCap.round,
                      textStyle: TextStyle(
                          fontSize: timerTextStyleFontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      textFormat: CountdownTextFormat.S, // This is overridden by timeFormatterFunction
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
                        soundManager.playSound(alarm);
                        controller.reset();
                      },
                      onChange: (String timeStamp) {},
                      timeFormatterFunction:
                          (defaultFormatterFunction, duration) {
                        if (duration.inSeconds == 0) {
                          return 'Start';
                        } else {
                          return '${formatInt(duration.inHours)}:${getTime(duration.inMinutes % 60)}:${getTime(duration.inSeconds % 60)}';
                        }
                      },
                    ),
                  ),
                ),
              ),
              addVerticalSpace(isLandscape ? 4 : 16), // Changed from 8
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPickerColumn(
                      context,
                      'Hours',
                      hours,
                      0,
                      24,
                      (value) {
                        hours = value;
                        resetController();
                      },
                      () => setState(() => hours = 0),
                      pickerLabelTextStyle,
                      pickerItemHeight,
                      pickerItemWidth,
                      pickerColumnVerticalSpacing,
                      resetButtonStyle),
                  _buildPickerColumn(
                      context,
                      'Minutes',
                      minutes,
                      0,
                      59, // Max minutes should be 59
                      (value) {
                        minutes = value;
                        resetController();
                      },
                      () => setState(() => minutes = 0),
                      pickerLabelTextStyle,
                      pickerItemHeight,
                      pickerItemWidth,
                      pickerColumnVerticalSpacing,
                      resetButtonStyle),
                  _buildPickerColumn(
                      context,
                      'Seconds',
                      seconds,
                      0,
                      59, // Max seconds should be 59
                      (value) {
                        seconds = value;
                        resetController();
                      },
                      () => setState(() => seconds = 0),
                      pickerLabelTextStyle,
                      pickerItemHeight,
                      pickerItemWidth,
                      pickerColumnVerticalSpacing,
                      resetButtonStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerColumn(
    BuildContext context,
    String label,
    int currentValue,
    int minValue,
    int maxValue,
    ValueChanged<int> onChanged,
    VoidCallback onReset,
    TextStyle labelStyle,
    double itemHeight,
    double itemWidth,
    double verticalSpacing,
    TextStyle buttonTextStyle,
  ) {
    return Column(
      children: [
        Text(label, style: labelStyle),
        addVerticalSpace(verticalSpacing),
        NumberPicker(
          value: currentValue,
          minValue: minValue,
          maxValue: maxValue,
          itemHeight: itemHeight,
          itemWidth: itemWidth,
          textStyle: TextStyle(fontSize: labelStyle.fontSize), // Match label font size for picker numbers
          selectedTextStyle: TextStyle(fontSize: (labelStyle.fontSize ?? 14) * 1.2, color: Colors.blue), // Slightly larger for selected
          onChanged: onChanged,
          decoration: BoxDecoration( // Optional: add border to see bounds
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        addVerticalSpace(verticalSpacing),
        ElevatedButton(
          onPressed: onReset,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: itemWidth * 0.3, vertical: itemHeight * 0.15),
            // textStyle: buttonTextStyle, // Removed from here
            minimumSize: Size(itemWidth * 0.8, itemHeight * 0.6) // Ensure button is not too large
          ),
          child: Text('Reset', style: buttonTextStyle), // Applied directly to Text widget
        ),
      ],
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
    // Already handled modulo in timeFormatterFunction, so number should be < 60
    return formatInt(number);
  }

  void resetController() {
    // controller.reset(); // Resetting might clear the initial duration display before start
    // If you want to see the new duration immediately, restart and pause
    if (controller.isStarted.value || controller.isResumed.value || controller.isPaused.value) {
       // Only if timer was active or paused, otherwise it clears to 0 on first change
    }
    // To ensure the CircularCountDownTimer widget itself rebuilds with new 'duration'
    // when a number picker changes, but without auto-starting:
    // A simple setState is enough if CircularCountDownTimer takes 'getDuration()' directly
    // and its internal logic correctly handles re-initialization of display if not started.
    // The current CircularCountDownTimer might need controller.duration = new_duration if such API exists,
    // or controller.reset() + manually setting text IF the library allows.
    // Simplest for now is to allow it to reset, user has to tap start again.
    controller.reset(); 
    setState(() {});
  }
}
