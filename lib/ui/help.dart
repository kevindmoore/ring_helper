import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage(name: 'HelpRoute')
class Help extends ConsumerStatefulWidget {
  const Help({super.key});

  @override
  ConsumerState<Help> createState() => _HelpState();
}

class _HelpState extends ConsumerState<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: ElevatedButton(
            onPressed: () {  },
            style: ButtonStyle(
              shape: WidgetStateProperty.all<CircleBorder>(
                  const CircleBorder(
                  )
              ),
            ),
            child: const Text('Call for Help'),
          ),
        ),
      ),
    );
  }
}
