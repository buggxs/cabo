import 'dart:async';

import 'package:cabo/misc/utils/logger.dart';
import 'package:cabo/misc/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';

class StatisticInfoCard extends StatefulWidget {
  const StatisticInfoCard({
    this.title,
    this.content,
    this.shouldBeTimer = false,
    super.key,
  });

  final String? title;
  final String? content;
  final bool shouldBeTimer;

  @override
  State<StatisticInfoCard> createState() => _StatisticInfoCardState();
}

class _StatisticInfoCardState extends State<StatisticInfoCard>
    with LoggerMixin {
  final Stopwatch _stopwatch = Stopwatch();
  late Duration _elapsedTime;
  late String _elapsedTimeString;
  late Timer timer;

  @override
  void initState() {
    super.initState();

    _elapsedTime = Duration.zero;
    _elapsedTimeString = _formatElapsedTime(_elapsedTime);

    // Create a timer that runs a callback every 100 milliseconds to update UI
    if (widget.shouldBeTimer) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        log.info('Game duration: $_elapsedTimeString');
        setState(() {
          // Update elapsed time only if the stopwatch is running
          if (_stopwatch.isRunning) {
            _updateElapsedTime();
          }
        });
      });
    }

    if (!_stopwatch.isRunning && widget.shouldBeTimer) {
      _stopwatch.start();
    }
  }

  // Update elapsed time and formatted time string
  void _updateElapsedTime() {
    setState(() {
      _elapsedTime = _stopwatch.elapsed;
      _elapsedTimeString = _formatElapsedTime(_elapsedTime);
    });
  }

  // Format a Duration into a string (MM:SS.SS)
  String _formatElapsedTime(Duration time) {
    return '${time.inHours.remainder(60).toString().padLeft(2, '0')}:${(time.inMinutes.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(12.0),
      color: CaboTheme.secondaryBackgroundColor,
      shadowColor: Colors.black,
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4.0,
          horizontal: 16.0,
        ),
        child: Column(
          children: [
            if (widget.title != null)
              Text(
                widget.title!,
                style: CaboTheme.primaryTextStyle.copyWith(
                  height: 0,
                  fontFamily: 'Archivo Black',
                  color: CaboTheme.fourthColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            if (!widget.shouldBeTimer)
              Text(
                widget.content ?? 'Empty',
                style: CaboTheme.numberTextStyle.copyWith(
                  height: 0,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            if (widget.shouldBeTimer)
              Text(
                _elapsedTimeString,
                style: CaboTheme.numberTextStyle.copyWith(
                  height: 0,
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
