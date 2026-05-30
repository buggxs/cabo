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
      logger.info('Game duration: $_elapsedTimeString');
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
    final TextStyle valueStyle = CaboTheme.displayLargeStyle.copyWith(
      fontSize: 32,
      height: 1.0,
      color: CaboTheme.m3Primary,
    );

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: CaboTheme.surfaceContainer,
          borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
          border: Border.all(color: CaboTheme.surfaceVariant),
          boxShadow: const [
            BoxShadow(
              color: Color(0x143D3A35), // rgba(61,58,53,0.08)
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            if (widget.title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  widget.title!,
                  style: CaboTheme.labelLargeStyle.copyWith(
                    color: CaboTheme.onSurfaceVariant,
                  ),
                ),
              ),
            if (!widget.shouldBeTimer)
              Text(widget.content ?? 'Empty', style: valueStyle),
            if (widget.shouldBeTimer)
              AutoSizeText(
                _elapsedTimeString,
                softWrap: true,
                maxLines: 1,
                style: valueStyle,
              ),
          ],
        ),
      ),
    );
  }
}
