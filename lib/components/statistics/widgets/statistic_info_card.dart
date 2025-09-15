import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:cabo/components/statistics/cubit/statistics_cubit.dart';
import 'package:cabo/misc/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  Timer? _timer; // Make timer nullable

  @override
  void initState() {
    super.initState();
    _elapsedTime = Duration.zero;
    _elapsedTimeString = _formatElapsedTime(_elapsedTime);

    if (widget.shouldBeTimer) {
      _startTimer();
    }
  }

  void _startTimer() {
    _stopwatch.start();
    // Create a timer that runs a callback every second to update UI
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      log.info('Game duration: $_elapsedTimeString');
      if (mounted) {
        // Check if widget is still mounted
        setState(() {
          if (_stopwatch.isRunning) {
            _updateElapsedTime();
          }
        });
      }
    });
  }

  void _updateElapsedTime() {
    _elapsedTime = _stopwatch.elapsed;
    _elapsedTimeString =
        context.read<StatisticsCubit>().state.game?.gameDuration ??
        _formatElapsedTime(_elapsedTime);
  }

  String _formatElapsedTime(Duration time) {
    return '${time.inHours.remainder(60).toString().padLeft(2, '0')}:${(time.inMinutes.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Only cancel if timer exists
    _stopwatch.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(12.0),
        color: CaboTheme.secondaryBackgroundColor,
        shadowColor: Colors.black,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
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
                AutoSizeText(
                  _elapsedTimeString,
                  softWrap: true,
                  style: CaboTheme.numberTextStyle.copyWith(
                    height: 0,
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
