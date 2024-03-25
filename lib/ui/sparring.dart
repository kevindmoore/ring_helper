import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:utilities/utilities.dart';

import 'stop_watch_widget.dart';

@RoutePage(name: 'SparringRoute')
class Sparring extends ConsumerStatefulWidget {
  const Sparring({super.key});

  @override
  ConsumerState<Sparring> createState() => _SparringState();
}

class _SparringState extends ConsumerState<Sparring> {
  int redCount = 0;
  int whiteCount = 0;
  double width = 200;
  double height = 200;
  TextStyle redTitleStyle = const TextStyle(fontSize: 48, color: Colors.red);
  TextStyle whiteTitleStyle =
      const TextStyle(fontSize: 48, color: Colors.white);
  TextStyle numberTextStyle =
      const TextStyle(fontSize: 36, color: Colors.white);
  TextStyle whiteNumberTextStyle =
      const TextStyle(fontSize: 36, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              addVerticalSpace(16),
              titleRow(),
              addVerticalSpace(16),
              Expanded(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  buildWhiteSquare(),
                  addHorizontalSpace(16),
                  buildRedSquare(),
                ]),
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StopWatchWidget(Colors.white,
                      Duration(hours: 0, minutes: 2, seconds: 0), true),
                ],
              ),
              addVerticalSpace(8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Divider(),
              ),
              buildButtonRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                setState(() {
                  whiteCount = 0;
                });
              },
              child: const Text('Reset')),
          Row(
            children: [
              FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    whiteCount++;
                  });
                },
                mini: true,
                tooltip: 'Add',
                heroTag: null,
                child: const Icon(Icons.exposure_plus_1),
              ),
              FloatingActionButton(
                onPressed: () async {
                  setState(() {
                    if (whiteCount > 0) {
                      whiteCount--;
                    }
                  });
                },
                mini: true,
                tooltip: 'Minus',
                heroTag: null,
                child: const Icon(Icons.exposure_minus_1),
              ),
            ],
          ),
        ]),
        addHorizontalSpace(16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    redCount = 0;
                  });
                },
                child: const Text('Reset')),
            Row(
              children: [
                FloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      redCount++;
                    });
                  },
                  mini: true,
                  tooltip: 'Add',
                  heroTag: null,
                  child: const Icon(Icons.exposure_plus_1),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    setState(() {
                      if (redCount > 0) {
                        redCount--;
                      }
                    });
                  },
                  mini: true,
                  tooltip: 'Minus',
                  heroTag: null,
                  child: const Icon(Icons.exposure_minus_1),
                ),
              ],
            ),
          ],
        ),
        addVerticalSpace(8),
      ],
    );
  }

  Widget titleRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('White', style: whiteTitleStyle),
      addVerticalSpace(8),
      Text(
        'Red',
        style: redTitleStyle,
      ),
    ]);
  }

  Widget buildRedSquare() {
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
              Center(child: Text(redCount.toString(), style: numberTextStyle)),
        ),
      ),
    );
  }

  Widget buildWhiteSquare() {
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
              child: Text(whiteCount.toString(), style: whiteNumberTextStyle)),
        ),
      ),
    );
  }
}
