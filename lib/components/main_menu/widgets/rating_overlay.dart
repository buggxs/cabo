import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RatingOverlay extends StatefulWidget {
  const RatingOverlay({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<RatingOverlay> createState() => _RatingOverlayState();
}

class _RatingOverlayState extends State<RatingOverlay> {
  bool showDialog = false;

  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        preferencesPrefix: 'rateMyApp_',
        minDays: 2,
        remindDays: 7,
        minLaunches: 2,
        remindLaunches: 2,
        googlePlayIdentifier: 'com.buggxs.cabo',
      ),
      builder: (context) {
        return Container(
          child: widget.child,
        );
      },
      onInitialized: (context, rateMyApp) {
        for (Condition condition in rateMyApp.conditions) {
          if (condition is DebuggableCondition) {
            condition
                .printToConsole(); // We iterate through our list of conditions and we print all debuggable ones.
          }
        }

        if (kDebugMode) {
          print(
              'Are all conditions met : ${rateMyApp.shouldOpenDialog ? 'Yes' : 'No'}');
        }

        if (true) {
          rateMyApp.showRateDialog(context);
        }
      },
    );
  }
}
