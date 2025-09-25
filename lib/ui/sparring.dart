import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ring_helper/ui/custom_stopwatch.dart';
import 'package:utilities/utilities.dart';

@RoutePage(name: 'SparringRoute')
class Sparring extends ConsumerStatefulWidget {
  const Sparring({super.key});

  @override
  ConsumerState<Sparring> createState() => _SparringState();
}

class _SparringState extends ConsumerState<Sparring> {
  int redCount = 0;
  int whiteCount = 0;

  // Default styles (Portrait)
  TextStyle redTitleStyle = const TextStyle(fontSize: 48, color: Colors.red);
  TextStyle whiteTitleStyle =
      const TextStyle(fontSize: 48, color: Colors.white);
  TextStyle numberTextStyle =
      const TextStyle(fontSize: 36, color: Colors.white);
  TextStyle whiteNumberTextStyle =
      const TextStyle(fontSize: 36, color: Colors.black);

  bool whiteSquareOnLeft = true;
  final StopwatchController _stopwatchController = StopwatchController();

  @override
  void dispose() {
    _stopwatchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    // Define adaptive styles and spacing
    final isLandscape = orientation == Orientation.landscape;

    final currentRedTitleStyle = redTitleStyle.copyWith(
      fontSize: isLandscape ? 32 : 48,
    );
    final currentWhiteTitleStyle = whiteTitleStyle.copyWith(
      fontSize: isLandscape ? 32 : 48,
    );
    final currentNumberTextStyle = numberTextStyle.copyWith(
      fontSize: isLandscape ? 28 : 36,
    );
    final currentWhiteNumberTextStyle = whiteNumberTextStyle.copyWith(
      fontSize: isLandscape ? 28 : 36,
    );

    final verticalSpaceLarge = isLandscape ? 8.0 : 16.0;
    final verticalSpaceMedium = isLandscape ? 4.0 : 8.0;
    final verticalSpaceSmall = isLandscape ? 2.0 : 4.0;
    final timerFontSize = isLandscape ? 20.0 : 28.0; // Changed portrait from 36.0

    return Scaffold( // Scaffold is now the top-level widget
      backgroundColor: Colors.black,
      body: SafeArea( // SafeArea is now inside the Scaffold's body
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                addVerticalSpace(verticalSpaceLarge),
                titleRow(
                  redStyle: currentRedTitleStyle,
                  whiteStyle: currentWhiteTitleStyle,
                ),
                addVerticalSpace(verticalSpaceLarge),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: getSquares(
                        redTextStyle: currentNumberTextStyle,
                        whiteTextStyle: currentWhiteNumberTextStyle,
                      )),
                ),
                addVerticalSpace(verticalSpaceMedium),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          whiteSquareOnLeft = !whiteSquareOnLeft;
                        });
                      },
                      child: const Text('Swap')),
                ),
                addVerticalSpace(verticalSpaceSmall),
                addVerticalSpace(verticalSpaceMedium),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Divider(),
                ),
                buildButtonRow(timerFontSize: timerFontSize),
              ],
            ),
          ),
      ),
    );
  }

  Widget buildTimer({required double fontSize}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_stopwatchController.isRunning) {
            _stopwatchController.stop();
          } else {
            _stopwatchController.start();
          }
        },
        child: CustomStopwatch(
          controller: _stopwatchController,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget buildButtonRow({required double timerFontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        kGap8, // Assuming kGap8 is small enough or defined elsewhere
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                resetLeft();
              },
              child: const Text('Reset')),
          kGap8,
          Row(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  incrementLeft();
                },
                mini: true,
                tooltip: 'Add',
                heroTag: 'addLeft', // Unique heroTag
                child: const Icon(Icons.exposure_plus_1),
              ),
              kGap8,
              FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    decrementLeft();
                  });
                },
                mini: true,
                tooltip: 'Minus',
                heroTag: 'minusLeft', // Unique heroTag
                child: const Icon(Icons.exposure_minus_1),
              ),
            ],
          ),
        ]),
        kGap8,
        buildTimer(fontSize: timerFontSize),
        kGap8,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  resetRight();
                },
                child: const Text('Reset')),
            kGap8,
            Row(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    incrementRight();
                  },
                  mini: true,
                  tooltip: 'Add',
                  heroTag: 'addRight', // Unique heroTag
                  child: const Icon(Icons.exposure_plus_1),
                ),
                kGap8,
                FloatingActionButton(
                  onPressed: () async {
                    decrementRight();
                  },
                  mini: true,
                  tooltip: 'Minus',
                  heroTag: 'minusRight', // Unique heroTag
                  child: const Icon(Icons.exposure_minus_1),
                ),
              ],
            ),
          ],
        ),
        kGap8,
      ],
    );
  }

  void decrementRed() {
    setState(() {
      if (redCount > 0) {
        redCount--;
      }
    });
  }

  void decrementWhite() {
    setState(() {
      if (whiteCount > 0) {
        whiteCount--;
      }
    });
  }

  void incrementWhite() {
    setState(() {
      whiteCount++;
    });
  }

  void incrementRed() {
    setState(() {
      redCount++;
    });
  }

  void incrementLeft() {
    if (whiteSquareOnLeft) {
      incrementWhite();
    } else {
      incrementRed();
    }
  }

  void incrementRight() {
    if (whiteSquareOnLeft) {
      incrementRed();
    } else {
      incrementWhite();
    }
  }

  void decrementLeft() {
    if (whiteSquareOnLeft) {
      decrementWhite();
    } else {
      decrementRed();
    }
  }

  void decrementRight() {
    if (whiteSquareOnLeft) {
      decrementRed();
    } else {
      decrementWhite();
    }
  }

  void resetLeft() {
    if (whiteSquareOnLeft) {
      setState(() {
        whiteCount = 0;
      });
    } else {
      setState(() {
        redCount = 0;
      });
    }
  }

  void resetRight() {
    if (whiteSquareOnLeft) {
      setState(() {
        redCount = 0;
      });
    } else {
      setState(() {
        whiteCount = 0;
      });
    }
  }

  Widget titleRow({required TextStyle redStyle, required TextStyle whiteStyle}) {
    final titles = <Widget>[];
    if (whiteSquareOnLeft) {
      titles.add(AutoSizeText('White', style: whiteStyle));
      titles.add(addHorizontalSpace(8));
      titles.add(AutoSizeText(
        'Red',
        style: redStyle,
      ));
    } else {
      titles.add(AutoSizeText(
        'Red',
        style: redStyle,
      ));
      titles.add(addHorizontalSpace(8));
      titles.add(AutoSizeText('White', style: whiteStyle));
    }
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: titles);
  }

  Widget buildRedSquare({required TextStyle textStyle}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            redCount++;
          });
        },
        child: Container(
          color: Colors.red,
          child:
              Center(child: Text(redCount.toString(), style: textStyle)),
        ),
      ),
    );
  }

  Widget buildWhiteSquare({required TextStyle textStyle}) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            whiteCount++;
          });
        },
        child: Container(
          color: Colors.white,
          child: Center(
              child: Text(whiteCount.toString(), style: textStyle)),
        ),
      ),
    );
  }

  List<Widget> getSquares({required TextStyle redTextStyle, required TextStyle whiteTextStyle}) {
    final squares = <Widget>[];
    if (whiteSquareOnLeft) {
      squares.add(buildWhiteSquare(textStyle: whiteTextStyle));
      squares.add(addHorizontalSpace(16)); // This could also be made adaptive if needed
      squares.add(buildRedSquare(textStyle: redTextStyle));
    } else {
      squares.add(buildRedSquare(textStyle: redTextStyle));
      squares.add(addHorizontalSpace(16)); // This could also be made adaptive if needed
      squares.add(buildWhiteSquare(textStyle: whiteTextStyle));
    }
    return squares;
  }
}
